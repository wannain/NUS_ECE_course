clc,clear all
%For Q3
data = load('D:\Work\NUS\EE5907\Assignment1\spamData.mat');  %load data
%--------------------Data processing------------------------------

%strategy (a): log-transform: transform each feature using log(xij + 0.1) (assume natural log)
aXtrain = log(data.Xtrain+0.1);
aXtest = log(data.Xtest+0.1);

%strategy (b): binarization: binarize features: I(xij > 0). In other words, if a feature is greater than 0,
%it's simply set to 1. If it’s less than or equal to 0, it's set to 0.
%bXtrain = stepfunc(data.Xtrain,0); 
%bXtest = stepfunc(data.Xtest,0); 
[train_num fea_num] = size(aXtrain);       %number of train samples , number of features
[test_num fea_num] = size(aXtest);  %number of test samples , number of features
Xbias = ones(train_num,1);      % bias term
Xtrain_bias = [Xbias aXtrain];  %add bias term to original train dataset
Xtest_bias = [Xbias(1:test_num) aXtest];%add bias term to original test dataset
ytrain = data.ytrain;
ytest = data.ytest;

XT = Xtrain_bias';



   %-----------------------train----------------------------
lambda = [1:9 10:5:100]; %λ

H1 = eye(fea_num+1,fea_num+1);   %  The 2nd term of hessian matrix with regulatization
H1(1,1) = 0;
I = eye(fea_num+1);
I(1,1) = 0;
wlist = ones(fea_num+1,length(lambda));  % store w of different λ

for i = 1:length(lambda)
    w = zeros(1,fea_num+1);
    w = w';
    iteration = 1;
    NLLlist = [];   %Store NLL of different λ
    while iteration == 1
        NLL = NLL_reg(Xtrain_bias,ytrain,w,lambda(i)); %the NLL ,given w and λ
        NLLlist = [NLLlist NLL];
        U = u(Xtrain_bias,w); %compute the μ vector 
        W = w;
        W(1) = 0;
        g = XT*(U-ytrain) + lambda(i)*W;    %gradient
        S = s(U);
        H = XT*S*Xtrain_bias + lambda(i)*I; %Hessian
        w = w -inv(H)*g;  %update w
        if length(NLLlist)>1; %convergence condition
            if abs(NLLlist(end) - NLLlist(end-1)) < 0.01    %If the NLL reduces very slightly between 2 successive iteration
                iteration = 0;                              %We think it converges
            end
        end
    end
    wlist(:,i) = w;
end




%-----------------------% test-----------------

        %---------test on train samples------------
Error_tr = ones(1,length(lambda));
for i = 1:length(lambda);
    error = 0;
    Xtrain_pre = Xtrain_bias*(-wlist(:,i));
    for j = 1:train_num;
        if Xtrain_pre(j) <= 0;  %P(y=1) = 1/(1+exp(-wx)) > 0.5 equals that -wx ＜ 0
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
for i = 1:length(lambda);
    error = 0;
    Xtest_pre = Xtest_bias*(-wlist(:,i));
    for j = 1:test_num;
        if Xtest_pre(j) <= 0;
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
xlabel('λ')
ylabel('Error(%)')
legend('Train error','Test error','location','southeast')
title('Error rates versus λ')


disp('When λ ='),disp(lambda(1)),disp('train error(%)'),disp(Error_tr(1)*100),disp('test error(%)'),disp(Error_tt(1)*100)
disp('When λ ='),disp(lambda(10)),disp('train error(%)'),disp(Error_tr(10)*100),disp('test error(%)'),disp(Error_tt(10)*100)
disp('When λ ='),disp(lambda(end)),disp('train error(%)'),disp(Error_tr(end)*100),disp('test error(%)'),disp(Error_tt(end)*100)


