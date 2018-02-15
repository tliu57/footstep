%% Revised Spec Code

clear all
close all

d = load('TrialBLR10');

n = fieldnames(d.data);
[r,c] = size(n); 
n = cell2struct(n, 's', r);

% i is the trial, j is the sensor
idx = 1;

for i = 1:r
    for j = 1:4
        sig = d.data.(n(i).s);
        imgname(idx) = {(['Trial ', n(i).s,' for Sensor ', num2str(j)])};
        [S,F,T,P] = spectrogram(sig(:,j),64,60,400,1000);
        figure, surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
        view(0,90);
        xlabel('Time (S)'); ylabel('Hz');
        title(['Spectogram for ', imgname(idx)]);
        idx = idx + 1;
    end
end

%% Save Images
h=get(0,'children');
h=sort(h);
imgfile = 'Spectogram';
imgdir = fullfile('Images',imgfile);
if(exist('Images','file') == 0)
    mkdir('Images');
end
if(exist(fullfile('Images',imgfile),'file') == 0)
    mkdir(fullfile('Images',imgfile));
end

for x = 1:length(h)
    imgstr = imgname{x};
    print (h(x), '-dpdf', fullfile(imgdir, imgstr));
end
    