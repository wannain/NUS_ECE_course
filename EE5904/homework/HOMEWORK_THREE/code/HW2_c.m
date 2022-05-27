%% Clear all variables and close all
close all
clear
clc
num_cen = 2;
mkdir q2_c_image
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

%% Kmeans clustering and calculate width
[idx, center] = kmeans(train_data',num_cen);
idx = idx';
cen_data = center';

%% Calculate interpolation matrix and weights
close all
counter = 1;
for sigma = [1:1:10, 20:10:100, 200:100:1000, 2000:1000:10000]
%for sigma = [1]
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
    saveas(gcf,strcat("q2_c_image/c_",num2str(sigma),".jpg"))
end

figure;
hold on
plot(acc_th(1,:),acc_th(2,:),'-m');
plot(acc_th(1,:),acc_th(4,:),'-k');
legend('Training data','Test data','Location','northeast');
grid
title('Accuracy against Width');
ylabel("Accuracy"); xlabel("Width");
saveas(gcf,strcat("q2_c_image/c_","acc against thres",".jpg"))

%% Plot centers and mean   
label0idx = find(~train_classlabel_logic == 1);
label1 = train_data(:,trainidx);
label1_mean = mean(label1,2);
label0 = train_data(:,label0idx);
label0_mean = mean(label0,2);

plotimages(cen_data,'Center');          % visualise centers from kmeans
plotimages(label1_mean,'Label 1');      % visualise label 1 mean
plotimages(label0_mean,'Label 0');      % visualise label 0 mean

toc

%% Functions
function plotimages(data,txt)
num_data = size(data, 2);
for i = 1:num_data
    img = reshape(data(:,i),[28 28]);
    figure;
    imshow(img');
    xlabel(txt)
end
end

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