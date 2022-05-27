close all
clear
clc

syms x y;
y = 1.2*sin(pi*x)-cos(2.4*pi*x);

training_set_input(:) = -2:0.05:2;
training_set_output(1,:) = eval(subs(y,x,training_set_input(1,:)));
test_set_input(:) = -2:0.01:2;
test_set_output(1,:) = eval(subs(y,x,test_set_input(1,:)));
desired_input(:) = -3:0.05:3;
desired_output(:) = eval(subs(y,x,desired_input(1,:)));

x = training_set_input;
t = training_set_output;

% Choose a Training Function
trainFcn = 'trainlm';  

% Create a Fitting Network
for n = [1:10,20,50,100]
hiddenLayerSize = n;
net = fitnet(hiddenLayerSize,trainFcn);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 80/100;
net.divideParam.valRatio = 5/100;
net.divideParam.testRatio = 15/100;

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y);

% View the Network
%view(net)
%figure;
%plotfit(net,x,t)


results = sim(net, -3:0.01:3);
figure
plot(training_set_input,training_set_output,'rx') %training output     
hold on
plot(-3:0.01:3,results(1,:),'b','LineWidth',1.5);                %mlp output
plot(desired_input,desired_output,'k-.');       %desired output
line([-2 -2], [-2.5 2.5],'Color','magenta', 'LineStyle','--');
line([2 2], [-2.5 2.5],'Color','magenta', 'LineStyle','--');
legend('Training Output', 'MLP Output', 'Desired Output', 'Limits');
title(strcat("1-", num2str(n), "-1 on batch mode with trainlm"));
xlabel('x');
ylabel('y');
grid
saveas(gcf,num2str(n) ,'jpg');
end