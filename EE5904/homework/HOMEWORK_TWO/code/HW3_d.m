%init
close all;clear;clc;


load('train_set.mat'); 
load('test_set.mat');
load('train_ground_truth');
load('test_ground_truth');

n=300;                   
net=patternnet(n,'trainscg','crossentropy');
net=configure(net,train_set,ground_truth_0);
net.trainParam.epochs=5000;  
net.trainParam.mc=0.9;
net.trainParam.lr=0.01;   
net.trainParam.show=50;    
net.divideFcn = 'dividetrain';

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