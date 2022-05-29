clear
clc
close all
load data.mat
load selfdata.mat
%Pre-processing

%I choose the 25 subjects from CMU PIE dataset randomly and store them in the data.mat', by running 'pre_processing.m'
%I also take 10 selfie photos, convert to gray-scale images, resize them into the same resolution as the CMU PIE images 
%and store them in the 'selfdata.mat', by running 'self_data_processing.m' 
data_input=im2double(data_input);
data_input=data_input';
self_input=im2double(self_input);
self_input=self_input';

%class-specific mean vector
u_i=[];
for i=0:24
    data_input_1=data_input(1+i*170:170+i*170,:);
    u_i=[u_i;mean(data_input_1)];
end 
u_i=[u_i;mean(self_input(1:7,:))];

%class-specific covariance matrix
k=1;
for i=0:24
    data_input_1=data_input(1+i*170:170+i*170,:);
    s{k}=cov(data_input_1);
    k=k+1;
end
s{k}=cov(self_input(1:7,:));

%Total mean vector
u_t=mean([data_input;self_input]);

%Within-class scatter
s_w=0;
for i=1:26
    s_w=s_w+s{i};
end

%Between-class scatter
s_b=0;
for i=1:26
    s_b_1=(u_i(i,:)-u_t)'*(u_i(i,:)-u_t);
    s_b=s_b+s_b_1;
end 

%LDA process
[w,lamda]=eig(inv(s_w)*s_b);

%%deal with the images randomly by using LDA
data_input=[data_input;self_input]*w;

%%For each chosen subject, use 70% of the provided images for training 
%%and use the remaining 30% for testing.

%arrange data randomly 
random=randperm(length(data_class));
for i=1:length(data_class)
    data_input_1(i,:)=data_input(random(i),:);%arrange face images randomly
    data_class_1(i)=data_class(random(i));%arrange the class of face images accordingly
end

%For each chosen subject, use 70% of the provided images for training 
%and use the remaining 30% for testing.
for i=1:25
    class(i)=data_class(1+170*(i-1));
end
for i=1:25
    index(i,:)=find(data_class_1==class(i));
end
xtrain=[];
xtest=[];
ytrain=[];
ytest=[];
for i=1:25
    for j=1:170
        if j<170*0.7+1
           xtrain=[xtrain;data_input_1(index(i,j),:)];
            ytrain=[ytrain,data_class_1(index(i,j))];
        else
            xtest=[xtest;data_input_1(index(i,j),:)];
            ytest=[ytest,data_class_1(index(i,j))];
        end
    end
end 

%Visualize distribution of the sampled data (as in the PCA section) with 
%dimensionality of 2 and 3 respectively.
%%. Randomly sample 500 images from the CMU PIE training set and your own photos. 
%%Apply PCA to reduce the dimensionality of vectorized images to 2 and 3 respectively.
random=randperm(length(ytrain));
random=random(1:500);
X500=[];
for i=1:500
    X500=[X500;xtrain(random(i),:)];
end
X500_2=X500(:,1:2);
X500_3=X500(:,1:3);
X500_2=[X500_2;data_input(4251:4260,1:2)];
X500_3=[X500_3;data_input(4251:4260,1:3)];

c=[ones(500,1);[ones(10,1)+1]];
figure
scatter(X500_2(:,1),X500_2(:,2),7,c);
title('2D plots of LDA');
hold on
C=[zeros(500,1);[zeros(10,1)+1]];
figure
scatter3(X500_3(:,1),X500_3(:,2),X500_3(:,3),20 ,c);
title('3D plots of LDA');
hold on


%%Report the classification accuracy for data with dimensions of 2, 3 and 9 respectively,
%%based on nearest neighbor classifier.

%apply LDA to reduce the dimensionality of face images to 2
xtrain_2=xtrain(:,1:2);
xtest_2=xtest(:,1:2);
selftrain_2=data_input(4251:4257,1:2);
selftest_2=data_input(4258:4260,1:2);
self_class=self_class';
%Classifying the test images using the rule of nearest neighbor.
ytest_2=NNclassifier(xtest_2,xtrain_2,ytrain);
yself_2=NNclassifier(selftest_2,[xtrain_2;selftrain_2],[ytrain,self_class(1:10)]);
%Report the classification accuracy on the CMU PIE test images
acc_test_2=0;
[R_t,C]=size(xtest_2);
for i_t=1:R_t
     if ytest_2(i_t)==ytest(i_t)
        acc_test_2=acc_test_2+1;
     end
 end
