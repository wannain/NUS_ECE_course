%% A hard-margin SVM with the polynomial kernel
close all;clear;clc;
%% Import dataset
load('train.mat');
load('test.mat');
C = 10^6;
threshold = 10^(-4);
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
%p=2;
p = [2, 3, 4, 5];
eig_vales = ones(train_length,4);
for i = 1:length(p)
    % polynomial kernel
    K = (x_train' * x_train + 1).^p(i);
    % Check Mercer's Condition
    eigen_value = eig(K);
    eigen_value(:,i) = eigen_value;
    K_test = (x_train' * x_test+ 1).^p(i);
    % calculate alpha
    alpha = get_alpha(x_train, d_train, C, K);
    b0 = get_b0(K, d_train, alpha, threshold);
    %% calculate accuracy
    pre_train = (sum((alpha .* d_train).*K)+b0)';
    train_accuracy = mean((pre_train > 0) == (d_train > 0));
    pre_test = (sum((alpha .* d_train).*K_test)+b0)';
    test_accuracy = mean((pre_test > 0) == (d_test > 0));
    pre=reshape([pre_test;pre_train],1,[]);
    d=reshape([d_test;d_train],1,[]);
    total_accuracy = mean((d > 0) == (pre > 0));
    fprintf('Training acc of hardmargin polynomial kernel of %d is %g.\n', p(i), train_accuracy);
    fprintf('Testing acc of hardmargin polynomial kernel of %d is %g.\n', p(i), test_accuracy);
    fprintf('Testing acc of hardmargin polynomial kernel of %d is %g.\n', p(i), total_accuracy);
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