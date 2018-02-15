function display_pts(X,Y,T,T2)
c = 'rbkmcy';
k = nargin-1;

figure;

% if nargin>3
%     Z = X*T2';%FLD
%     mu = mean(Z,1);
%     subplot(k,1,3), hold on
%     for ni = 1:max(Y)
%         plot(Z(Y==ni,1),Z(Y==ni,2),[c(ni) '*'])
%     end
%     plot(mu(1),mu(2),'g*')
% end

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

Z = X*T';%directlda
mu = mean(Z,1);
%subplot(k,1,2), hold on
figure(3); hold on
for ni = 1:max(Y)
plot(Z(Y==ni,1),Z(Y==ni,2),[c(ni) '*'])
end
plot(mu(1),mu(2),'g*')


end
 