acc_test_2=acc_test_2/R_t;
fprintf('classification accuracy on the CMU PIE test images with 2 dimensionalities:%f\n',acc_test_2);

%Report the classification accuracy on my own photos
acc_selftest_2=0;
for i_t=1:length(yself_2)
     if yself_2(i_t)==26
        acc_selftest_2=acc_selftest_2+1;
     end
 end
acc_selftest_2=acc_selftest_2/length(yself_2);
fprintf('classification accuracy on my own photos with 2 dimensionalities:%f\n',acc_selftest_2);


%apply LDA to reduce the dimensionality of face images to 3
xtrain_3=xtrain(:,1:3);
xtest_3=xtest(:,1:3);
selftrain_3=data_input(4251:4257,1:3);
selftest_3=data_input(4258:4260,1:3);
%Classifying the test images using the rule of nearest neighbor.
ytest_3=NNclassifier(xtest_3,xtrain_3,ytrain);
yself_3=NNclassifier(selftest_3,[xtrain_3;selftrain_3],[ytrain,self_class(1:7)]);
%Report the classification accuracy on the CMU PIE test images
acc_test_3=0;
[R_t,C]=size(xtest_3);
for i_t=1:R_t
     if ytest_3(i_t)==ytest(i_t)
        acc_test_3=acc_test_3+1;
     end
 end
acc_test_3=acc_test_3/R_t;
fprintf('classification accuracy on the CMU PIE test images with 3 dimensionalities:%f\n',acc_test_3);

%Report the classification accuracy on my own photos
acc_selftest_3=0;
for i_t=1:length(yself_3)
     if yself_3(i_t)==26
        acc_selftest_3=acc_selftest_3+1;
     end
 end
acc_selftest_3=acc_selftest_3/length(yself_3);
fprintf('classification accuracy on my own photos with 3 dimensionalities:%f\n',acc_selftest_3);

%apply LDA to reduce the dimensionality of face images to 9
xtrain_9=xtrain(:,1:9);
xtest_9=xtest(:,1:9);
selftrain_9=data_input(4251:4257,1:9);
selftest_9=data_input(4258:4260,1:9);
%Classifying the test images using the rule of nearest neighbor.
ytest_9=NNclassifier(xtest_9,xtrain_9,ytrain);
yself_9=NNclassifier(selftest_9,[xtrain_9;selftrain_9],[ytrain,self_class(1:7)]);
%Report the classification accuracy on the CMU PIE test images
acc_test_9=0;
[R_t,C]=size(xtest_9);
for i_t=1:R_t
     if ytest_9(i_t)==ytest(i_t)
        acc_test_9=acc_test_9+1;
     end
 end
acc_test_9=acc_test_9/R_t;
fprintf('classification accuracy on the CMU PIE test images with 9 dimensionalities:%f\n',acc_test_9);

%Report the classification accuracy on my own photos
acc_selftest_9=0;
for i_t=1:length(yself_9)
     if yself_9(i_t)==26
        acc_selftest_9=acc_selftest_9+1;
     end
 end
acc_selftest_9=acc_selftest_9/length(yself_9);
fprintf('classification accuracy on my own photos with 9 dimensionalities:%f\n',acc_selftest_9);

function [ytest] = NNclassifier(Xtest,Xtrain,ytrain)
  for i=1:size(Xtest,1)
      Xtest_1=ones(length(size(Xtrain,1)),1)*Xtest(i,:);
      distance=(sum((Xtest_1-Xtrain).^2,2)).^0.5;%caculate the distance of eatch face images in Xtest and all face image in Xtrain 
      [dist_asc,index]=sort(distance);%sort the distances from smallest to largest to find the nearest face image in Xtrain  
      ytest(i)=ytrain(index(1));%store the predicted class of each face images in Xtest  
  end
end















