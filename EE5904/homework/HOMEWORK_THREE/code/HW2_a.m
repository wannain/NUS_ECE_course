%% Clear all variables and close all
close all
clear
clc
sigma = 100;
mkdir q2_a_image
tic

%% Initialise equations and values
load('characters10.mat');
train_data=im2single(train_data);
test_data=im2single(test_data);
test_data=test_data';
train_data=train_data';

trainidx = find(train_label == 2 | train_label == 5);
train_classlabel_logic = logical(train_label(:,:) == 2 | train_label(:,:) == 5);
train_classlabel_logic =train_classlabel_logic';

testidx = find(test_label == 2 | test_label == 5);
test_classlabel_logic = logical(test_label(:,:) == 2 | test_label(:,:) == 5);
test_classlabel_logic =test_classlabel_logic';

%% Calculate interpolation matrix and weights
i_mat = cal_i_mat(train_data, sigma,train_data);
i_mat_test = cal_i_mat(test_data, sigma,train_data);

%% Calculate performance and plot graphs
close all
counter = 1;
for reg = [0,0.001, 0.01, 0.1:0.1:1, 10:10:100,200:200:1000]
    disp(reg)
    %if reg == 0
        %w = inv(i_mat)* double(train_classlabel_logic)';
    %else
        w = inv(i_mat'*i_mat + eye(1000) * reg) * i_mat' * double(train_classlabel_logic)';
    %end
    
    TrPred = i_mat * w;
    TePred = i_mat_test * w;
    
    TrLabel = double(train_classlabel_logic);
    TeLabel = double(test_classlabel_logic);
    
    TrAcc = zeros(1,1000);
    TeAcc = zeros(1,1000);
    thr = zeros(1,1000);
    TrN = length(TrLabel);
    TeN = length(TeLabel);
    
    for i = 1:1000
        t = (max(TrPred)-min(TrPred)) * (i-1)/1000 + min(TrPred);
        thr(i) = t;
        TrAcc(i) = (sum(TrLabel(TrPred<t)==0) + sum(TrLabel(TrPred>=t)==1)) / TrN;
        TeAcc(i) = (sum(TeLabel(TePred<t)==0) + sum(TeLabel(TePred>=t)==1)) / TeN;
    end
    
    acc_th(1,counter) = reg;                      % reg value
    
    [acc_th(2,counter),thres] = max(TrAcc);         % max training accuracy
    acc_th(3,counter) = thr(1,thres);
    
    [acc_th(4,counter),thres] = max(TeAcc);         % max testing accuracy
    acc_th(5,counter) = thr(1,thres);
    
    counter = counter + 1;
    %figure;
    plot(thr,TrAcc,'.- ',thr,TeAcc,'^-');legend('tr','te','Location','southeast');
    grid
    title(strcat('Accuracy against Threshold (Regularization = ', " ", num2str(reg), ")"))
    ylabel("Accuracy"); xlabel("Threshold");
    saveas(gcf,strcat("q2_a_image/a_",num2str(reg),".jpg"))
end

figure;
hold on
plot(acc_th(1,:),acc_th(2,:),'-m');
plot(acc_th(1,:),acc_th(4,:),'-k');
legend('Training data','Test data','Location','northeast');
grid
title('Accuracy against Regularization');
ylabel("Accuracy"); xlabel("Regularization");
saveas(gcf,strcat("q2_a_image/a_","acc against reg",".jpg"))
sort(acc_th,2)
toc

function matrix = cal_i_mat(data, sigma, train_data)
num_data = size(data,2);
num_cen = 1000;
matrix = zeros(num_data,num_cen);
for i = 1:num_data
    for j = 1:num_cen
        disp(['Calculating (' num2str(i) ',' num2str(j),')'])
        matrix(i,j) = exp (  (norm(data(:,i) - train_data(:,j)))^2  /  (-2*(sigma^2))   )  ;
    end
end
end
