clear all;
close all;
%Latest SVM settings:
%j=60, k=60, box =100

%Load Run Data
array = load('Z.mat');
w = array.Z;
a = array.a;
c = array.c;
cat1 = array.cat1
cat2 = array.cat2
trial = array.trial;
%w = [w w]; %square features for plotting

%Train Run
j = 3*a/4;
for i = 1:j
%for i = [7,8]
    v = w(i,:);
    Trainrun(i,:) = v;
end

%Test Run
for i = (j+1):a
    v = w(i,:);
    Testrun(i-j,:) = v;
end

%Load Run Data
array = load('Z.mat','Z');
x = array.Z;
%x = [x x]; %square features for plotting

%Train Walk
k = 3*c/4;
for i = (a+1):(k+a)
    y = x(i,:);
    Trainwalk(i-(a),:) = y;
end

%Test Walk
for i = (k+a+1):(a+c)
    y = x(i,:);
    Testwalk(i-(k+a),:) = y;
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
        group{i,:} = [cat1];
    else
        group{i,:} = [cat2];
    end
end

%SVM Training
SVMstruct = svmtrain(Trainmatrix,group,'Kernel_Function','rbf', ...
    'boxconstraint', 100, 'showplot', true);

legend_handle = legend();
set(legend_handle, 'Location', 'Best')  
title(['Classification with SVM for Method ', trial]);
xlabel('Fisher Feature 1');
ylabel('Fisher Feature 2');

%SVM classifying
 class = svmclassify(SVMstruct, Testmatrix);
 
 %Auto check accuracy
 for i = 1:(r3+r4)
    if i < (r3+1)
        testanswer{i,:} = [cat1];
    else
        testanswer{i,:} = [cat2];
    end
end
 
 for i = 1:(r3+r4)
     check(i,:) = strcmpi(class(i,:),testanswer(i,:));
 end
 
 walksum = sum(check(1:r3,:));
 runsum = sum(check((r3+1):(r3+r4),:));
 percfirst = (walksum/r3)*100
 percsec = (runsum/r4)*100
 