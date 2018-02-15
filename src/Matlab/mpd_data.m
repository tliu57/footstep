% Matching Pursuit Decomposition based on Gaussian Atom Time-Frequency Dictionary
clear; pack; close all; clc;

idx = 31;
idxs = 1+idx*20;
idxe = idxs + 19;
d = load('datacds.mat');

n1 = fieldnames(d.data);
[r,c] = size(n1);
n = cell2struct(n1, 's',r);

final = d.data.(n(1).s);
% final = d;
name(1) = n1(1);

idxn = 1;
idxf = 1;

for i = 1:r
    sig = d.data.(n(i).s);
    if(i == 1)
        final = sig;
    else
        final = [final sig];
    end
    
    [r1, c1] = size(d.data.(n(i).s));
    for j = 1:c1
        sensorname = [' Sensor ', num2str(j)];
        name(idxn) = strcat(n1(i), sensorname);
        idxn = idxn+1;
    end
end

naming = name(idxs:idxe);
B = final(:, idxs:idxe);

s = load('a_mp0.mat');
a_mp_d = s.a_mp;

s = load('tau_mp0.mat');
tau_mp_d = s.tau_mp;

s = load('coeff_mp0.mat');
coeff_mp_d = s.coeff_mp;

s = load('f_mp0.mat');
f_mp_d = s.f_mp;

% Initialize parameters

N = 4033;                      % Number of samples
delt = 10/N;                    % Time difference Between Samples


Nf = 40;                        % Number of f for dictionary
fmin = 0.1;                     % Minimum f for dictionary
fmax = 300;                     % Maximum f for dictionary
Na = 80;                        % Number of a for dictionary
amin = 6/sqrt(2);               % Minimum a for dictionary
amax = 500/sqrt(2);              % Maximum a for dictionary
Nw = 20;                         % Number of waveforms
Niter = 15;                     % Number of MP iterations
Ni = 2;
Nd = 20;                     % Number of dictionary elements excluding time-shifts (including time-shifts, total number is Na*Nf*N)


% Pre-allocate memory
fprintf(1,'Pre-allocating memory...');
tmp_vec3 = zeros(Nd,1);
tmp_vec4 = zeros(Nd,1,'int32');
mp_dict = zeros(N,Nd);
coeff_mp = zeros(Niter,Nw);
tau_mp = zeros(Niter,Nw,'int32');
a_mp = zeros(Niter,Nw,'int32');
f_mp = zeros(Niter,Nw,'int32');
cad_mp = zeros(Niter,Nw);
fprintf(1,'done.\n');


% Create dictionary and compute its FFT
fprintf(1,'Creating dictionary and computing its FFT...');
Nb2 = N/2;
t = [-Nb2:Nb2-1]'*delt;
t2 = t.^2;
TWO_PI = pi+pi; %Constant for 2Pi
count = 1;
for i = 1 : Nd,
    for j = 1 : 15,
        % Gaussian atom
        mult1 = exp(-a_mp_d(j,i).^2.*(t-tau_mp_d(j,i).*delt).^2);
        mult2 = cos(TWO_PI * f_mp_d(j,i)*(t- tau_mp_d(j,i)*delt));
        mult3 = coeff_mp_d(j,i);
        mult13 = mult3.*mult1;
        mult123 = mult3.*mult1.*mult2;
        %orig = mp_dict(1:N, count)
        mp_dict(1:N,count) = mp_dict(1:N,count) + mult123;
    end
    %     figure(i),
    %     plot(t, mp_dict(1:N, count));
    % Normalize
    mp_dict(1:N,count) = mp_dict(1:N,count)/norm(mp_dict(1:N,count),2);
    count = count+1;
end


% Symmetric dictionary elements => no flipping required
mp_dict_hat = fft(mp_dict);
tmp_vec1 = fft(B(1:N,i));
fprintf(1,'done.\n');

% Matching Cadence
% for i = 1:Nw
%     shat = zeros(N,1);
%     for j = 1:Ni,
%         for k = 1 : Nd,
%             tmp_vec2 = ifft(mp_dict_hat(1:N,k).*tmp_vec1);
%             [tmp,tmp_vec4(k)] = max(abs(tmp_vec2));
%             tmp_vec3(k) = tmp_vec2(tmp_vec4(k));
%         end
%         [tmp,ind] = max(abs(tmp_vec3));
%         coeff_mp(j,i) = tmp_vec3(ind);
%         element(j,i) = ind;
%         Residual
%         B(1:N,i) = B(1:N,i) - coeff_mp(j,i)*[mp_dict(N-tmp_vec4(ind)+2:end,ind); mp_dict(1:N-tmp_vec4(ind)+1,ind)];
%         fprintf(1,'...iteration %d complete\n',j);
%     end
% end

% Matching Cadence
for i = 1:Nw
shat = zeros(N,1);
for j = 1:Ni,
%     for k -0.05:0.005:0.05
    r = B(:, i) - shat;
    ip = mp_dict'*r;
    [y,ind] = max(abs(ip));
    alpha(j, i) = ip(ind(1));
    element(j, i) = ind(1)
    shat = shat + alpha(i)*mp_dict(1:N,ind(1));
end
end

% for i = 1:Nw
%     figure(i)
%     plot (t, B(:, i))
%     hold on
%     plot(t, shat,'r')
%     hold off
% end

for w = 1:Nw
f = zeros(N,1);
data = B;
figure, plot(t+N/2*delt,data);
iter = [1:Ni];
e = zeros(1, Ni);
for j = iter,
    g = mp_dict(1:N,element(j, w));
    f = f + alpha(j,w)*g;
    e(j) = (norm(f-data(:, w))/norm(data(:, w)))^2;
end

figure, plot([0 iter],[1 e],'-o');
title('Residual signal energy fraction'); xlabel('MPD iteration no.');
end 
%
% % MPD-TFR
% fmin_tfr = 0;
% delf_tfr = 0.5;
% %fmax_tfr = 1/delt/2;
% fmax_tfr = 150;
% fvec = [fmin_tfr:delf_tfr:fmax_tfr];
% ind = find(tau_mp>N/2); tau_mp(ind) = tau_mp(ind)-N; % compensate shifts
% [X,Y] = meshgrid(t,fvec);
% Z = single(zeros(length(fvec),N));
% for j = 1:Niter,
%    %if (a_mp(j, w) > 13) & (abs(coeff_mp(j,w))>0.11000)
%     Z = Z + coeff_mp(j,w)^2*exp(-(2*a_mp(j,w)^2)*(X-tau_mp(j,w)*delt).^2 - 4*pi^2*(Y-f_mp(j,w)).^2/(2*a_mp(j,w)^2));
%    %end;
% end
% %figure, imagesc(t+N/2*delt,fvec,Z)
% figure, contour(t+N/2*delt,fvec,Z, 150);
% axis xy;
% xlabel('time (sec)');
% ylabel('frequency (Hz)');
% title('Cross-term free MPD-TFR');
%
%
% %Saving values for dictionary
% dlmwrite('coeff_mp.txt',coeff_mp,'delimiter',' ','precision','%10.6g');
% dlmwrite('tau_mp.txt',tau_mp,'delimiter',' ','precision','%10.6g');
% dlmwrite('a_mp.txt',a_mp,'delimiter',' ','precision','%10.6g');
% dlmwrite('f_mp.txt',f_mp,'delimiter',' ','precision','%10.6g');
% xlswrite('F_.xlsx',f, 'f','A1')
% xlswrite('Z_.xlsx',Z, 'Z','A1')