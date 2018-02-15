function directlda_demo
%DIRECTLDA_DEMO

% Plot random points, differetn classes different means
% maps to 2 dims
% x is the one with the lowest eval of Sw, y the second lowest 
% Comparing to fld by Sergios Petridis for fun and check correctness

%method = 'pcalda';
method = 'directlda';

%%
%just random points in 3d space, full rank within cov mat
X = [5*rand(10,3)+20.0 ; 5*rand(12,3)+25];
Y = [ones(10,1) ; 2*ones(12,1)];

[A,T] = directlda(X,Y,2,method)
display_pts(X,Y,A,fld(X,Y,2)');

%%
% this is really what makes the directlda method different, within cov mat singular
% X = [5*rand(2,20) ; 10*rand(2,20)+10; [8*rand(4,10) 10*rand(4,10)+15]];
% Y = [1 1 2 2 3 3 3 3]';

% X = [5*rand(2,4000) ; 10*rand(2,4000)+10; [8*rand(4,2000) 10*rand(4,2000)+15]];
% Y = [1 1 2 2 3 3 3 3]';

%X = [5*rand(4,2000) ; 10*rand(4,2000)+10; [8*rand(4,1000) 10*rand(4,1000)+15]];
%Y = [1 1 1 1 2 2 2 2 3 3 3 3]';

% X = [5*rand(38,4000) ; 10*rand(38,4000)+10; [8*rand(38,2000) 10*rand(38,2000)+15]];
% Y = [ones(57,1) ; 2*ones(57,1)];
% 
%  X = [5*rand(40,4000) ; 10*rand(40,4000)+10; [8*rand(80,2000) 10*rand(80,2000)+15]];
%  Y = [ones(40,1) ; 3*ones(40,1); 2*ones(80,1)];
% % 
% % 
% [A,T] = directlda(X,Y,2,method);
% display_pts(X,Y,A,fld(X,Y,2)');


%%
% 
% X = [5*rand(10,3)+30.0 ; 5*rand(12,3)+35; ...
%     bsxfun(@plus,[30,25,25],7*rand(15,3))];
% Y = [ones(10,1) ; 2*ones(12,1); 3*ones(15,1)];
% 
% [A,T] = directlda(X,Y,2,method)
% display_pts(X,Y,A,fld(X,Y,2)');



%%
% 
% X = [5*rand(10,3)+1.0 ; 5*rand(12,3)+5; ...
%     bsxfun(@plus,[10,0,0],5*rand(15,3)+5); ...
%     bsxfun(@plus,[0,10,0],5*rand(12,3))];
% Y = [ones(10,1) ; 2*ones(12,1); 3*ones(15,1); 4*ones(12,1)];
% 
% [A,T] = directlda(X,Y,2,method)
% display_pts(X,Y,A,fld(X,Y,2)');


%%
% directlda method has trouble with large magnitudes in a feature across groups
% X = [5*rand(10,3)+1.0 ; [5000000*(rand(12,2)+5) rand(12,1)+5]; ...
%     bsxfun(@plus,[10,0,0],5*rand(15,3))+5];
% Y = [ones(10,1) ; 2*ones(12,1); 3*ones(15,1)];
% 
% [A,T] = directlda(X,Y,2,method)
% display_pts(X,Y,A,fld(X,Y,2)');

%%
% but not with large magnitudes within a feature
% X = [[5000000*(rand(10,2)+5) rand(10,1)+5]; ...
%     [5000000*(rand(12,2)+50) rand(12,1)+5]; ...
%     bsxfun(@plus,[10,0,0], [5000000*(rand(15,2)+100) rand(15,1)+5])];
% Y = [ones(10,1) ; 2*ones(12,1); 3*ones(15,1)];
% 
% [A,T] = directlda(X,Y,2,method)
% display_pts(X,Y,A,fld(X,Y,2)');


end


function display_pts(X,Y,T,T2)
c = 'rbkmcy';
k = nargin-1;

% figure
% 
% if nargin>3
%     Z = X*T2';%FLD
%     mu = mean(Z,1);
%     %subplot(k,1,3), hold on
%     figure(1); hold on
%     for ni = 1:max(Y)
%         plot(Z(Y==ni,1),Z(Y==ni,2),[c(ni) '*'])
%     end
%     plot(mu(1),mu(2),'g*')
% end
% 
% mu = mean(X,1);%data
% %subplot(k,1,1), hold on
% figure(2); hold on
% for ni = 1:max(Y)
% plot3(X(Y==ni,1),X(Y==ni,2),X(Y==ni,3),[c(ni) '*'])
% end
% plot3(mu(1),mu(2),mu(3),'g*')
%     
% if size(T,1) == 1,
%     T(2,:) = 0;
% end
% 
% Z = X*T';%directlda
% mu = mean(Z,1);
% %subplot(k,1,2), hold on
% figure(3); hold on
% for ni = 1:max(Y)
% plot(Z(Y==ni,1),Z(Y==ni,2),[c(ni) '*'])
% end
% plot(mu(1),mu(2),'g*')

%----

figure;

if nargin>3
    Z = X*T2';%FLD
    mu = mean(Z,1);
    subplot(k,1,3), hold on
    for ni = 1:max(Y)
        plot(Z(Y==ni,1),Z(Y==ni,2),[c(ni) '*'])
    end
    plot(mu(1),mu(2),'g*')
end

mu = mean(X,1);%data
subplot(k,1,1), hold on
for ni = 1:max(Y)
plot3(X(Y==ni,1),X(Y==ni,2),X(Y==ni,3),[c(ni) '*'])
end
plot3(mu(1),mu(2),mu(3),'g*')
    
if size(T,1) == 1,
    T(2,:) = 0;
end

Z = X*T';%directlda
mu = mean(Z,1);
subplot(k,1,2), hold on
for ni = 1:max(Y)
plot(Z(Y==ni,1),Z(Y==ni,2),[c(ni) '*'])
end
plot(mu(1),mu(2),'g*')
end

