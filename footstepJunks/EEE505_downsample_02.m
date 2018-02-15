clear all
close all

%Big Data loop
d = load('TrialTLW10'); %change to BLR10 to get the other

n = fieldnames(d.data);
[r,c] = size(n); 
n = cell2struct(n, 's', r);

[r1,c1] = size(d.data.(n(1).s));

sig = d.data.(n(1).s);
final = sig;

for i = 2:r
    sig = d.data.(n(i).s);
    final = [final sig];
end

%resampling loop.
idx = 1;

x = final(:,1);
z = resample(x,1,2);
dsarray = z;
       
for i = 2:r
    x = final(:,i);
    z = resample(x,1,2);
    dsarray = [dsarray z];
  
    idx = idx + 1;
end

save Downsampled_TrialTLW10.mat dsarray; %change to BLR10 for other


%         %plots
%         power = 2^nextpow2(length(x));
%         
%         figure();
%         plot(z);
%         ylabel('Amplitude'); xlabel('Time (s)');
%         title('resample');
%         
%         zfft = fftshift(fft(z,power));
%         freq = (1631/2)*linspace(0,1,power);
%         figure();
%         plot(freq,20*log10(zfft));
%         ylabel('magnitude in dB'); xlabel('Hz');
%         title('Z fft');
%         %End plots        
