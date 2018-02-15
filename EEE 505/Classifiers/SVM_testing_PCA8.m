array = load('Downsampled_TrialBLR10','dsarray');

w = array.dsarray;
[r,c] = size(w);
lth = r;

for i = 4:34
    v = w(:,i);
  
    [TFR, time, freq] = tfrwv(v, 1:lth, 2048);%2048 x 8065
    TFRreshape = reshape(TFR,3303424,5);
    %reshape = reshape(TFR,8258560,2);
    [PCA1, score1, eig1] = princomp(TFRreshape); %5 x 5
    PCAselect = PCA1(:,1:2); %5 x 5
    colstack = PCAselect(:);
    rowstack = colstack';
    WD_Walk1(i-3,:) = rowstack(:,1:8);
end
 
for i = 35:74
    v = w(:,i);
  
    [TFR, time, freq] = tfrwv(v, 1:lth, 2048);%2048 x 8065
    TFRreshape = reshape(TFR,3303424,5);
    %reshape = reshape(TFR,8258560,2);
    [PCA1, score1, eig1] = princomp(TFRreshape); %5 x 5
    PCAselect = PCA1(:,1:2); %5 x 5
    colstack = PCAselect(:);
    rowstack = colstack';
    WD_Run1(i-34,:) = rowstack(:,1:8);
end
 

array = load('Downsampled_TrialTLW10','dsarray');

w = array.dsarray;
[r,c] = size(w);
lth = r;

for i = 5:44
    v = w(:,i);
  
    [TFR, time, freq] = tfrwv(v, 1:lth, 2048);%2048 x 8065
    TFRreshape = reshape(TFR,3303424,5);
    %reshape = reshape(TFR,8258560,2);
    [PCA1, score1, eig1] = princomp(TFRreshape); %5 x 5
    PCAselect = PCA1(:,1:2); %5 x 5
    colstack = PCAselect(:);
    rowstack = colstack';
    WD_Walk2(i-4,:) = rowstack(:,1:8);
end
 
for i = 45:84
    v = w(:,i);
  
    [TFR, time, freq] = tfrwv(v, 1:lth, 2048);%2048 x 8065
    TFRreshape = reshape(TFR,3303424,5);
    %reshape = reshape(TFR,8258560,2);
    [PCA1, score1, eig1] = princomp(TFRreshape); %5 x 5
    PCAselect = PCA1(:,1:2); %5 x 5
    colstack = PCAselect(:);
    rowstack = colstack';
    WD_Run2(i-44,:) = rowstack(:,1:8);
end

%Walk matrix
Wigner_Walk = [WD_Walk1; WD_Walk2];
save Wigner_Walk8.mat Wigner_Walk;

%Run matrix
Wigner_Run = [WD_Run1; WD_Run2];
save Wigner_Run8.mat Wigner_Run;