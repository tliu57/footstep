%% Put all directlda m-files in matlab

%% Run this part first
array = load('datacds');

w = array.data;
[r,c] = size(w);
power = nextpow2(r);
%lth = 2^power;
%lth = 4096;
lth = 8192;

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

%Singles
lit = 0;
for z = 1:length(idAR)
    i = idAR(z);
    [x,y]= size(w.(n(i).s));
    for j = 1:y
        if ((i >= 1 && i <= 9) && (j==5)) %remove bad data
        else
            if(lit == 0)
                rnum = 1;
            else
                rnum = length(WD_ChildWalkTM) + 1;
            end
            sig = w.(n(i).s);
            v = sig(:,j);
            va = hilbert(v);
            
            
            [TFR, time, freq] = tfrpwv(va, 1:lth, 2048);%2048 x 8065
            
%trimming section                        
            cutTFRfinal = TFR(100:5:400,1950:2000);
           
             colstack = cutTFRfinal(:);
             rowstack = colstack';
             RunVect(lit+1,:) = rowstack;
            
            WDtime = sum(TFR(200,:)); %ignore this part, from last time
            WD_ChildWalkTM(rnum,:) = WDtime; %ignore
            lit = lit+1;
        end
    end
end


lit = 0;
for z = 1:length(idAW)
    i = idAW(z);
    [x,y]= size(w.(n(i).s));
    for j = 1:y
        if ((i >= 1 && i <= 9) && (j==5)) %remove bad data
        else
            if(lit == 0)
                rnum = 1;
            else
                rnum = length(WD_ChildWalkTM) + 1;
            end
            sig = w.(n(i).s);
            v = sig(:,j);
            va = hilbert(v);
            
            [TFR, time, freq] = tfrpwv(va, 1:lth, 2048);%2048 x 8065

%trimming section                        
            cutTFRfinal = TFR(100:5:400,1950:2000);

             colstack = cutTFRfinal(:);
             rowstack = colstack';
             WalkVect(lit+1,:) = rowstack;
            
            WDtime = sum(TFR(200,:)); %ignore
            WD_ChildWalkTM(rnum,:) = WDtime; %ignore
            lit = lit+1;
        end
    end
end

%Vector matrix
ARAWVect = [RunVect; WalkVect];
save ARAWVector.mat ARAWVect;

lit = 0;
for z = 1:length(idCR)
    i = idCR(z);
    [x,y]= size(w.(n(i).s));
    for j = 1:y
        if ((i >= 1 && i <= 9) && (j==5)) %remove bad data
        else
            if(lit == 0)
                rnum = 1;
            else
                rnum = length(WD_ChildWalkTM) + 1;
            end
            sig = w.(n(i).s);
            v = sig(:,j);
            va = hilbert(v);
           
            
            [TFR, time, freq] = tfrpwv(va, 1:lth, 2048);%2048 x 8065

%trimming section                        
            cutTFRfinal = TFR(100:5:400,1950:2000);
         
             colstack = cutTFRfinal(:);
             rowstack = colstack';
             RunVect(lit+1,:) = rowstack;
            
            WDtime = sum(TFR(200,:)); %ignore this part, from last time
            WD_ChildWalkTM(rnum,:) = WDtime; %ignore
            lit = lit+1;
        end
    end
end


lit = 0;
for z = 1:length(idCW)
    i = idCW(z);
    [x,y]= size(w.(n(i).s));
    for j = 1:y
        if ((i >= 1 && i <= 9) && (j==5)) %remove bad data
        else
            if(lit == 0)
                rnum = 1;
            else
                rnum = length(WD_ChildWalkTM) + 1;
            end
            sig = w.(n(i).s);
            v = sig(:,j);
            va = hilbert(v);
            
            [TFR, time, freq] = tfrpwv(va, 1:lth, 2048);%2048 x 8065

%trimming section                        
            cutTFRfinal = TFR(100:5:400,1950:2000);
            
             colstack = cutTFRfinal(:);
             rowstack = colstack';
             WalkVect(lit+1,:) = rowstack;
            
            WDtime = sum(TFR(200,:)); %ignore
            WD_ChildWalkTM(rnum,:) = WDtime; %ignore
            lit = lit+1;
        end
    end
end
%Vector matrix
CRCWVect = [RunVect; WalkVect];
save CRCWVector.mat CRCWVect;

%Multiples

lit = 0;
for z = 1:length(idAAR)
    i = idAAR(z);
    [x,y]= size(w.(n(i).s));
    for j = 1:y
        if ((z ==3 || z == 7 || z == 8 || z == 9 || z == 10)) %remove lockstep bad data
        else
            if(lit == 0)
                rnum = 1;
            else
                rnum = length(WD_ChildWalkTM) + 1;
            end
            sig = w.(n(i).s);
            v = sig(:,j);
            va = hilbert(v);
            
            
            [TFR, time, freq] = tfrpwv(va, 1:lth, 2048);%2048 x 8065
            
%trimming section                        
            cutTFRfinal = TFR(100:5:400,1950:2000);
         
             colstack = cutTFRfinal(:);
             rowstack = colstack';
             Mult1(lit+1,:) = rowstack;
            
            WDtime = sum(TFR(200,:)); %ignore this part, from last time
            WD_ChildWalkTM(rnum,:) = WDtime; %ignore
            lit = lit+1;
        end
    end
end

lit = 0;
for z = 1:length(idAAAR)
    i = idAAAR(z);
    [x,y]= size(w.(n(i).s));
    for j = 1:y
        if (((z ==1) && (j==2)) || ((z ==2) && (j==4)) || ((z ==4) && (j==4)) || ((z ==7) && (j<=3)) || ((z ==10) && (j >=2 && j<=4)) ) %remove bad data
        else
            if(lit == 0)
                rnum = 1;
            else
                rnum = length(WD_ChildWalkTM) + 1;
            end
            sig = w.(n(i).s);
            v = sig(:,j);
            va = hilbert(v);
            
            [TFR, time, freq] = tfrpwv(va, 1:lth, 2048);%2048 x 8065

%trimming section                        
            cutTFRfinal = TFR(100:5:400,1950:2000);
            
             colstack = cutTFRfinal(:);
             rowstack = colstack';
             Mult3(lit+1,:) = rowstack;
            
            WDtime = sum(TFR(200,:)); %ignore
            WD_ChildWalkTM(rnum,:) = WDtime; %ignore
            lit = lit+1;
        end
    end
end

MultVect = [Mult1; Mult3];
d = load('ARAWVector','ARAWVect');
e = load('CRCWVector','CRCWVect');
A = d.ARAWVect;
B = e.CRCWVect;
SingleVect = [A; B];
MultSingleVect2 = [MultVect; SingleVect];
save MultSingleVect2.mat MultSingleVect2;

method = 'directlda';
array = load('MultSingleVect2','MultSingleVect2');
X = array.MultSingleVect2;
third = ones(1,3111);%get two-dimmensions...not really neccessary
X = [X; third];
Y = [ones(51,1) ; 2*ones(320,1); 3*ones(1,1) ];
[A,T]= directlda(X,Y,2,method);

Z = X*T';%Feature vector

allmultfeat = [Z];
save MultSingleFeat3.mat allmultfeat; %Call MultSingleFeat3 into SVM






