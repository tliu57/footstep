clear all;
close all;
%Latest SVM settings:
%j=60, k=60, box =100

%Load Run Data
array = load('CRCWfeat2.mat','Z'); %This is the feature vector from LDA
w = array.Z;

%Train Run
j = 60;
for i = 1:j
%for i = [7,8]
    v = w(i,:);
    Trainrun(i,:) = v;
end

%Test Run
for i = j+1:80
    v = w(i,:);
    Testrun(i-j,:) = v;
end

%Load Run Data
array = load('CRCWfeat2.mat','Z');
x = array.Z;

%Train Walk
k = 60;
for i = 80+1:k+80
    y = x(i,:);
    Trainwalk(i-(80),:) = y;
end

%Test Walk
for i = k+81:151 
    y = x(i,:);
    Testwalk(i-(k+80),:) = y;
end

%Training matrix
[r1,c1]=size(Trainwalk);
[r2,c2]=size(Trainrun);
Trainmatrix = [Trainwalk; Trainrun];

%Testing matrix
[r3,c3]=size(Testwalk);
[r4,c4]=size(Testrun);
Testmatrix = [Testwalk; Testrun];

%Group matrix
for i = 1:r1+r2
    if i <= (r1)
        group{i,:} = ['Adult Walk'];
    else
        group{i,:} = ['Adult Run'];
    end
end

%LDA classifying
 class = classify(Testmatrix, Trainmatrix, group,'quadratic');
 %'linear' is less accurate than 'quadratic' here.
 
 %Auto check accuracy
 for i = 1:(r3+r4)
    if i < (r3+1)
        testanswer{i,:} = ['Adult Walk'];
    else
        testanswer{i,:} = ['Adult Run'];
    end
end
 
 for i = 1:(r3+r4)
     check(i,:) = strcmpi(class(i,:),testanswer(i,:));
 end
 
 walksum = sum(check(1:r3,:));
 runsum = sum(check((r3+1):(r3+r4),:));
 percwalk = (walksum/r3)*100
 percrun = (runsum/r4)*100
 