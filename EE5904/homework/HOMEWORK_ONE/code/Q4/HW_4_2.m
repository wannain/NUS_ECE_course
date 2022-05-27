%init
clc;clf;clear;

%para
eta=0.02;
i=1;
t=0;
epoch=100;
w0=zeros(1,epoch);
w1=zeros(1,epoch);
e1=zeros(1,epoch);

%input
x=[1,0.5;1,1.5;1,3;1,4.0;1,5.0];
d=[8.0,6.0,5,2,0.5];
w=rand(1,2);

%learning procedure
while (t<epoch)
    w0(i)=w(1);   %this number is b%
    w1(i)=w(2);   %this number is w%
    
    y=w*x';
    e=d-y;
    e1(i)=e*e'/2;
    w=w+eta*e*x; 
    
    t=t+1;
    i=i+1;
end

%Plot Trajectory of weights
subplot(1,2,1);
x_num=1:epoch;
plot(x_num,w0,'color','r','LineWidth',1);
hold on;
plot(x_num,w1,'color','b','LineWidth',1);
hold on;
%axis([0,epoch,-2,10]);
legend('w0','w1');
title('Trajectory of weights of LMS');
xlabel('epoch');
ylabel('value of weight');

%Plot Trajectory of error
subplot(1,2,2);
x_epoch=1:epoch;
plot(x_epoch,e1,'color','b','LineWidth',1);
hold on;
title('Error function versus epochs');
xlabel('epoch');
ylabel('Average error');

w_lms=w1(epoch);%LMS%
b_lms=w0(epoch);
x_num=0:epoch;
y1=w_lms.*x_num+b_lms;

figure(3);
plot(x_num,y1,'color','r','LineWidth',1);
hold on;
legend('LMS');
scatter([0.5,1.5,3,4.0,5.0],[8.0,6.0,5,2,0.5],'r','o');
axis([-1,12,-1,12]);
title('Linear Regression of LMS');
xlabel('x');
ylabel('y');
