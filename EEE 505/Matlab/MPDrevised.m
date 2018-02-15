% Matching Pursuit Decomposition based on Gaussian Atom Time-Frequency Dictionary
clear; pack; close all; clc;

idx = 0;
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


%% Initialize parameters

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
Nd = Na*Nf;                     % Number of dictionary elements excluding time-shifts (including time-shifts, total number is Na*Nf*N)

%% Pre-allocate memory
fprintf(1,'Pre-allocating memory...');
tmp_vec3 = zeros(Nd,1);
tmp_vec4 = zeros(Nd,1,'int32');
mp_dict = zeros(N,Nd);
coeff_mp = zeros(Niter,Nw);
coeff_file = strcat('coeff_mp',num2str(idx),'.mat');
tau_mp = zeros(Niter,Nw,'int32');
tau_file = strcat('tau_mp',num2str(idx),'.mat');
a_mp = zeros(Niter,Nw,'int32');
a_file = strcat('a_mp',num2str(idx),'.mat');
f_mp = zeros(Niter,Nw,'int32');
f_file = strcat('f_mp',num2str(idx),'.mat');
fprintf(1,'done.\n');

%% Create dictionary and compute its FFT
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
%% Symmetric dictionary elements => no flipping required
mp_dict_hat = fft(mp_dict);
fprintf(1,'done.\n');

%% Generate signal(s): Nw waveforms stored columnwise in the variable `data'

fprintf(1,'Generating signal(s)...');
data = final;
store_data = data;
fprintf(1,'done.\n');

%% Compute matching pursuit decomposition
fprintf(1,'Computing matching pursuit decomposition...\n');
for i = 1 : Nw,
    imgfolder = ['Trial ', n(i).s];
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

%% Waveform for which to plot matching pursuit decomposition result (1 <= w <= Nw)

% a, f, and tau
astep = (amax/amin)^(1/(Na-1));
a = amin*(astep.^[0:Na-1]'); 
a_mp = a(a_mp);
fstep = (fmax-fmin)/(Nf-1);
f = [fmin:fstep:fmax]'; 
f_mp = f(f_mp);
tau_mp = double(tau_mp);

% Plot matching pursuit decomposition results
for i = 1 : Nw,
f = zeros(N,1);
data = store_data;
figure(i), plot(t+N/2*delt,data(:,i));
iter = [1:Niter];
e = zeros(1,Niter);
for j = iter,
    g = exp(-a_mp(j,i)^2*t.^2).*cos(2*pi*f_mp(j,i)*t);
    g = g/norm(g);
    g = [g(N-tau_mp(j,i)+1:N); g(1:N-tau_mp(j,i))];
    f = f + coeff_mp(j,i)*g;
    e(j) = (norm(f-data(:,i))/norm(data(:,i)))^2;
end
hold on, plot(t+N/2*delt,f,'r');
titlestr = naming(i);
title(['Matching pursuit decomposition of' titlestr]);
figname(idxf) = strcat('MPD', titlestr);
idxf = idxf+1;
xlabel('time (sec)');
legend('original','MPD approx.');
figure(i + Nw), plot([0 iter],[1 e],'-o');
title(['Residual signal energy fraction for' titlestr]); xlabel('MPD iteration no.');
figname(idxf) = strcat('Residual', titlestr);
idxf = idxf+1;
end

% MPD-TFR
for i = 1 : Nw,
fmin_tfr = 0;
delf_tfr = 0.1;
%fmax_tfr = 1/delt/2;
fmax_tfr = 300;
fvec = [fmin_tfr:delf_tfr:fmax_tfr];
ind = find(tau_mp>N/2); 
tau_mp(ind) = tau_mp(ind)-N; % compensate shifts
[X,Y] = meshgrid(t,fvec);
Z = single(zeros(length(fvec),N));
for j = iter,
    Z = Z + coeff_mp(j,i)^2*exp(-(2*a_mp(j,i)^2)*(X-tau_mp(j,i)*delt).^2 - 4*pi^2*(Y-f_mp(j,i)).^2/(2*a_mp(j,i)^2));
end
figure(i + 2*Nw), contour(t+N/2*delt,fvec,Z, 100);
axis xy;
xlabel('time (sec)');
ylabel('frequency (Hz)');
titlestr = naming(i);
title(['Cross-term free MPD-TFR for', titlestr]);
figname(idxf) = strcat('TFR', titlestr);
idxf = idxf+1;
end

h=get(0,'children');
h=sort(h);
imgfile = 'MPD';
imgdir = fullfile('Images',imgfile);
if(exist('Images','file') == 0)
    mkdir('Images');
end
if(exist(fullfile(imgdir),'file') == 0)
    mkdir(fullfile(imgdir));
end

for x = 1:length(h)
    imgstr = num2str(cell2mat(figname(x)));
    print (h(x), '-dpdf', fullfile(imgdir, imgstr));
end
% 
% 
% %Saving values for dictionary
save(coeff_file,'coeff_mp');
save(tau_file,'tau_mp');
save(a_file,'a_mp');
save(f_file,'f_mp');
% xlswrite('F_.xlsx',f, 'f','A1')
% xlswrite('Z_.xlsx',Z, 'Z','A1')

close all;

javaaddpath(which('MatlabGarbageCollector.jar'))
jheapcl;