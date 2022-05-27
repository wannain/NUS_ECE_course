

load('train_set.mat'); 
load('test_set.mat');
load('train_ground_truth');
load('test_ground_truth');

n=10;
[net,accu_train,accu_test]=train_seq(n,train_set,ground_truth_0,1000,0,100);

%validate
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

function [ net, accu_train, accu_val ] = train_seq( n, images, labels, train_num, val_num, epochs )
% Construct a 1-n-1 MLP and conduct sequential training.
%
% Args:
% n:            int, number of neurons in the hidden layer of MLP.
% images:       matrix of (image_dim, image_num), containing possibly preprocessed image data as input.
% labels:       vector of (1, image_num), containing corresponding label of each image.
% train_num:    int, number of training images.
% val_num:      int, number of validation images.
% epochs:       int, number of training epochs.
%
% Returns:
% net:          object, containing trained network.
% accu_train:   vector of (epochs, 1), containing the accuracy on training set of each eopch during training
% accu_val:     vector of (epochs, 1), containing the accuracy on validation set of each eopch during trainig.
% 1. Change the input to cell array form for sequential training
images_c = num2cell(images, 1);
labels_c = num2cell(labels, 1);
% 2. Construct and configure the MLP
net = patternnet(n);
net.divideFcn = 'dividetrain';              % input for training only
net.performParam.regularization = 0.1;     % regularization strength
net.trainFcn = 'trainrp';                  % 'trainrp' 'traingdx'
net.trainParam.epochs = epochs;
net.inputWeights{1,1}.learnParam.lr = 0.003;
net.layerWeights{2,1}.learnParam.lr = 0.003;
net.biases{1}.learnParam.lr = 0.002;
net.biases{2}.learnParam.lr = 0.002;
accu_train = zeros(epochs,1);               % record accuracy on training set of each epoch
accu_val = zeros(epochs,1);                 % record accuracy on validation set of each epoch
% 3. Train the network in sequential mode
for i = 1 : epochs
    display(['Epoch: ', num2str(i)])
    idx = randperm(train_num);                          % shuffle the input
    net = adapt(net, images_c(:,idx), labels_c(:,idx));
    pred_train = round(net(images(:,1:train_num)));     % predictions on training set
    accu_train(i) = 1 - mean(abs(pred_train-labels(1:train_num)));
    pred_val = round(net(images(:,train_num+1:end)));   % predictions on validation set
    accu_val(i) = 1 - mean(abs(pred_val-labels(train_num+1:end)));
    %disp(accu_train(i))
end
end