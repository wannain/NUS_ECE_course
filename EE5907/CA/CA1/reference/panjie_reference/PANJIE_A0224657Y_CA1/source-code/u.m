%This function is for Q3
%Given w, compute the μ vector
function y = u(X,w)
[train_num fea_num] = size(X);
wTx = X*w;
y = ones(train_num,1);
for i = 1:train_num;
    y(i) = 1/(1+exp(-wTx(i)));
end
