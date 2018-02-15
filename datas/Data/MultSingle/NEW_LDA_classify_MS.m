clear all;
close all;
%Latest SVM settings:
%j=60, k=60, box =100

%   for k = 100:130
%      k 
    
%Load Run Data
array = load('MultSingleFeat3.mat','allmultfeat');
w = array.allmultfeat;
%w = [w w]; %square features for plotting

%Train Mult
j = 30; %30
for i = 1:j
%for i = [7,8]
    v = w(i,:);
    Trainmult(i,:) = v;
end

%Test Run
for i = j+1:51
    v = w(i,:);
    Testmult(i-j,:) = v;
end

%Load Data
array = load('MultSingleFeat3.mat','allmultfeat');
x = array.allmultfeat;
%x = [x x]; %square features for plotting

%Train Single
k = 280; %290
for i = 51+1:k+51
    y = x(i,:);
    Trainsingle(i-(51),:) = y;
end

%Test Walk
for i = k+51+1:371 
    y = x(i,:);
    Testsingle(i-(k+51),:) = y;
end

%Training matrix
[r1,c1]=size(Trainsingle);
[r2,c2]=size(Trainmult);
Trainmatrix = [Trainsingle; Trainmult];

%Testing matrix
[r3,c3]=size(Testsingle);
[r4,c4]=size(Testmult);
Testmatrix = [Testsingle; Testmult];

%Group matrix
for i = 1:r1+r2
    if i <= (r1)
        group{i,:} = ['Single'];
    else
        group{i,:} = ['Multiple'];
    end
end

%LDA classifying
 class = classify(Testmatrix, Trainmatrix, group,'quadratic');
 %'linear' is less accurate than 'quadratic' here.
 
 %Auto check accuracy
 for i = 1:(r3+r4)
    if i < (r3+1)
        testanswer{i,:} = ['Single'];
    else
        testanswer{i,:} = ['Multiple'];
    end
end
 
 for i = 1:(r3+r4)
     check(i,:) = strcmpi(class(i,:),testanswer(i,:));
 end
 
 singlesum = sum(check(1:r3,:));
 multsum = sum(check((r3+1):(r3+r4),:));
 percsingle = (singlesum/r3)*100
 percmult = (multsum/r4)*100
 
     hold on
       K = class.Coeffs(1,2).const;
       L = class.Coeffs(1,2).linear;
       Q = class.Coeffs(1,2).quadratic;
       % Plot the curve K + [x,y]*L + [x,y]*Q*[x,y]' = 0:
       f = @(x,y) K + L(1)*x + L(2)*y ...
                    + Q(1,1)*x.^2 + (Q(1,2)+Q(2,1))*x.*y + Q(2,2)*y.^2;
       ezplot(f,[4 8 2 4.5]);
       hold off
 