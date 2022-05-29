%This function is for Q3
%Given w and λ，compute the NLL with regularization

function y = NLL_reg(X,Y,w,lambda)
[train_num,fea_num] = size(X);
wTx = X*w;
y = 0;
for i = 1:train_num; %compute NLL
    y = y +Y(i)*log(1/(1+exp(-wTx(i))))+(1-Y(i))*log(1/(1+exp(wTx(i))));
end
w1 = w';
w1 = w1(2:end); %Do not regularization on the bias term

y = -y + 0.5*lambda*w1*w1'; %NLL with regularization
    
    
