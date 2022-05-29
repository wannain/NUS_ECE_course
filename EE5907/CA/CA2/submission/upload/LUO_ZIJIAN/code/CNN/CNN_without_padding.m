%Import Data
trainingSetup = load("E:\matlab\bin\project_code\EE5907\CA2\params_2021_11_12__06_08_18.mat");
%Import training and validation data.
imdsTrain = imageDatastore("E:\matlab\bin\project_code\EE5907\CA2\data","IncludeSubfolders",true,"LabelSource","foldernames");
[imdsTrain, imdsValidation] = splitEachLabel(imdsTrain,0.7);
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
    convolution2dLayer([5 5],20,"Name","conv_1","Padding","same")
    maxPooling2dLayer([2 2],"Name","maxpool_1","Padding","same","Stride",[2 2])
    convolution2dLayer([5 5],50,"Name","conv_2","Padding","same")
    maxPooling2dLayer([2 2],"Name","maxpool_2","Padding","same","Stride",[2 2])
    fullyConnectedLayer(500,"Name","fc_1")
    reluLayer("Name","relu")
    fullyConnectedLayer(21,"Name","fc_2")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];
%Train the network using the specified options and training data.
[net, traininfo] = trainNetwork(augimdsTrain,layers,opts);

