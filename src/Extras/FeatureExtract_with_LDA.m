
%% Put all directlda m-files in matlab

%% Run this part first

idCW = 1:80;
idCR = 81:160;
idACW = 161:240;
idACR = 241:320;
idAWT = 321:400;
idART = 401:480;
idADW = 481:560;
idADR = 561:640;
idAAW = 641:680;
idAAR = 681:720;
idAAAW = 721:760;
idAAAR = 761:800;
idAWB = 801:880;
idARB = 881:960;
idAWL = 961:1000;
idARL = 1001:1040;
idAWK = 1041:1080;
idARK = 1081:1120;

lit = 0;
for z = 1:length(idAR)
    i = idAR(z);
    if(i < 72)
        if(i < 72 && (mod(i,5) == 0 && mod(i,10) > 0)) %remove bad data
        else
            if(lit == 0)
                rnum = 1;
            else
                rnum = length(WD_ChildWalkTM) + 1;
            end
            
            colstack = cutTFRfinal(:);
            rowstack = colstack';
            RunVect(lit+1,:) = rowstack;
            
            
            
            WDtime = sum(TFR(200,:)); %ignore this part, from last time
            WD_ChildWalkTM(rnum,:) = WDtime; %ignore
            lit = lit+1;
        end
    end
    
    
    lit = 0;
    for z = 1:length(idAW)
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
            cutTFRtop = TFR(300:8:400,1850:2050);
            cutTFRbot = TFR(75:8:175,1850:2050);
            cutTFR = [cutTFRbot; cutTFRtop];
            cutTFRright = cutTFR(:,150:200);
            cutTFRleft = cutTFR(:,1:100);
            cutTFRfinal = [cutTFRleft cutTFRright];
            
            %             [cutrow,cutcol]=size(cutTFRfinal);
            %             figure;
            %             imagesc(abs(cutTFRfinal));
            %             axis xy;
            %------------------
            
            colstack = cutTFRfinal(:);
            rowstack = colstack';
            WalkVect(lit+1,:) = rowstack;
            
            WDtime = sum(TFR(200,:)); %ignore
            WD_ChildWalkTM(rnum,:) = WDtime; %ignore
            lit = lit+1;
        end
    end
end
end

%Vector matrix
ARAWVect = [RunVect; WalkVect];
save ARAWVector.mat ARAWVect;

%% Run this part 2nd
%call lda function here.
method = 'directlda';
array = load('ARAWVector','ARAWVect');
X = array.ARAWVect;
Y = [ones(80,1) ; 2*ones(80,1)];


[A,T]= directlda(X,Y,2,method);
display_pts(X,Y,A,fld(X,Y,2)');

Z = X*T'; %Z is the feature vector that goes into classifier is (160 x 1)
save Z.mat Z;
%directlda_demo()












