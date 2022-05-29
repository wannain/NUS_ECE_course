clc,clear all
%For Q2
data = load('D:\Work\NUS\EE5907\Assignment1\spamData.mat');  %load data
%--------------------Data processing------------------------------

%strategy (a): log-transform: transform each feature using log(xij + 0.1) (assume natural log)
aXtrain = log(data.Xtrain+0.1);
aXtest = log(data.Xtest+0.1);

%strategy (b): binarization: binarize features: I(xij > 0). In other words, if a feature is greater than 0,
%it's simply set to 1. If it’s less than or equal to 0, it's set to 0.
%bXtrain = stepfunc(data.Xtrain,0); 
%bXtest = stepfunc(data.Xtest,0); 



%----------------train-------------------
[train_num ,b] = size(data.ytrain);
[test_num ,b] = size(data.ytest);
lambda_ML = sum(data.ytrain)./train_num   ;    %lambda estimated by ML

index_y0 = find(data.ytrain == 0);      %find the train samples given y = 0
index_y1 = find(data.ytrain == 1);      %find the train samples given y = 1
[train_numy1,c1] = size(index_y1);      %total train samples number of y = 1      
[train_numy0,c0] = size(index_y0);      %total train samples number of y = 0

Xtrain1 = aXtrain(index_y1,:);          %train samples given y = 1
Xtrain0 = aXtrain(index_y0,:);          %train samples given y = 0
[numy1 , numfea] = size(Xtrain1);
[numy0 , numfea] = size(Xtrain0);
u_theta1 = zeros(2,57) ;                  %store the class conditional(y=1) mean and variance of each feature  
u_theta0 = zeros(2,57) ;                  %store the class conditional(y=0) mean and variance of each feature  
u_theta1(1,:) = mean(Xtrain1);     % mean of feature when y = 1
u_theta1(2,:) = var(Xtrain1)*(numy1-1)/numy1;      % variance of feature when y = 1
u_theta0(1,:) = mean(Xtrain0);     % mean of feature when y = 0
u_theta0(2,:) = var(Xtrain0)*(numy0-1)/numy0;      % variance of feature when y = 0





%----------------------test---------------------
    %-------------test on train samples--------
class_pre = zeros(train_num,4);
class_pre(:,4) = data.ytrain;
error_tr = 0;
for i = 1:train_num;
    p1 = 0; %The probility of y = 1
    p0 = 0; %The probility of y = 0
    for j = 1:numfea;
        p1 = p1 + log(normpdf(aXtrain(i,j),u_theta1(1,j),sqrt(u_theta1(2,j))));%The probility of y = 1
        p0 = p0 + log(normpdf(aXtrain(i,j),u_theta0(1,j),sqrt(u_theta0(2,j))));%The probility of y = 0
    end
    p1 = p1 + log(lambda_ML); %The probility of y = 1
    p0 = p0 + log(1-lambda_ML);%The probility of y = 0
    class_pre(i,1) = p1;
    class_pre(i,2) = p0;
    %predict
    if p1>p0
        class_pre(i,3) = 1;
    end
    %compare predict result with ture label
    if class_pre(i,3) ~= class_pre(i,4)
        error_tr = error_tr + 1;
    end
end
error_tr = error_tr/train_num;



    %-------------test on test samples--------
class_pre = zeros(test_num,4);
class_pre(:,4) = data.ytest;
error_tt = 0;
for i = 1:test_num;
    p1 = 0; %The probility of y = 1
    p0 = 0;%The probility of y = 0
    for j = 1:numfea;
        p1 = p1 + log(normpdf(aXtest(i,j),u_theta1(1,j),sqrt(u_theta1(2,j))));%The probility of y = 1
        p0 = p0 + log(normpdf(aXtest(i,j),u_theta0(1,j),sqrt(u_theta0(2,j))));%The probility of y = 0
    end
    p1 = p1 + log(lambda_ML);%The probility of y = 1
    p0 = p0 + log(1-lambda_ML);%The probility of y = 0
    class_pre(i,1) = p1;
    class_pre(i,2) = p0;
    %predict y with a higher probility
    if p1>p0
        class_pre(i,3) = 1;
    end
    %compare the predict result with true label
    if class_pre(i,3) ~= class_pre(i,4)
        error_tt = error_tt + 1;
    end
end
error_tt = error_tt/test_num;
disp('Error on training samples is(%):'),disp(error_tr*100)
disp('Error on testing samples is(%):'),disp(error_tt*100)





























