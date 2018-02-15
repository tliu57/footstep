
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

data = load('RID.mat');
mat = data.TFR;

lit = 0;
for z = 1:length(idART)
    i = idART(z);
    if(i < 72 && (mod(i,5) == 0 && mod(i,10) > 0)) %remove bad data
    else
        RunVect(z,:) = mat(i,:);
    end
end

for z = 1:length(idAWT)
    i = idAWT(z);
    if(i < 72 && (mod(i,5) == 0 && mod(i,10) > 0)) %remove bad data
    else
        WalkVect(z,:) = mat(i,:);
    end
end


%Vector matrix
ARAWVect = [RunVect; WalkVect];
%save ARAWVector.mat ARAWVect;

%% Run this part 2nd
%call lda function here.
method = 'directlda';
%array = load('ARAWVector','ARAWVect');
%X = array.ARAWVect;
X = ARAWVect;
Y = [ones(80,1) ; 2*ones(80,1)];


[A,T]= directlda(X,Y,2,method);
display_pts(X,Y,A,fld(X,Y,2)');

Z = X*T'; %Z is the feature vector that goes into classifier is (160 x 1)
save Z.mat Z;
%directlda_demo()












