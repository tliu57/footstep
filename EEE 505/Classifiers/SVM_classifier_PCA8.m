clear all;
close all;
%Latest SVM settings:
%


%Load Walk Data
array = load('Features_Walk','Wigner_Walk');
w = array.Wigner_Walk;

%Train Walk
j = 60;%39 %44 %60 %box = 100
for i = 1:j
%for i = [7,8]
    v = w(i,:);
    Trainwalk(i,:) = v;
end

%Test Walk
for i = j+1:71
    v = w(i,:);
    Testwalk(i-j,:) = v;
end

%Load Run Data
array = load('Features_Run','Wigner_Run');
x = array.Wigner_Run;

%Train run
k = 60;%43 %44 %60
for i = 1:k
    y = x(i,:);
    Trainrun(i,:) = y;
end

%Test run
for i = k+1:80
    y = x(i,:);
    Testrun(i-k,:) = y;
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
        group{i,:} = ['Child Walk'];
    else
        group{i,:} = ['Child Run'];
    end
end

%SVM Training
SVMstruct = svmtrain(Trainmatrix,group,'Kernel_Function','rbf', ...
    'boxconstraint', 100, 'showplot', false);

%SVM classifying
 class = svmclassify(SVMstruct, Testmatrix);
 
 %Auto check accuracy
 for i = 1:(r3+r4)
    if i < (r3+1)
        testanswer{i,:} = ['Child Walk'];
    else
        testanswer{i,:} = ['Child Run'];
    end
end
 
 for i = 1:(r3+r4)
     check(i,:) = strcmpi(class(i,:),testanswer(i,:));
 end
 
 walksum = sum(check(1:r3,:));
 runsum = sum(check((r3+1):(r3+r4),:));
 percwalk = (walksum/r3)*100
 percrun = (runsum/r4)*100
 