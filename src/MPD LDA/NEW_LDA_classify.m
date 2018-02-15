clear all;
close all;
%Latest SVM settings:
%j=60, k=60, box =100

%Load Run Data
array = load('Z.mat'); %This is the feature vector from LDA
w = array.Z;
a = array.a;
c = array.c;
cat1 = array.cat1
cat2 = array.cat2

%Train Run
j = 3*a/4;
for i = 1:j
    %for i = [7,8]
    v = w(i,:);
    Trainrun(i,:) = v;
end

%Test Run
for i = j+1:a
    v = w(i,:);
    Testrun(i-j,:) = v;
end

%Load Run Data
array = load('Z.mat','Z');
x = array.Z;

%Train Walk
k =3*c/4;
for i = a+1:k+a
    y = x(i,:);
    Trainwalk(i-(a),:) = y;
end

%Test Walk
for i = k+a+1:(a+c)
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

%LDA classifying
[class, err, P, logp, coeff] = classify(Testmatrix, Trainmatrix, group,'linear');
%'linear' is less accurate than 'quadratic' here.

% hold on
% h1 = gscatter(Trainmatrix(:,1),Trainmatrix(:,2),group,'rb','v^',[],'off');
% set(h1,'LineWidth',2)
% legend(cat1,cat2,...
%        'Location','NW')
% gscatter(Testmatrix(:,1), Testmatrix(:,2), class, 'rb', '.', 1, 'off');
% K = coeff(1,2).const;
% L = coeff(1,2).linear; 
% Q = coeff(1,2).quadratic;
% f = @(x,y) K + [x y]*L + sum(([x y]*Q) .* [x y], 2);
% 
% h2 = ezplot(f,[-0.002 0.006 -0.0015 0.0015]);
% set(h2,'Color','m','LineWidth',2)
% axis([-0.002 0.006 -0.0015 0.0015])
% xlabel('Fischer Feature 1')
% ylabel('Fishcer Feature 2')
% title('Classification of Footsteps')
% hold off
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
percsecond = (runsum/r4)*100
