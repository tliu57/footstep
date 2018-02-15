clear all;
close all;

array = load('Downsampled_TrialTLW10','dsarray');

% n = fieldnames(array);
% %[r,c] = size(n,ds;
% r = 8065;
% c = 102; %change to 102 for BLR10, 51 for TLR10
% n = cell2struct(n, 's', r);
w = array.dsarray;
[r,c] = size(w);

power = nextpow2(r);
lth = 2^power;
%lth = 8192;


    %imgname(idx) = {(['Trial ', n(i).s,' for Sensor ', num2str(j)])};
    
% idx = 1;
% for i = 6:6
i = 6;
v = w(:,i);

    
    figure(1);
    [TFR, time, freq] = tfrwv(v, 1:lth, 4096);
    imagesc(abs(TFR));
    axis xy;
    axis([2000, 5000, 0, 2000]);
    xlabel('Time (S)'); ylabel('Hz');
    
    figure(2);
    %contour(abs(TFR));
    imagesc(abs(TFR));
    axis([2000, 5000, 0, 2000]);
    xlabel('Time (S)'); ylabel('Hz');
    
    figure(3);
    [TFR1, time, freq] = tfrwv(v, 1:lth, 2048);
    imagesc(abs(TFR1));
    axis xy;
    axis([2000, 5000, 0, 1000]);
    xlabel('Time (S)'); ylabel('Hz');
    
     figure(4);
     %contour(abs(TFR1));
     imagesc(abs(TFR1));
     axis([2000, 5000, 0, 1000]);
    

    
%     h = window(@hamming,30);
%     [TFR_window, time, freq] = tfrwv(v, 1:lth, 4096, h);
%     %figure(i);
%     figure(2);
%     imagesc(abs(TFR_window));
%     axis xy;
%     %contour(abs(TFR));
%     axis([2000, 5000, 0, 2000]);
%     xlabel('Time (S)'); ylabel('Hz');
%     %title(['Wigner for ', imgname(idx)]);
%     title(sprintf('windowed Wigner for sensor %d',i));
    
%     idx = idx + 1;
% end
