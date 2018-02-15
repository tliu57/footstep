% Matching Pursuit Decomposition based on Gaussian Atom Time-Frequency Dictionary
clear; pack; close all; clc;

d = load('TrialBLR10')

n = fieldnames(d.data)
[r,c] = size(n)
n = cell2struct(n, 's',r);

[r1, c1] = size(d.data.(n(1).s));

sig = d.data.(n(1).s);
final = sig;

for i = 2:r
    sig = d.data.(n(i).s);
    final = [final sig];
end

B = final(:, 2);
% x = mean(B(1:100,:))* ones(r1, 1);
% B = B - x;
% Passing signal through a low-pass filter with cutoff of 150 Hz)
[X, Y] = butter(10, 300/400);
H = filter(X, Y, B);
H = H/norm(H);

% Initialize parameters

N = 16130;                 % Number of samples
delt = 10/N;             % Time difference Between Samples


Nf = 40;                       % Number of f for dictionary
fmin = 0.1;                     % Minimum f for dictionary
fmax = 300;                   % Maximum f for dictionary
Na = 80;                        % Number of a for dictionary
amin = 1/sqrt(2);                     % Minimum a for dictionary
amax = 500/sqrt(2);                   % Maximum a for dictionary
Nw = 1;                         % Number of waveforms
Niter = 30;                     % Number of MP iterations
Nd = Na*Nf;                     % Number of dictionary elements excluding time-shifts (including time-shifts, total number is Na*Nf*N)

% Pre-allocate memory
fprintf(1,'Pre-allocating memory...');
tmp_vec3 = zeros(Nd,1);
tmp_vec4 = zeros(Nd,1,'int32');
mp_dict = zeros(N,Nd);
coeff_mp = zeros(Niter,Nw);
tau_mp = zeros(Niter,Nw,'int32');
a_mp = zeros(Niter,Nw,'int32');
f_mp = zeros(Niter,Nw,'int32');
fprintf(1,'done.\n');

% Create dictionary and compute its FFT
fprintf(1,'Creating dictionary and computing its FFT...');
Nb2 = N/2;
t = [-Nb2:Nb2-1]'*delt;
t2 = t.^2;
TWO_PI = pi+pi; %Constant for 2Pi
fstep = (fmax-fmin)/(Nf-1); %How much to increase the frequency for each iteration.
omega = TWO_PI*(fmin+[0:Nf-1]*fstep);
count = 1;
astep = (amax/amin)^(1/(Na-1));
a = amin;
for i = 1 : Na,
    a2 = a*a;
    for j = 1 : Nf,
        % Gaussian atom
        mp_dict(1:N,count) = exp(-t2*a2).*cos(omega(j)*t);
        % Normalize
        mp_dict(1:N,count) = mp_dict(1:N,count)/norm(mp_dict(1:N,count),2);
        count = count+1;
    end
    a = a*astep;
end
% Symmetric dictionary elements => no flipping required
mp_dict_hat = fft(mp_dict);
fprintf(1,'done.\n');

% Generate signal(s): Nw waveforms stored columnwise in the variable `data'
fprintf(1,'Generating signal(s)...');
data = H;
store_data = data;
fprintf(1,'done.\n');

% Compute matching pursuit decomposition
fprintf(1,'Computing matching pursuit decomposition...\n');
for i = 1 : Nw,
    fprintf(1,'Waveform %d:\n',i);
    for j = 1 : Niter,
        % FFT the residual
        tmp_vec1 = fft(data(1:N,i));
        for k = 1 : Nd,
            % Multiply with FFT of dictionary element and IFFT
            tmp_vec2 = ifft(mp_dict_hat(1:N,k).*tmp_vec1);
            [tmp,tmp_vec4(k)] = max(abs(tmp_vec2));
            tmp_vec3(k) = tmp_vec2(tmp_vec4(k));
        end
        [tmp,ind] = max(abs(tmp_vec3));
        coeff_mp(j,i) = tmp_vec3(ind);
        tau_mp(j,i) = tmp_vec4(ind)-1;
        tmp = rem(ind-1,Nf);
        a_mp(j,i) = (ind-1-tmp)/Nf+1;
        f_mp(j,i) = tmp+1;
        % Residual
        data(1:N,i) = data(1:N,i) - coeff_mp(j,i)*[mp_dict(N-tmp_vec4(ind)+2:end,ind); mp_dict(1:N-tmp_vec4(ind)+1,ind)];
        fprintf(1,'...iteration %d complete\n',j);
    end
end
fprintf(1,'Done.\n');

% Waveform for which to plot matching pursuit decomposition result (1 <= w <= Nw)
w = 1;

% a, f, and tau
astep = (amax/amin)^(1/(Na-1));
a = amin*(astep.^[0:Na-1]'); 
a_mp = a(a_mp);
fstep = (fmax-fmin)/(Nf-1);
f = [fmin:fstep:fmax]'; 
f_mp = f(f_mp);
tau_mp = double(tau_mp);

% Plot matching pursuit decomposition results
f = zeros(N,1);
data = store_data;
figure, plot(t+N/2*delt,data);
iter = [1:Niter];
e = zeros(1,Niter);
for j = iter,
    g = exp(-a_mp(j,w)^2*t.^2).*cos(2*pi*f_mp(j,w)*t);
    g = g/norm(g);
    g = [g(N-tau_mp(j,w)+1:N); g(1:N-tau_mp(j,w))];
    f = f + coeff_mp(j,w)*g;
    e(j) = (norm(f-data)/norm(data))^2;
end
hold on, plot(t+N/2*delt,f,'r');
title(['Matching pursuit decomposition of waveform ' num2str(w)]); xlabel('time (sec)');
legend('original','MPD approx.');
figure, plot([0 iter],[1 e],'-o');
title('Residual signal energy fraction'); xlabel('MPD iteration no.');

% MPD-TFR
fmin_tfr = 0;
delf_tfr = 0.1;
%fmax_tfr = 1/delt/2;
fmax_tfr = 300;
fvec = [fmin_tfr:delf_tfr:fmax_tfr];
ind = find(tau_mp>N/2); tau_mp(ind) = tau_mp(ind)-N; % compensate shifts
[X,Y] = meshgrid(t,fvec);
Z = single(zeros(length(fvec),N));
for j = iter,
    Z = Z + coeff_mp(j,w)^2*exp(-(2*a_mp(j,w)^2)*(X-tau_mp(j,w)*delt).^2 - 4*pi^2*(Y-f_mp(j,w)).^2/(2*a_mp(j,w)^2));
end
figure, contour(t+N/2*delt,fvec,Z, 100);
axis xy;
xlabel('time (sec)');
ylabel('frequency (Hz)');
title('Cross-term free MPD-TFR');

% 
% 
% %Saving values for dictionary
% dlmwrite('coeff_mp.txt',coeff_mp,'delimiter',' ','precision','%10.6g');
% dlmwrite('tau_mp.txt',tau_mp,'delimiter',' ','precision','%10.6g');
% dlmwrite('a_mp.txt',a_mp,'delimiter',' ','precision','%10.6g');
% dlmwrite('f_mp.txt',f_mp,'delimiter',' ','precision','%10.6g');
% xlswrite('F_.xlsx',f, 'f','A1')
% xlswrite('Z_.xlsx',Z, 'Z','A1')