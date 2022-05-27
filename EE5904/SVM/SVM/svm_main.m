%% task 3
close all;clear;clc;
%% Load data and initialization
load('train.mat');
load('eval.mat');
eval_predicted=svm_task3(train_data,eval_data,train_label,eval_label);
function eval_predicted=svm_task3(train_data,eval_data,train_label,eval_label)
    %% Setting parameters
    C = 110;
    p=1;
    threshold = 10^(-4);

    %% Preprocessing data
    mean_x= mean(train_data,2);
    s_x= std(train_data, 0, 2);

    train_dim = size(train_data);
    train_length= train_dim(2);
    % Normalization in train data
    x_train = (train_data - repmat(mean_x,1,train_length))./repmat(s_x,1,train_length);
    d_train = train_label;
    eval_dim = size(eval_data);
    eval_length = eval_dim(2);
    % Normalization in test data
    x_eval = (eval_data - repmat(mean_x,1,eval_length))./repmat(s_x,1,eval_length);
    d_eval = eval_label;

    % polynomial kernel
    K = (x_train' * x_train + 1).^p;
    K_eval = (x_train' * x_eval + 1).^p;
    % check mercer's condition
    eigenvalues = eig(K);
    % calculate alpha
    alpha = get_alpha(x_train, d_train, C, K);
    b0 = get_b0(K, d_train, alpha, threshold);

    % calculate accuracy
    pre_train = (sum((alpha .* d_train).*K)+b0)';
    train_accuracy = mean((pre_train > 0) == (d_train > 0));
    pre_eval = (sum((alpha .* d_train).*K_eval)+b0)';

    for i = 1:eval_length
        if pre_eval(i) > 0
            eval_predicted(i,:) = 1;
        else
            eval_predicted(i,:) = -1;
        end
    end
    eval_accuracy = mean((eval_predicted > 0) == (d_eval > 0));
    pre=reshape([eval_predicted;pre_train],1,[]);
    d=reshape([d_eval;d_train],1,[]);
    total_accuracy = mean((d > 0) == (pre > 0));
    fprintf('Training acc of soft margin polynomial kernel is %g.\n', train_accuracy);
    fprintf('Testing acc of soft margin polynomial kernel is %g.\n', eval_accuracy);
    fprintf('Total acc of soft margin polynomial kernel is %g.\n', total_accuracy);
end

function alpha = get_alpha(train_data_std, train_label, C, K)
%% Summary of this function goes here
    train_dim = size(train_data_std);
    train_length = train_dim(2);
    d=train_label;
    %% Solve the problem
    H = d*d'.*K;
    f = -1 * ones(train_length, 1);
    A=[];
    b=[];
    Aeq = train_label';
    beq = 0;
    ub = C * ones(train_length, 1);
    lb=zeros(train_length,1);
    x0=[];
    options = optimset('LargeScale','off','MaxIter',1000);
    alpha = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,options);
end

function b0 = get_b0(K, y_train, alpha, threshold)
    % calculate alpha
    sv_idx = find(alpha > threshold);% find support vector\
    temp =sum(alpha .*y_train .* K(:,sv_idx), 1);
    b0 = mean(y_train(sv_idx) - temp');
end