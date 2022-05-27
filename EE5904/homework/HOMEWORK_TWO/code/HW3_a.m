%init
close all;clear;clc;

%For Training
file_dir0='D:\2021\NUS-ECE\EE5904-神经网络\homework\HOMEWORK_TWO\Face Database\TrainImages\';%路径前缀
img_list0=dir(strcat(file_dir0,'*.jpg'));
att_list0=dir(strcat(file_dir0,'*.att'));
image_c0=cell(1,1000);
ground_truth_0=zeros(1,1000);

for i=1:1000  %For Training%
    img_name0 = strcat(file_dir0,img_list0(i).name);%得到完整的路径
    att_name0 = strcat(file_dir0,att_list0(i).name);
    img_rgb0=imread(num2str(img_name0));%将每张图片读出 rgb
    img_gray0=rgb2gray(img_rgb0);
    img_gray0=img_gray0(1:101,1:101);
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
ground_truth_1=zeros(1,250);

for i=1:250  %For Testing%
    img_name1 = strcat(file_dir1,img_list1(i).name);%得到完整的路径
    att_name1 = strcat(file_dir1,att_list1(i).name);
    img_rgb1=imread(num2str(img_name1));%将每张图片读出 rgb
    img_gray1=rgb2gray(img_rgb1);
    img_gray1=img_gray1(1:101,1:101);
    img_G=img_gray1(:);
    image_c1{:,i}=img_G;
    
    %ground_truth for Testing
    L=load(att_name1);
    ground_truth_number=L(2);
    ground_truth_1(:,i)=ground_truth_number;
end

image_mat0=cell2mat(image_c0);
image_mat1=cell2mat(image_c1);
train_set=double(image_mat0);
test_set=double(image_mat1);

figure(1)
train_length=size(ground_truth_0,2);
train_seq=1:train_length;
scatter(train_seq,ground_truth_0,'o');
title("train set label distribution");
figure(2)
test_length=size(ground_truth_1,2);
test_seq=1:test_length;
scatter(test_seq,ground_truth_1,'o');
title("test set label distribution");