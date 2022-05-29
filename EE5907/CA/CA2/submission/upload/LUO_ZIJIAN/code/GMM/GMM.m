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
    data_input_choose(:,i)=data_input(:,random(i));%arrange face images randomly
    data_class_choose(i)=data_class(random(i));%arrange the class of face images accordingly
end
data_input_choose=data_input_choose';
data_class_choose=data_class_choose';
data_input_choose=im2double(data_input_choose);

%deal with the images randomly by using pca
[coeff,score,latent] = pca(data_input_choose);%deal with the images randomly by using pca

%Use the raw face images (vectorized) and the face vectors after PCA pre-processing 
%(with dimensionality of 200 and 80 respectively) as the provided training data.
Xdata_raw=score(:,1:2);
Xdata_80=score(:,1:80);
Xdata_80=score(:,1:2);
Xdata_200=score(:,1:200);
Xdata_200=score(:,1:2);

options = statset('MaxIter',1000);

%%Train a GMM model with 3 Gaussian components on these data.
gm_raw=fitgmdist(Xdata_raw,3,'Options',options,'RegularizationValue',0.1);
p_raw=posterior(gm_raw,Xdata_raw);
for i=1:length(data_class)
    [a,X_raw_class(i)]=max(p_raw(i,:));
end

figure
gscatter(Xdata_raw(:,1),Xdata_raw(:,2),X_raw_class)
title('GMM for clustering with raw data');
hold on

gm_80=fitgmdist(Xdata_80,3,'Options',options,'RegularizationValue',0.1);
p_80=posterior(gm_80,Xdata_80);
for i=1:length(data_class)
    [a,X80_class(i)]=max(p_80(i,:));
end

figure
gscatter(Xdata_80(:,1),Xdata_80(:,2),X80_class)
title('GMM for clustering with 80 dimensionalities');
hold on

gm_200=fitgmdist(Xdata_200,3,'Options',options,'RegularizationValue',0.1);
p_200=posterior(gm_200,Xdata_200);
for i=1:length(data_class)
    [a,X200_class(i)]=max(p_200(i,:));
end

figure
gscatter(Xdata_200(:,1),Xdata_200(:,2),X200_class)
title('GMM for clustering with 200 dimensionalities');


