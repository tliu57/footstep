clear all
close all

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

trial = 'RID';
file = strcat(trial, '.mat');

data = load(file);
mat = data.TFR;

runval = 7;
%1 - Single v. Mult,
%2 - Child v. Adult
%3 - Adult Run v. Walk
%4 - Child Run v. Walk
%5 - Two Humans v. Adult Dog
%6 - Two Adult v. Adult Child
%7 - Two v. Three Adults

lit = 0;
if runval == 1
    len1 = length(idCW) + length(idCR) + length(idAWT) + length(idART);
    cat1 = 'Single';
elseif runval == 2
    len1 = length(idCW) + length(idCR);
    cat1 = 'Child';
elseif runval == 3
    len1 = length(idART);
    cat1 = 'Adult Run';
elseif runval == 4
    len1 = length(idCR);
    cat1 = 'Child Run';
elseif runval == 5
    len1 = length(idADW) + length(idADR);
    cat1 = 'Adult and Dog';
elseif runval == 6
    len1 = length(idAAW) + length(idAAR);
    cat1 = 'Two Adults';
else
    len1 = length(idAAW) + length(idAAR);
    cat1 = 'Two Adults';
end
for z = 1:len1
    if runval == 1
        datamat = [idCW idCR idAWT idART];
    elseif runval == 2
        datamat = [idCW idCR];
    elseif runval == 3
        datamat = idART;
    elseif runval == 4
        datamat = idCR;
    elseif runval == 5
        datamat = [idADW idADR];
    elseif runval == 6
        datamat = [idAAW idAAR];
    else
        datamat = [idAAW idAAR];
    end
    i = datamat(z);
    if(i < 72 && (mod(i,5) == 0 && mod(i,10) > 0)) %remove bad data
    else
        if runval == 1
            SingleVect(z,:) = mat(i,:);
        elseif runval ==2
            ChildVect(z,:) = mat(i,:);
        elseif runval == 3
            RunVect(z,:) = mat(i,:);
        elseif runval == 4
            RunVect(z,:) = mat(i,:);
        elseif runval == 5
            DogVect(z,:) = mat(i,:);
        elseif runval == 6
            AdultVect(z,:) = mat(i,:);
        elseif runval == 7
            TwoVect(z,:) = mat(i,:);
        end
    end
end

if runval == 1
    len2 = length(idAAW) + length(idAAR) + length(idAAAW) + length(idAAAR) + length(idADW) + length(idADR);
    cat2 = 'Multiple';
elseif runval == 2
    len2 = length(idAWT)+length(idART);
    cat2 = 'Adult';
elseif runval == 3
    len2 = length(idAWT);
    cat2 = 'Adult Walking';
elseif runval == 4
    len2 = length(idCW);
    cat2 = 'Child Walking';
elseif runval == 5
    len2 = length(idAAW) + length(idAAR) + length(idACW) + length(idACR);
    cat2 = 'Two Humans';
elseif runval == 6
    len2 = length(idACW) + length(idACR);
    cat2 = 'Adult and Child';
else
    len2 = length(idAAW) + length(idAAR);
    cat2 = 'Three Adults';
end
for z = 1:len2
    if runval == 1
        datamat = [idAAW idAAR idAAAW idAAAR idADW idADR];
    elseif runval == 2
        datamat = [idAWT idART];
    elseif runval == 3
        datamat = idAWT;
    elseif runval == 4
        datamat = idCW;
    elseif runval == 5
        datamat = [idAAW idAAR idACW idACR];
    elseif runval == 6
        datamat = [idACW idACR];
    else
        datamat = [idAAAW idAAAR];
    end
    i = datamat(z);
    if(i < 72 && (mod(i,5) == 0 && mod(i,10) > 0)) %remove bad data
    else
        if runval == 1
            MultVect(z,:) = mat(i,:);
        elseif runval == 2
            AdultVect(z,:) = mat(i,:);
        elseif runval == 3
            WalkVect(z,:) = mat(i,:);
        elseif runval == 4
            WalkVect(z,:) = mat(i,:);
        elseif runval == 5
            HumVect(z,:) = mat(i,:);
        elseif runval == 6
            AdultChildVect(z,:) = mat(i,:);
        else
            ThreeVect(z,:) = mat(i,:);
        end
    end
end


%Vector matrix
if runval == 1;
    Vect1 = SingleVect;
    Vect2 = MultVect;
elseif runval == 2
    Vect1 = ChildVect;
    Vect2 = AdultVect;
elseif runval == 3
    Vect1 = RunVect;
    Vect2 = WalkVect;
elseif runval == 4;
    Vect1 = RunVect;
    Vect2 = WalkVect;
elseif runval == 5
    Vect1 = DogVect;
    Vect2 = HumVect;
elseif runval == 6
    Vect1 = AdultVect;
    Vect2 = AdultChildVect;
else
    Vect1 = TwoVect;
    Vect2 = ThreeVect;
end
ARAWVect = [Vect1; Vect2];
%save ARAWVector.mat ARAWVect;

%% Run this part 2nd
%call lda function here.
method = 'directlda';
%array = load('ARAWVector','ARAWVect');
%X = array.ARAWVect;
X = ARAWVect;
[a,b] = size(Vect1);
[c,d] = size(Vect2);
third = -0.0001*ones(1,b);
X = [X; third];
%Y = [ones(a,1) ; 2*ones(c,1)];
Y = [ones(a,1) ; 2*ones(c,1);3*ones(1,1)];

[A,T]= directlda(X,Y,2,method);
display_pts(X,Y,A,fld(X,Y,2)');

Z = X*T'; %Z is the feature vector that goes into classifier is (160 x 1)
save Z.mat Z a c cat1 cat2 trial;
%directlda_demo()









