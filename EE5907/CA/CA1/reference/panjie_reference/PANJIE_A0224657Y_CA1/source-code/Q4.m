%This is for Q4

%This code will run for longer time(about 3 minutes) compared with Q1 Q2 and Q3 ,because I use
%loop to compute the L2 distance among all samples
%feel sorry for you to have wait for minutes while running this code ，QAQ

clc,clear all

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
[train_num ,b] = size(data.ytrain); %number of train samples
[test_num ,b] = size(data.ytest);%number of test samples
%lambda_ML = sum(data.ytrain)./train_num   ;    %lambda estimated by ML

index_y0 = find(data.ytrain == 0);      %find the samples given y = 0
index_y1 = find(data.ytrain == 1);      %find the samples given y = 1
[train_numy1,c1] = size(index_y1);      %total train sample number of y = 1      
[train_numy0,c0] = size(index_y0);      %total train sample number of y = 0

Xtrain1 = aXtrain(index_y1,:);          %sanmples and corresponding features given y = 1
Xtrain0 = aXtrain(index_y0,:);          %sanmples and corresponding features given y = 0
[numy1 , numfea] = size(Xtrain1);
[numy0 , numfea] = size(Xtrain0);




% -----------------------test---------------------

         %-------test on train samples---------
K1 = [1:9];
K2 = [10:5:100];
K3 = [K1 K2];   %  vary K
distrain = zeros(train_num,train_num)  ;  %store the euclidean distance between train samples
distrain_rank = zeros(train_num,train_num);   %rank the euclidean distance

for i = 1:train_num;    % compute euclidean distance
    for j = 1:train_num;
        distrain(i,j) = dist(aXtrain(i,:),aXtrain(j,:)');
    end
end

for i = 1:train_num;      %rank euclidean distance
    [B, index] = sort(distrain(i,:), 'ascend');
    distrain_rank(i,:) = index;
end

Error_tr = zeros(1,length(K3));
ytrain = data.ytrain';
for kk = 1:length(K3)
    
    class_pre = zeros(train_num,1);
    error_tr = 0;

    for i = 1:train_num

        class = ytrain(distrain_rank(i,:));
        class1 = sum(class(1:K3(kk)));   %count number of class 1 in the nearest K samples ,  
        if class1 >=K3(kk)/2       %if there are just half samples of class1 ,in the nearest K samples(like 3 in 6),we still predict sample to be class1
            class_pre(i) = 1;       
        end
        if class_pre(i) ~= ytrain(i);
            error_tr = error_tr + 1;
        end
    end

    error_tr = error_tr/train_num;
    Error_tr(kk) = error_tr;
end


          %------------test  on test samples-------------

distest = zeros(test_num,train_num)  ;  %store the euclidean distance between test and train samples
distrain_rank = zeros(test_num,train_num);   %rank the euclidean distance

for i = 1:test_num;    % compute euclidean distance
    for j = 1:train_num;
        distest(i,j) = dist(aXtest(i,:),aXtrain(j,:)');
    end
end

for i = 1:test_num;      %rank euclidean distance
    [B, index] = sort(distest(i,:), 'ascend');
    distest_rank(i,:) = index;
end



ytest = data.ytest';
Error_tt = zeros(1,length(K3));
for kk = 1:length(K3)
    error_tt = 0;
    class_pre = zeros(test_num,1); 
    for i = 1:test_num

        class = ytrain(distest_rank(i,:));
        class1 = sum(class(1:K3(kk)));   %count number of class 1 in the nearest K samples ,  
        if class1 >=K3(kk)/2       %if there are just half samples of class1 ,in the nearest K samples(like 3 in 6),we still predict sample to be class1
            class_pre(i) = 1;       
        end
        if class_pre(i) ~= ytest(i);
            error_tt = error_tt + 1; 
        end
    end
    error_tt = error_tt/test_num;
    Error_tt(kk) = error_tt;
end


plot(K3,Error_tr*100,'r-',K3,Error_tt*100,'blue-')
xlabel('K')
ylabel('Error(%)')
legend('train error','test error','location','southeast')
title('Error rates versus K')
disp('When K ='),disp(K3(1)),disp('train error(%)'),disp(Error_tr(1)*100),disp('test error(%)'),disp(Error_tt(1)*100)
disp('When K ='),disp(K3(10)),disp('train error(%)'),disp(Error_tr(10)*100),disp('test error(%)'),disp(Error_tt(10)*100)
disp('When K ='),disp(K3(end)),disp('train error(%)'),disp(Error_tr(end)*100),disp('test error(%)'),disp(Error_tt(end)*100)




    
