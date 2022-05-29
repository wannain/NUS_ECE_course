clc
clear all
close all
%For Q3
data = load('E:\matlab\Polyspace\R2020a\bin\EE5907\CA1\spamData.mat');   %load data
%--------------------Data processing------------------------------

%strategy (a): log-transform: transform each feature using log(xij + 0.1) (assume natural log)
aXtrain = log(data.Xtrain+0.1);
aXtest = log(data.Xtest+0.1);

%strategy (b): binarization: binarize features: I(xij > 0). In other words, if a feature is greater than 0,
%it's simply set to 1. If it’s less than or equal to 0, it's set to 0.
%bXtrain = binarization(data.Xtrain,0); 
%bXtest = binarization(data.Xtest,0); 

[train_num num_feature_label] = size(aXtrain);       %number of train samples , number of features
[test_num num_feature_label] = size(aXtest);  %number of test samples , number of features
Xbias = ones(train_num,1);      % bias term
Xtrain_bias = [Xbias aXtrain];  %add bias term to original train dataset
Xtest_bias = [Xbias(1:test_num) aXtest];%add bias term to original test dataset
ytrain = data.ytrain;
ytest = data.ytest;

XT = Xtrain_bias';

%-----------------------train----------------------------
lambda = [1:9 10:5:100]; %lambda

H1 = eye(num_feature_label+1,num_feature_label+1);   %  The 2nd term of hessian matrix with regulatization
H1(1,1) = 0;
I = eye(num_feature_label+1);
I(1,1) = 0;
wlist = ones(num_feature_label+1,length(lambda));  % store w of different lambda

for i = 1:length(lambda)
    w = zeros(1,num_feature_label+1);
    w = w';
    iteration_convergence_result = 1;
    NLLlist = [];   %Store NLL of different lambda
    while iteration_convergence_result == 1
        NLL = get_NLL_reg(Xtrain_bias,ytrain,w,lambda(i)); %the NLL ,given w and lambda
        NLLlist = [NLLlist NLL];
        U = get_vector_mu(Xtrain_bias,w); %compute the mu vector 
        W = w;
        W(1) = 0; %initilize
        g = XT*(U-ytrain) + lambda(i)*W;    %gradient
        S = get_diagonal_matrix(U);
        H = XT*S*Xtrain_bias + lambda(i)*I; %Hessian
        w = w -inv(H)*g;  %update w
        if length(NLLlist)>1 %convergence condition
            if abs(NLLlist(end) - NLLlist(end-1)) < 0.01    %If the NLL reduces very slightly between 2 successive iteration
                iteration_convergence_result = 0;                              %The system judge that its result converges
            end
        end
    end
    wlist(:,i) = w;
end

%-----------------------% Prediction-----------------
        %---------test on train samples------------
Error_tr = ones(1,length(lambda));
for i = 1:length(lambda)
    error = 0;
    Xtrain_pre = Xtrain_bias*(-wlist(:,i));
    for j = 1:train_num
        if Xtrain_pre(j) <= 0  %P(y=1) = 1/(1+exp(-wx)) > 0.5 equals that -wx ＜ 0
            Xtrain_pre(j) =1;
        else
            Xtrain_pre(j) = 0;
        end

        if Xtrain_pre(j) ~= ytrain(j)
            error = error + 1;
        end
    end
    Error_tr(i) = error/train_num;
end

        %---------test on test samples------------
Error_tt = ones(1,length(lambda));
for i = 1:length(lambda)
    error = 0;
    Xtest_pre = Xtest_bias*(-wlist(:,i));
    for j = 1:test_num
        if Xtest_pre(j) <= 0
            Xtest_pre(j) =1;
        else
            Xtest_pre(j) = 0;
        end

        if Xtest_pre(j) ~= ytest(j)
            error = error + 1;
        end
    end
    Error_tt(i) = error/test_num;
end      


plot(lambda,Error_tr*100,'r',lambda,Error_tt*100,'b')
xlabel('lambda')
ylabel('Error(%)')
legend('Training error','Testing error','location','southeast')
title('Error rates versus lambda')


disp('When lambda ='),disp(lambda(1)),disp('train error(%)'),disp(Error_tr(1)*100),disp('test error(%)'),disp(Error_tt(1)*100)
disp('When lambda ='),disp(lambda(10)),disp('train error(%)'),disp(Error_tr(10)*100),disp('test error(%)'),disp(Error_tt(10)*100)
disp('When lambda ='),disp(lambda(end)),disp('train error(%)'),disp(Error_tr(end)*100),disp('test error(%)'),disp(Error_tt(end)*100)


%This function is for Q3
%Given w and lambda，compute the NLL with regularization

function NLL_output = get_NLL_reg(X,Y,w,lambda)
    [train_num,fea_num] = size(X);
    wTx = X*w;
    NLL_output = 0;
    for i = 1:train_num %compute NLL
        NLL_output = NLL_output +Y(i)*log(1/(1+exp(-wTx(i))))+(1-Y(i))*log(1/(1+exp(wTx(i))));
    end
    w1 = w';
    w1 = w1(2:end); %Do not regularization on the bias term
    NLL_output = -NLL_output + 0.5*lambda*w1*w1'; %NLL with regularization
end

%This function is for Q3
%Given w, compute the mu vector
function y = get_vector_mu(X,w)
    [train_num fea_num] = size(X);
    wTx = X*w;
    y = ones(train_num,1);
    for i = 1:train_num
        y(i) = 1/(1+exp(-wTx(i)));
    end
end

%This function is for Q3
%Compute its corresponding diagonal matrix S
 
function y = get_diagonal_matrix(u)
    y = zeros(length(u));
    for i = 1:length(u)
        y(i,i) = u(i)*(1-u(i));
    end
end
    

