%% A soft-margin SVM with the polynomial kernel
close all;clear;clc;
%% Import dataset
load('train.mat');
load('test.mat');
%% Preprocessing data
mean_x= mean(train_data,2);
s_x= std(train_data, 0, 2);
train_dim = size(train_data);
train_length= train_dim(2);
% Normalization in train data
x_train = (train_data - repmat(mean_x,1,train_length))./repmat(s_x,1,train_length);
d_train = train_label;
test_dim = size(test_data);
test_length = test_dim(2);
% Normalization in test data
x_test = (test_data - repmat(mean_x,1,test_length))./repmat(s_x,1,test_length);
d_test = test_label;
%% Intialization of parameters
threshold = 10^(-4);
p = [1, 2, 3, 4, 5];
C = [0.1, 0.6, 1.1, 2.1];
train_acc = zeros(5,4);
test_acc = zeros(5,4);

for i = 1:length(p)
    for j = 1:length(C)
        % polynomial kernel
        K = (x_train' * x_train + 1).^p(i);
        K_test = (x_train' * x_test + 1).^p(i);
        % check mercer's condition
        eigenvalues = eig(K);
        % calculate alpha
        alpha = get_alpha(x_train, d_train, C(j), K);
        b0 = get_b0(K, d_train, alpha, threshold);

        % calculate accuracy
        pre_train = (sum((alpha .* d_train).*K)+b0)';
        acc_train = mean((pre_train > 0) == (d_train > 0));

        pre_test = (sum((alpha .* d_train).*K_test)+b0)';
        acc_test = mean((pre_test > 0) == (d_test>0));
        
        train_acc(i,j) = acc_train;
        test_acc(i,j) = acc_test;

        fprintf('Training acc of softmargin polynomial kernel of p=%d and C=%d is %g.\n', p(i), C(j), acc_train);
        fprintf('Testing acc of softmargin polynomial kernel of p=%d and C=%d is %g.\n', p(i), C(j), acc_test);
    end
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