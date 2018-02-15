clear all;
close all;

%Trial sensor name vector 1x408.
d = load('TrialBLR10'); %change to BLR10 to get the other

n = fieldnames(d.data);
[r,c] = size(n); 
n = cell2struct(n, 's', r);

idx = 1;
for i = 1:r
    for j = 1:4
        imgname(idx) = {(['Trial ', n(i).s,' for Sensor ', num2str(j)])};
        idx = idx + 1;
    end
end

%Plotting downsampled part
array = load('Downsampled_TrialBLR10','dsarray');

w = array.dsarray;
[r,c] = size(w);

power = nextpow2(r);
lth = 2^power;
  
% idx = 1;
for i = 2:10:c
v = w(:,i);
    
%     figure;
%     [TFR, time, freq] = tfrwv(v, 1:lth, 4096);
%     imagesc(abs(TFR));
%     axis xy;
%     axis([1000, 6000, 0, 2000]);
%     xlabel('Time (S)'); ylabel('Hz');
%     title(['Wigner for ', imgname(i)]);
    
   
%     figure(2);
%     contour(abs(TFR));
%     axis([2000, 5000, 0, 2000]);
%     xlabel('Time (S)'); ylabel('Hz');
    
    figure;
    [TFR1, time, freq] = tfrwv(v, 1:lth, 2048);
    imagesc(abs(TFR1));
    axis xy;
    axis([2000, 5000, 0, 1000]);
    xlabel('Time (S)'); ylabel('Hz');
    title(['Wigner for ', imgname(i)]);
    
    figure;
    plot(v);
    xlabel('Time (S)'); ylabel('Amplitude');
    title(['Data for ', imgname(i)]);
    
%      figure(4);
%      contour(abs(TFR1));
%      axis([2000, 5000, 0, 1000]);

end
    
% % Save Images
% h=get(0,'children');
% h=sort(h);
% imgfile = 'Wigner';
% imgdir = fullfile('Images3',imgfile);
% if(exist('Images3','file') == 0)
%     mkdir('Images3');
% end
% if(exist(fullfile('Images3',imgfile),'file') == 0)
%     mkdir(fullfile('Images3',imgfile));
% end
% 
% for x = 1:length(h)
%     imgstr = imgname{x};
%     print (h(x), '-dpdf', fullfile(imgdir, imgstr));
% end
    

