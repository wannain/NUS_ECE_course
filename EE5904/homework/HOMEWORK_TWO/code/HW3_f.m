%init
close all;clear;clc;

%For Training
file_dir0='D:\2021\NUS-ECE\EE5904-神经网络\homework\HOMEWORK_TWO\Face Database\TrainImages\';%路径前缀
img_list0=dir(strcat(file_dir0,'*.jpg'));
eyes_train_data=cell(1,1000);
eyes_train_BB=cell(1,1000);

for i=1:1000  %For Training%
    img_name0 = strcat(file_dir0,img_list0(i).name);%得到完整的路径
    img_rgb0=imread(num2str(img_name0));%将每张图片读出 rgb
    
    EyeDetect = vision.CascadeObjectDetector('EyePairBig'); %%detect eyes
    %EyeDetect.MergeThreshold = 10;
    BB=step(EyeDetect,img_rgb0);
    %Eyes=imcrop(img_rgb0,BB);
    %img_eyes_gray0=rgb2gray(Eyes);
    %img_eyes_gray1=img_eyes_gray1(1:16,1:69);
    %img_eyes_gray0=img_eyes_gray0(:);
    %eyes_train_data{:,i}=img_eyes_gray0;
    eyes_train_BB{:,i}=BB;
end

%For Testing
file_dir1='D:\2021\NUS-ECE\EE5904-神经网络\homework\HOMEWORK_TWO\Face Database\TestImages\';%路径前缀
img_list1=dir(strcat(file_dir1,'*.jpg'));
eyes_test_data=cell(1,250);
eyes_test_BB=cell(1,250);

for i=1:250  %For Testing%
    img_name1 = strcat(file_dir1,img_list1(i).name);%得到完整的路径
    img_rgb1=imread(num2str(img_name1));%将每张图片读出 rgb
    
    EyeDetect = vision.CascadeObjectDetector('EyePairBig'); %%detect eyes
    %EyeDetect.MergeThreshold = 10;
    BB=step(EyeDetect,img_rgb1);
    %Eyes=imcrop(img_rgb1,BB);
    
    %img_eyes_gray1=rgb2gray(Eyes);
    %img_eyes_gray1=img_eyes_gray1(1:16,1:69);
    %img_eyes_gray1=img_eyes_gray1(:);
    %eyes_test_data{:,i}=img_eyes_gray1;
    eyes_test_BB{:,i}=BB;
end

test_BB_update=cell(1,221);
j=1;
for i =1:length(eyes_test_BB)
    if isempty(eyes_test_BB{i})==0
        test_BB_update{:,j}=[eyes_test_BB{i}]';
        j=j+1;
    end
end

train_BB_update=cell(1,890);
j=1;
for i =1:length(eyes_train_BB)
    if isempty(eyes_train_BB{i})==0
        train_BB_update{:,j}=[eyes_train_BB{i}]';
        j=j+1;
    end
end

BB_test=cell2mat(test_BB_update);
BB_train=cell2mat(train_BB_update);
mean_test=mean(BB_test,2);
mean_train=mean(BB_train,2);

