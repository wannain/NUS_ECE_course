clc
clear all
close all
%For Q1
data = load('E:\matlab\Polyspace\R2020a\bin\EE5907\CA1\spamData.mat');  %load data
%--------------------Data processing------------------------------

%strategy (a): log-transform: transform each feature using log(xij + 0.1) (assume natural log)
%aXtrain = log(data.Xtrain+0.1);
%aXtest = log(data.Xtest+0.1);

%strategy (b): binarization: binarize features: I(xij > 0). In other words, if a feature is greater than 0,
%it's simply set to 1. If it’s less than or equal to 0, it's set to 0.
bXtrain = binarization(data.Xtrain,0); 
bXtest = binarization(data.Xtest,0); 


%----------------------------Train Part---------------------------------
[train_num ,b] = size(data.ytrain);        %the number of train samples
lambda_ML = sum(data.ytrain)./train_num   ;    %lambda estimated by ML


index_y0 = find(data.ytrain == 0);      %find the features given y = 0
index_y1 = find(data.ytrain == 1);      %find the features given y = 1
[train_numy1,c1] = size(index_y1);      %total train number of y = 1      
[train_numy0,c0] = size(index_y0);      %total train number of y = 0
P_tr = zeros(4,57);           %  statistics for very feature x and its every element ,given y , in trainning set

for i = 1:57
    feature = bXtrain(:,i);          %A single feature Xi of all train samples
    feature1 = feature(index_y1);    %these train samples of which Xi is 1 when given y = 1
    feature0 = feature(index_y0);    %these train samples of which Xi is 1 when given y = 0
    train_num_x1y1 = sum(feature1);  %when y = 1 , the number of train samples whose Xi = 1
    train_num_x1y0 = sum(feature0);  %when y = 0 , the number of train samples whose Xi = 1
    P_tr(1,i) = train_num_x1y1;                             
    P_tr(2,i) = train_numy1 - train_num_x1y1;                 %when y = 1 , the number of train samples whose Xi = 0
    P_tr(3,i) = train_num_x1y0;
    P_tr(4,i) = train_numy0 - train_num_x1y0;                 %when y = 0 , the number of train samples whose Xi = 0
end

%-------------------------Test Part-------------------------

Error_tt = [] ;     %error in test set
Error_tr = [] ;     %error in train set
for alpha = 0:0.5:100  %alpha vary from 0 ,0.5 ,1 ...to 99.5 ,100
    [test_num,c0] = size(bXtest);
    P_tt = zeros(test_num,3);
    %---------------test on test set-------------------
    % possibility of y = 1 in test set
    for j = 1:test_num              
        p = 0;
        sample = bXtest(j,:);
        for i = 1:57
            if sample(i) == 1
                p = p + log((P_tr(1,i)+ alpha)/(train_numy1 + 2*alpha));
            else
                p = p + log((P_tr(2,i)+ alpha)/(train_numy1 + 2*alpha));
            end
        end
        p = p + log(lambda_ML);
        P_tt(j,1) = p ;
    end  
 % possibility of y = 0 in test set
    for j = 1:test_num              
        p = 0;
        sample = bXtest(j,:);
        for i = 1:57
            if sample(i) == 1
                p = p + log((P_tr(3,i)+alpha)/(train_numy0 + 2*alpha));
            else
                p = p + log((P_tr(4,i)+alpha)/(train_numy0 + 2*alpha));
            end
        end
        p = p + log(1-lambda_ML);
        P_tt(j,2) = p ;
    end
% predice y = 1 or y = 0 in test set
    for i = 1:test_num                
        if P_tt(i,1) > P_tt(i,2)
            P_tt(i,3) = 1;
        else
            P_tt(i,3) = 0;
        end
    end
% compute test error
    error = 0;
    for i = 1:test_num       
        if data.ytest(i) ~= P_tt(i,3)
            error = error + 1;
        end
    end
    error = error / test_num;
    Error_tt = [Error_tt error]; 
    %----------------------test on train set---------------
    %possibility of y = 1 predicted in train set
    P_train = zeros(train_num,3);

    for k = 1:train_num
        sample = bXtrain(k,:);
        p = 0;
        for s = 1:57
            if sample(s) == 1
                p = p + log((alpha + P_tr(1,s))/(2*alpha + train_numy1));
            else
                p = p + log((alpha + P_tr(2,s))/(2*alpha + train_numy1));
            end
        end
        p = p + log(lambda_ML);
        P_train(k,1) = p;
    end
    
    %possibility of y = 0 predicted in train set
    for k = 1:train_num
        sample = bXtrain(k,:);
        p = 0;
        for s = 1:57
            if sample(s) == 1
                p = p + log((alpha + P_tr(3,s))/(2*alpha + train_numy0));
            else
                p = p + log((alpha + P_tr(4,s))/(2*alpha + train_numy0));
            end
        end
        p = p + log(1-lambda_ML);
        P_train(k,2) = p;
    end
    % predice y = 1 or y = 0 in train set
    for i = 1:train_num                 
        if P_train(i,1) > P_train(i,2)
            P_train(i,3) = 1;
        else
            P_train(i,3) = 0;
        end
    end
  % compute test error on training set
    error = 0;
    for i = 1:train_num        
        if data.ytrain(i) ~= P_train(i,3)
            error = error + 1;
        end
    end
    error = error / train_num;
    Error_tr = [Error_tr error];                 
end

alpha = 0:0.5:100;
%Plot the image of error rates
plot(alpha,Error_tr*100,'--',alpha,Error_tt*100)
xlabel('alpha')
ylabel('error rate(%)')
legend('Training error','Testing error','location','southeast')
title('Error rates versus different alpha')
%Get the final result
disp('When alpha = 1:'),disp('training error(%)'),disp(Error_tr(3)*100),disp('testing error(%)'),disp(Error_tt(3)*100)
disp('When alpha = 10:'),disp('training error(%)'),disp(Error_tr(21)*100),disp('testing error(%)'),disp(Error_tt(21)*100)
disp('When alpha = 100:'),disp('training error(%)'),disp(Error_tr(201)*100),disp('testing error(%)'),disp(Error_tt(201)*100)

function out_binarization_result = binarization(input_data,threshold)% this function is for strategy (b) of the data processing,t is the threshold
    [rows,columns] = size(input_data);
    for i = 1:rows
        for j = 1:columns
            if input_data(i,j) > threshold
                input_data(i,j) = 1;
            end
        end
    end
    out_binarization_result = input_data; 
end