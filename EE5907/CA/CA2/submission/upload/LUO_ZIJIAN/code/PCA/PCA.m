clear
clc
close all
load data.mat
load selfdata.mat
%Pre-processing

%I choose the 25 subjects from CMU PIE dataset randomly and store them in the data.mat', by running 'pre_processing.m'
%I also take 10 selfie photos, convert to gray-scale images, resize them into the same resolution as the CMU PIE images 
%and store them in the 'selfdata.mat', by running 'self_data_processing.m' 

%arrange data randomly before PCA
random=randperm(length(data_class));
for i=1:length(data_class)
    data_input_PIE(:,i)=data_input(:,random(i));%arrange face images randomly
    data_class_PIE(i)=data_class(random(i));%arrange the class of face images accordingly
end
data_input_PIE=data_input_PIE';
data_class_PIE=data_class_PIE';
data_input_PIE=im2double(data_input_PIE);
self_input=im2double(self_input);
self_input=self_input';
data_input_PIE=[data_input_PIE;self_input];

%deal with the images randomly by using pca
[coeff,score,latent] = pca(data_input_PIE);%deal with the images randomly by using pca

%For each chosen subject, use 70% of the provided images for training 
%and use the remaining 30% for testing.
for i=1:25
    class(i)=data_class(1+170*(i-1));
end
for i=1:25
    index(i,:)=find(data_class_PIE==class(i));
end
score_train=[];
score_test=[];
ytrain=[];
ytest=[];
for i=1:25
    for j=1:170
        if j<170*0.7+1
           score_train=[score_train;score(index(i,j),:)];
            ytrain=[ytrain,data_class_PIE(index(i,j))];
        else
            score_test=[score_test;score(index(i,j),:)];
            ytest=[ytest,data_class_PIE(index(i,j))];
        end
    end
end 
self_train=score(4251:4257,:);
self_test=score(4258:4260,:);

%%. Randomly sample 500 images from the CMU PIE training set and your own photos. 
%%Apply PCA to reduce the dimensionality of vectorized images to 2 and 3 respectively.
random=randperm(length(ytrain));
random=random(1:500);
X500=[];
for i=1:500
    X500=[X500;score_train(random(i),:)];
end
X500_2=X500(:,1:2);
X500_3=X500(:,1:3);

%my own photos
X500_self_2=score(4251:4260,1:2);
X500_self_3=score(4251:4260,1:3);

%Visualize the projected data vector in 2D and 3D plots
X500_2=[X500_2;X500_self_2];
X500_3=[X500_3;X500_self_3];
c=[ones(500,1);[ones(10,1)+1]];
figure
scatter(X500_2(:,1),X500_2(:,2),10,c);
title('2D plots of PCA');
hold on
figure
C=[zeros(500,1);[zeros(10,1)+1]];
scatter3(X500_3(:,1),X500_3(:,2),X500_3(:,3),15,c);
title('3D plots of PCA');
hold on

