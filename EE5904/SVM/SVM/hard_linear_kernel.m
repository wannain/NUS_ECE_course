%% A hard-margin SVM with the linear kernel
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
%% linear kernel in hard margin of linear kernal
K = x_train' * x_train; % xi*xj
eigenvalues = eig(K);
%% Calculate alpha
alpha = get_alpha(x_train, d_train, C, K);
sv_idx = find(alpha > threshold);% find support vector
sv_alpha=alpha(sv_idx);
sv_x= x_train(:,sv_idx);
sv_label = d_train(sv_idx);
w0=sum(alpha.*d_train.*x_train');
b0 = mean(1./sv_label' - w0 * sv_x);
%% calculate accuracy
pre_train = sign(w0 * x_train + b0*ones(1,train_length))';
train_accuracy = mean(pre_train == d_train);
pre_test = sign(w0 * x_test + b0*ones(1,test_length))';
test_accuracy = mean(pre_test == d_test);
pre=reshape([pre_test;pre_train],1,[]);
d=reshape([d_test;d_train],1,[]);
total_accuracy = mean((d > 0) == (pre > 0));
fprintf('Training acc of hard margin linear kernel is %g.\n', train_accuracy);
fprintf('Testing acc of hard margin linear kernel is %g.\n', test_accuracy);
fprintf('Total acc of hard margin linear kernel is %g.\n', total_accuracy);
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