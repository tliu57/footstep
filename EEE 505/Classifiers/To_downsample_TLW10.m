clear all
close all

%Big Data loop
d = load('TrialTLW10'); %change to BLR10 to get the other

n = fieldnames(d.data);
[r,c] = size(n); 
n = cell2struct(n, 's', r);

sig = d.data.(n(1).s);
final = sig;

for i = 2:r
    sig = d.data.(n(i).s);
    final = [final sig];
end

[r2,c2] = size(final);
%resampling loop.
idx = 1;

x = final(:,1);
z = resample(x,1,2);
dsarray = z;
       
for i = 2:c2
    x = final(:,i);
    z = resample(x,1,2);
    dsarray = [dsarray z];
  
    idx = idx + 1;
end

save Downsampled_TrialTLW10.mat dsarray; %change to BLR10 for other