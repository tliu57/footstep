clear all
close all

d1 = load('TrialKBR10');

n = fieldnames(d1.data);
[r,c] = size(n);
n = cell2struct(n, 's', r);

% i is the trial, j is the sensor
idx = 1;

for i = 1:r
    for j = 1:4
        sig = d1.data.(n(i).s);
        imgname(idx) = {(['Trial ', n(i).s,' for Sensor ', num2str(j)])};
        data = ambifunb(sig(5000:6000,j));
        figure,  axis tight; 
        contour(abs(data));
        axis xy;
        %axis([0,length(data),0,300]);
        title(['Ambifunb ', n(i).s, ' for Sensor ', num2str(j)]);
        idx = idx + 1;
    end
end