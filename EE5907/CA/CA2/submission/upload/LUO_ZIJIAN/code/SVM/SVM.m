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
    Xdata_choose(:,i)=data_input(:,random(i));%arrange face images randomly
    ydata_choose(i)=data_class(random(i));%arrange the class of face images accordingly
end
Xdata_choose=Xdata_choose';
ydata_choose=ydata_choose';
Xdata_choose=im2double(Xdata_choose);

%deal with the images randomly by using pca
[coeff,score,latent] = pca(Xdata_choose);%deal with the images randomly by using pca

%For each chosen subject, use 70% of the provided images for training 
%and use the remaining 30% for testing.
for i=1:25
    class(i)=data_class(1+170*(i-1));
end
for i=1:25
    index(i,:)=find(ydata_choose==class(i));
end
score_train=[];
score_test=[];
ytrain=[];
ytest=[];
for i=1:25
    for j=1:170
        if j<170*0.7+1
           score_train=[score_train;score(index(i,j),:)];
            ytrain=[ytrain,ydata_choose(index(i,j))];
        else
            score_test=[score_test;score(index(i,j),:)];
            ytest=[ytest,ydata_choose(index(i,j))];
        end
    end
end 
Xtrain_raw=score_train;
Xtest_raw=score_test;
%%apply PCA to reduce the dimensionality of face images to 80 and 200 respectively.

%apply PCA to reduce the dimensionality of face images to 80
Xtrain_80(:,1:80)=score_train(:,1:80);
Xtest_80(:,1:80)=score_test(:,1:80);

%apply PCA to reduce the dimensionality of face images to 200
Xtrain_200(:,1:200)=score_train(:,1:200);
Xtest_200(:,1:200)=score_test(:,1:200);

%%Try values of the penalty parameter C in {1x10^-2, 1x10^-1, 1}
% use SVM package.libSVM
model=svmtrain(ytrain',Xtrain_raw,['-t 0 -c 0.01']);
[predicted_label_raw,accuracy_raw,decision_values_raw]=svmpredict(ytest',Xtest_raw,model,['-b 0']);
acc_raw(1)=accuracy_raw(1);
model=svmtrain(ytrain',Xtrain_raw,['-t 0 -c 0.1']);
[predicted_label_raw,accuracy_raw,decision_values_raw]=svmpredict(ytest',Xtest_raw,model,['-b 0']);
acc_raw(2)=accuracy_raw(1);
model=svmtrain(ytrain',Xtrain_raw,['-t 0 -c 1']);
[predicted_label_raw,accuracy_raw,decision_values_raw]=svmpredict(ytest',Xtest_raw,model,['-b 0']);
acc_raw(3)=accuracy_raw(1);

model=svmtrain(ytrain',Xtrain_80,['-t 0 -c 0.01']);
[predicted_label_80,accuracy_80,decision_values_40]=svmpredict(ytest',Xtest_80,model,['-b 0']);
acc_80(1)=accuracy_80(1);
model=svmtrain(ytrain',Xtrain_80,['-t 0 -c 0.1']);
[predicted_label_80,accuracy_80,decision_values_40]=svmpredict(ytest',Xtest_80,model,['-b 0']);
acc_80(2)=accuracy_80(1);
model=svmtrain(ytrain',Xtrain_80,['-t 0 -c 1']);
[predicted_label_80,accuracy_80,decision_values_40]=svmpredict(ytest',Xtest_80,model,['-b 0']);
acc_80(3)=accuracy_80(1);

model=svmtrain(ytrain',Xtrain_200,['-t 0 -c 0.01']);
[predicted_label_200,accuracy_200,decision_values_200]=svmpredict(ytest',Xtest_200,model,['-b 0']);
acc_200(1)=accuracy_200(1);
model=svmtrain(ytrain',Xtrain_200,['-t 0 -c 0.1']);
[predicted_label_200,accuracy_200,decision_values_200]=svmpredict(ytest',Xtest_200,model,['-b 0']);
acc_200(2)=accuracy_200(1);
model=svmtrain(ytrain',Xtrain_200,['-t 0 -c 1']);
[predicted_label_200,accuracy_200,decision_values_200]=svmpredict(ytest',Xtest_200,model,['-b 0']);
acc_200(3)=accuracy_200(1);

fprintf('the classification accuracy with parameter C=0.01 in raw data: %f %%\n',acc_raw(1));
fprintf('the classification accuracy with parameter C=0.1 in raw data: %f %%\n',acc_raw(2));
fprintf('the classification accuracy with parameter C=1 in raw data: %f %%\n',acc_raw(3));
fprintf('the classification accuracy with parameter C=0.01 after PCA processing(with dimensionality of 80): %f %%\n',acc_80(1));
fprintf('the classification accuracy with parameter C=0.1 after PCA processing(with dimensionality of 80): %f %%\n',acc_80(2));
fprintf('the classification accuracy with parameter C=1 after PCA processing(with dimensionality of 80): %f %%\n',acc_80(3));
fprintf('the classification accuracy with parameter C=0.01 after PCA processing(with dimensionality of 200): %f %%\n',acc_200(1));
fprintf('the classification accuracy with parameter C=0.1 after PCA processing(with dimensionality of 200): %f %%\n',acc_200(2));
fprintf('the classification accuracy with parameter C=1 after PCA processing(with dimensionality of 200): %f %%\n',acc_200(3));











