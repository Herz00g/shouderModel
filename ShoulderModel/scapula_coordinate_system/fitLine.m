function [dirVect,meanX,residuals,rmse,R2] = fitLine(X)

% Fits a line to a group of points in X
% X should be X = [x1 y1 z1]
%                 [   ...  ]
%                 [xn yn zn]

[coeff,score,~] = princomp(X);
dirVect = coeff(:,1);
[Xn,Xm] = size(X);
meanX = mean(X,1);
Xfit1 = repmat(meanX,Xn,1) + score(:,1)*coeff(:,1)';
residuals = X-Xfit1;
error =  diag(pdist2(residuals,zeros(Xn,Xm)));
sse = sum(error.^2);
rmse = norm(error)/sqrt(Xn);

for i=1:Xn
    tot(i) = norm(meanX-X(i,:));
end
    
sst = sum(tot.^2); 

R2 = 1-(sse/sst); %http://en.wikipedia.org/wiki/Coefficient_of_determination
end