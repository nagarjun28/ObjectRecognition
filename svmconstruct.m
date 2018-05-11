function [SVMModel]=svmconstruct(featureVector)
X=featureVector;
%y=[1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2];
y=[1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 ];
SVMModel=fitcsvm(X,y,'Standardize',true,'KernelFunction','RBF','KernelScale','auto');
%SVMModel=fitcsvm(X,y,'KernelFunction','rbf','Standardize',true,'ClassNames',{'1','2'});
sv = SVMModel.SupportVectors;
figure
gscatter(X(:,1),X(:,2),y)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('apple','leaf','Support Vector')
hold off
end