%%Visualize the corresponding 3 eigenfaces used for the dimensionality
%%reduction
efmax=max(coeff');
efmin=min(coeff');
efmin=efmin(:);
efmax=efmax(:);
eigenface=(coeff-efmin)./(efmax-efmin);%project the point of eigenvector from 0 to 1
figure
for i=1:3
    n=num2str(i);
    subplot(1,3,i)
    imshow(reshape(eigenface(:,i),32,32)),title(['eigenface PCA' n]);
end

%%apply PCA to reduce the dimensionality of face images to 40, 80 and 200 respectively.

%apply PCA to reduce the dimensionality of face images to 40
Xtrain_40(:,1:40)=score_train(:,1:40);
Xtest_40(:,1:40)=score_test(:,1:40);
selftrain_40=self_train(:,1:40);
selftest_40=self_test(:,1:40);
self_class=self_class';
%Classifying the test images using the rule of nearest neighbor.
ytest_40=NNclassifier(Xtest_40,Xtrain_40,ytrain);
yself_40=NNclassifier(selftest_40,[Xtrain_40;selftrain_40],[ytrain,self_class(1:7)]);
%Report the classification accuracy on the CMU PIE test images
acc_test_40=0;
[R_t,C]=size(Xtest_40);
for i_t=1:R_t
     if ytest_40(i_t)==ytest(i_t)
        acc_test_40=acc_test_40+1;
     end
 end
acc_test_40=acc_test_40/R_t;
fprintf('classification accuracy on the CMU PIE test images with 40 dimensionalities:%f\n',100*acc_test_40);

%Report the classification accuracy on my own photos
acc_selftest_40=0;
for i_t=1:length(yself_40)
     if yself_40(i_t)==26
        acc_selftest_40=acc_selftest_40+1;
     end
 end
acc_selftest_40=acc_selftest_40/length(yself_40);
fprintf('classification accuracy on my own photos with 40 dimensionalities:%f\n',100*acc_selftest_40);



%apply PCA to reduce the dimensionality of face images to 80
Xtrain_80(:,1:80)=score_train(:,1:80);
Xtest_80(:,1:80)=score_test(:,1:80);
selftrain_80=self_train(:,1:80);
selftest_80=self_test(:,1:80);
%Classifying the test images using the rule of nearest neighbor.
ytest_80=NNclassifier(Xtest_80,Xtrain_80,ytrain);
yself_80=NNclassifier(selftest_80,[Xtrain_80;selftrain_80],[ytrain,self_class(1:7)]);
%Report the classification accuracy on the CMU PIE test images
acc_test_80=0;
[R_t,C]=size(Xtest_80);
for i_t=1:R_t
     if ytest_80(i_t)==ytest(i_t)
        acc_test_80=acc_test_80+1;
     end
 end
acc_test_80=acc_test_80/R_t;
fprintf('classification accuracy on the CMU PIE test images with 80 dimensionalities:%f\n',100*acc_test_80);

%Report the classification accuracy on my own photos
acc_selftest_80=0;
for i_t=1:length(yself_80)
     if yself_80(i_t)==26
        acc_selftest_80=acc_selftest_80+1;
     end
 end
acc_selftest_80=acc_selftest_80/length(yself_80);
fprintf('classification accuracy on my own photos with 80 dimensionalities:%f\n',100*acc_selftest_80);



%apply PCA to reduce the dimensionality of face images to 200
Xtrain_200(:,1:200)=score_train(:,1:200);
Xtest_200(:,1:200)=score_test(:,1:200);
selftrain_200=self_train(:,1:200);
selftest_200=self_test(:,1:200);
%Classifying the test images using the rule of nearest neighbor.
ytest_200=NNclassifier(Xtest_200,Xtrain_200,ytrain);
yself_200=NNclassifier(selftest_200,[Xtrain_200;selftrain_200],[ytrain,self_class(1:7)]);
%Report the classification accuracy on the CMU PIE test images
acc_test_200=0;
[R_t,C]=size(Xtest_200);
for i_t=1:R_t
     if ytest_200(i_t)==ytest(i_t)
        acc_test_200=acc_test_200+1;
     end
 end
acc_test_200=acc_test_200/R_t;
fprintf('classification accuracy on the CMU PIE test images with 200 dimensionalities:%f\n',100*acc_test_200);

%Report the classification accuracy on my own photos
acc_selftest_200=0;
for i_t=1:length(yself_200)
     if yself_200(i_t)==26
        acc_selftest_200=acc_selftest_200+1;
     end
 end
acc_selftest_200=acc_selftest_200/length(yself_200);
fprintf('classification accuracy on my own photos with 200 dimensionalities:%f\n',100*acc_selftest_200);

function [ytest] = NNclassifier(Xtest,Xtrain,ytrain)
  for i=1:size(Xtest,1)
      Xtest_1=ones(length(size(Xtrain,1)),1)*Xtest(i,:);
      distance=(sum((Xtest_1-Xtrain).^2,2)).^0.5;%caculate the distance of eatch face images in Xtest and all face image in Xtrain 
      [dist_asc,index]=sort(distance);%sort the distances from smallest to largest to find the nearest face image in Xtrain  
      ytest(i)=ytrain(index(1));%store the predicted class of each face images in Xtest  
  end
end


