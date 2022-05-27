% Clear all variables and close all
close all
clear
clc
num_cen = 100;
mkdir q2_b_image
tic

% Initialise equations and values
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

% Calculate interpolation matrix and weights
idx = randperm(size(train_data,2));
idx = idx(1,1:num_cen);

cen_data = train_data(:,idx);
cen_label = train_classlabel_logic(:,idx);

for i = 1:num_cen
    dist(1,i) = norm(cen_data(:,i));
end
sigma_o = (max(dist) - min(dist)) /  (sqrt(2*num_cen));

% Calculate performance and plot graphs
close all
counter = 1;
for sigma = [sigma_o, 0.1:0.1:1, 2:1:10, 20:10:100, 200:100:1000, 2000:1000:10000]
%for sigma = [10000]
    disp(sigma)
    i_mat = cal_i_mat(train_data, sigma,cen_data);
    i_mat_test = cal_i_mat(test_data, sigma,cen_data);
    
    w = inv(i_mat'*i_mat) * i_mat' * double(train_classlabel_logic)';
    
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
    
    acc_th(1,counter) = sigma;                      % sigma value
    
    [acc_th(2,counter),thres] = max(TrAcc);         % max training accuracy
    acc_th(3,counter) = thr(1,thres);         
    
    [acc_th(4,counter),thres] = max(TeAcc);         % max testing accuracy
    acc_th(5,counter) = thr(1,thres);         
    
    counter = counter + 1;
    %figure;
    plot(thr,TrAcc,'.- ',thr,TeAcc,'^-');legend('tr','te','Location','southeast');
    grid
    title(strcat('Accuracy against Threshold (Width = ', " ", num2str(sigma), ")"))
    ylabel("Accuracy"); xlabel("Threshold");
    saveas(gcf,strcat("q2_b_image/b_",num2str(sigma),".jpg"))
end

figure;
hold on
plot(acc_th(1,:),acc_th(2,:),'-m');
plot(acc_th(1,:),acc_th(4,:),'-k');
legend('Training data','Test data','Location','northeast');
grid
title('Accuracy against Width');
ylabel("Accuracy"); xlabel("Width");
saveas(gcf,strcat("q2_b_image/b_","acc against thres",".jpg"))

toc

function matrix = cal_i_mat(data, sigma, train_data)
num_data = size(data,2);
num_cen = size(train_data,2);
matrix = zeros(num_data,num_cen);
for i = 1:num_data
    for j = 1:num_cen
        disp(['For width = ' num2str(sigma) ', calculating (' num2str(i) ',' num2str(j),')'])
        matrix(i,j) = exp (  (norm(data(:,i) - train_data(:,j)))^2  /  (-2*(sigma^2))   )  ;
    end
end
end