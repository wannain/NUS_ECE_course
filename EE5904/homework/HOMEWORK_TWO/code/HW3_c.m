%init
close all;clear;clc;


%For Training
file_dir0='D:\2021\NUS-ECE\EE5904-神经网络\homework\HOMEWORK_TWO\Face Database\TrainImages\';%路径前缀
img_list0=dir(strcat(file_dir0,'*.jpg'));
att_list0=dir(strcat(file_dir0,'*.att'));
image_c0=cell(1,1000);
image_pca0=cell(1,1000);
ground_truth_0=zeros(1,1000);

for i=1:1000  %For Training%
    img_name0 = strcat(file_dir0,img_list0(i).name);%得到完整的路径
    att_name0 = strcat(file_dir0,att_list0(i).name);
    img_rgb0=imread(num2str(img_name0));%将每张图片读出 rgb
    
    img_gray0=rgb2gray(img_rgb0);
    
    %img_gray0=im2double(img_gray0); %pca alogorithm%
    %img_gray0=pca(img_gray0);
    %img_gray0=img_gray0(1:101,1:100);
    %img_G=img_gray0(:);
    %image_pca0{:,i}=img_G;
    
    img_gray0=imresize(img_gray0,0.5); %simply downsample%
    img_gray0=img_gray0(1:51,1:51);
    img_G=img_gray0(:);
    image_c0{:,i}=img_G;
    
    %ground_truth for training
    L=load(att_name0);
    ground_truth_number=L(2);
    ground_truth_0(:,i)=ground_truth_number;
end

%For Testing
file_dir1='D:\2021\NUS-ECE\EE5904-神经网络\homework\HOMEWORK_TWO\Face Database\TestImages\';%路径前缀
img_list1=dir(strcat(file_dir1,'*.jpg'));
att_list1=dir(strcat(file_dir1,'*.att'));
image_c1=cell(1,250);
image_pca1=cell(1,250);
ground_truth_1=zeros(1,250);

for i=1:250  %For Testing%
    img_name1 = strcat(file_dir1,img_list1(i).name);%得到完整的路径
    att_name1 = strcat(file_dir1,att_list1(i).name);
    img_rgb1=imread(num2str(img_name1));%将每张图片读出 rgb
    
    img_gray1=rgb2gray(img_rgb1);
    
    %img_gray1=im2double(img_gray1);%pca alogorithm%
    %img_gray1=pca(img_gray1);
    %img_gray1=img_gray1(1:101,1:100);
    %img_G=img_gray1(:);
    %image_pca1{:,i}=img_G;
    
    img_gray1=imresize(img_gray1,0.5);
    img_gray1=img_gray1(1:51,1:51);
    img_G=img_gray1(:);
    image_c1{:,i}=img_G;
    
    %ground_truth for Testing
    L=load(att_name1);
    ground_truth_number=L(2);
    ground_truth_1(:,i)=ground_truth_number;
end

image_mat0=cell2mat(image_c0);
image_mat1=cell2mat(image_c1);
%image_mat0=cell2mat(image_pca0);
%image_mat1=cell2mat(image_pca1);
train_set=double(image_mat0);
test_set=double(image_mat1); 

save('train_set.mat','train_set');
save('test_set.mat','test_set');

%init train/test label
train_label=zeros(1,1000);
test_label=zeros(1,250);
x0=1:1000;
x1=1:250;
train_std=std(ground_truth_0);
test_std=std(ground_truth_1);

%set network
net=perceptron('hardlim','learnpn');
net.trainParam.epochs=500;  
net.trainParam.show=50;   
net.trainParam.lr=0.01; 
net.divideFcn = 'dividetrain';
net.performParam.regularization = 0.1; 

[net,tr]=train(net,train_set,ground_truth_0);
output_test=sim(net,test_set);

%accuracy
output_train=sim(net,train_set);
test=0;
train=0;
for i=1:250
    value=abs(output_test(i)-ground_truth_1(i));
    if(value<0.5)
        test=test+1;    
    end
end
for i=1:1000
    value=abs(output_train(i)-ground_truth_0(i));
    if(value<0.5)
        train=train+1;    
    end
end

accuracy_train=sprintf('accuracy_train= %0.1f%%',train/10);
disp(accuracy_train);
accuracy_test=sprintf('accuracy_test= %0.1f%%',test/2.5);
disp(accuracy_test);

plotperform(tr);