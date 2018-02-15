%Feature Extraction
%% Time marginal for Running and Walking
%-------------
% array = load('Downsampled_TrialBLR10','dsarray');
%
% w = array.dsarray;
% [r,c] = size(w);
% power = nextpow2(r);
% lth = 2^power;
% %lth = r;
%
% for i = 4:34
%     v = w(:,i);
%
%     [TFR, time, freq] = tfrpwv(v, 1:lth, 2048);%2048 x 8065
%     WDtime = sum(TFR(200,:));
%     WD_Walk1(i-3,:) = WDtime;
% end
%
% for i = 35:74
%     v = w(:,i);
%
%     [TFR, time, freq] = tfrpwv(v, 1:lth, 2048);%2048 x 8065
%     WDtime = sum(TFR(200,:));
%     WD_Run1(i-34,:) = WDtime;
% end
%
%
% array = load('Downsampled_TrialTLW10','dsarray');
%
% w = array.dsarray;
% [r,c] = size(w);
% lth = r;
%
% for i = 5:44
%     v = w(:,i);
%
%     [TFR, time, freq] = tfrpwv(v, 1:lth, 2048);%2048 x 8065
%     WDtime = sum(TFR(200,:));
%     WD_Walk2(i-4,:) = WDtime;
% end
%
% for i = 45:84
%     v = w(:,i);
%
%     [TFR, time, freq] = tfrpwv(v, 1:lth, 2048);%2048 x 8065
%     WDtime = sum(TFR(200,:));
%     WD_Run2(i-44,:) = WDtime;
% end
%
% %Walk matrix
% Wigner_Walk = [WD_Walk1; WD_Walk2];
% save Features_Walk.mat Wigner_Walk;
%
% %Run matrix
% Wigner_Run = [WD_Run1; WD_Run2];
% save Features_Run.mat Wigner_Run;


%% Time marginal for Multiple and Single
%-------------

array = load('data');

w = array.data;
[r,c] = size(w);
power = nextpow2(r);
lth = 2^power;

n = fieldnames(w);
[r1,c1] = size(n);
n = cell2struct(n, 's', r1);

idCW = 1:10;
idCR = 11:20;
idACW = 21:30;
idACR = 31:40;
idAW = 41:50;
idAR = 51:60;
idADW = 61:70;
idADR = 71:80;
idAAW = 81:90;
idAAR = 91:100;
idAAAW = 101:110;
idAAAR = 111:120;

idS = [idCW idCR idAW idAR];
idM = [idACW idACR idADW idADR idAAW idAAR idAAAW idAAAR];

lit = 0;
for z = 1:length(idS)
    i = idS(z);
    [x,y]= size(w.(n(i).s));
    for j = 1:y
       if(lit == 0)
           rnum = 1;
       else
           rnum = length(WD_Single) + 1;
       end
        sig = w.(n(i).s);
        v = sig(:,j);
        
        [TFR, time, freq] = tfrpwv(v, 1:lth, 2048);%2048 x 8065
        WDtime = sum(TFR(200,:));
        WD_Single(rnum,:) = WDtime;
        lit = lit+1;
    end
end

lit = 0;
for a = 1:length(idM)
    i = idM(a);
    [x,y]= size(w.(n(i).s));
    for j = 1:y
              if(lit == 0)
           rnum = 1;
       else
           rnum = length(WD_Multiple) + 1;
       end
        sig = w.(n(i).s);
        v = sig(:,j);
        
        [TFR, time, freq] = tfrpwv(v, 1:lth, 2048);%2048 x 8065
        WDtime = sum(TFR(200,:));
        WD_Multiple(rnum,:) = WDtime;
        lit = lit+1;
    end
end

%
%Single matrix
save Features_Single.mat WD_Single;

%Multiple matrix
save Features_Multiple.mat WD_Multiple;