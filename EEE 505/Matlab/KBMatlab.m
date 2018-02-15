clear all

d = load('TrialBLR10');

n = fieldnames(d.data);
[r,c] = size(n);
n = cell2struct(n, 's', r);

for i = 22:22
    for j = 3:3
        t = d.data.(n(i).s);
        sen = t(3000:7000,j);
        TFR = tfrridh(sen);
        figure
        contour(abs(TFR));
        axis xy;
        axis([0,length(sen),0,300]);
        title(['Spectogram ', n(i).s, ' for Sensor ', num2str(j)]);
    end
end