%To test/implement the STFT of raw input signals using the spectrogram
%function in matlab

%spectrogram(X,WINDOS,NOVERLAP,NFFT,Fs)

%X is the raw signal to perform the SFFT on

%WINDOW as an integer, divides X into segements of length equal to that
%integer 

%NOVERLAP is the number of samples each segment of X overlaps

%NFFT specifies the number of frequency points used to caluclat the
%discrete Fourier Transform

%Fs is the sampling frequency, specified in Hz
clear; pack; close all; clc;
A = xlsread('Tests_4Sec_Offset.xls');

column = 44;

data = A(:,column);
t = 0.001:0.001:4;
t = t';
figure, plot(t,data);
title('raw signal'); xlabel('Time (S)'); ylabel('Magnitude (V)');

[S,F,T,P] = spectrogram(data,64,60,400,1000);
figure, surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
xlabel('Time (S)'); ylabel('Hz');
xlswrite('Saved_P.xlsx',P,'P','A1')