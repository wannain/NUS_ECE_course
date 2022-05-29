%Import Data
trainingSetup = load("E:\matlab\bin\project_code\EE5907\CA2\CNN_test_data\params_2021_11_11__04_18_22.mat");
%Import training and validation data.
imdsTrain = imageDatastore("D:\2021\NUS-ECE\semester2\EE5907 模式识别\CA\CA2\data","IncludeSubfolders",true,"LabelSource","foldernames");
[imdsTrain, imdsValidation] = splitEachLabel(imdsTrain,0.7,"randomized");

augimdsTrain = augmentedImageDatastore([32 32 1],imdsTrain);
augimdsValidation = augmentedImageDatastore([32 32 1],imdsValidation);
%Set Training Options
%Specify options to use when training.
opts = trainingOptions("sgdm",...
    "ExecutionEnvironment","auto",...
    "InitialLearnRate",0.0005,...
    "Shuffle","every-epoch",...
    "Plots","training-progress",...
    "ValidationData",augimdsValidation);
%Create Array of Layers
layers = [
    imageInputLayer([32 32 1],"Name","imageinput")
    convolution2dLayer([5 5],20,"Name","conv_1")
    maxPooling2dLayer([2 2],"Name","maxpool_1","Padding","same","Stride",[2 2])
    convolution2dLayer([5 5],50,"Name","conv_2")
    maxPooling2dLayer([2 2],"Name","maxpool_2","Padding","same","Stride",[2 2])
    fullyConnectedLayer(500,"Name","fc_1")
    reluLayer("Name","relu")
    fullyConnectedLayer(21,"Name","fc_2")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];
%Train the network using the specified options and training data.
[net, traininfo] = trainNetwork(augimdsTrain,layers,opts);
