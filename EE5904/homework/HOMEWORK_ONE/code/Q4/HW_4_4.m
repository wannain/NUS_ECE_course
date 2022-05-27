%init
clc;clf;clear;

%para
eta_a=0.008;
eta_b=0.01;
eta_c=0.03;
eta_d=0.05;
i=1;
t=0;
epoch=100;
w0_a=zeros(1,epoch);
w1_a=zeros(1,epoch);
e1_a=zeros(1,epoch);
w0_b=zeros(1,epoch);
w1_b=zeros(1,epoch);
e1_b=zeros(1,epoch);
w0_c=zeros(1,epoch);
w1_c=zeros(1,epoch);
e1_c=zeros(1,epoch);
w0_d=zeros(1,epoch);
w1_d=zeros(1,epoch);
e1_d=zeros(1,epoch);

%input
x=[1,0.5;1,1.5;1,3;1,4.0;1,5.0];
d=[8.0,6.0,5,2,0.5];
w_a=rand(1,2);
w_b=rand(1,2);
w_c=rand(1,2);
w_d=rand(1,2);

%learning procedure
while (t<epoch)
    w0_a(i)=w_a(1);   %this number is b%
    w1_a(i)=w_a(2);   %this number is w%
    w0_b(i)=w_b(1);   %this number is b%
    w1_b(i)=w_b(2);   %this number is w%
    w0_c(i)=w_c(1);   %this number is b%
    w1_c(i)=w_c(2);   %this number is w%
    w0_d(i)=w_d(1);   %this number is b%
    w1_d(i)=w_d(2);   %this number is w%
    
    y_a=w_a*x';
    e_a=d-y_a;
    e1_a(i)=e_a*e_a'/2;
    w_a=w_a+eta_a*e_a*x; 
    
    y_b=w_b*x';
    e_b=d-y_b;
    e1_b(i)=e_b*e_b'/2;
    w_b=w_b+eta_b*e_b*x; 
    
    y_c=w_c*x';
    e_c=d-y_c;
    e1_c(i)=e_c*e_c'/2;
    w_c=w_c+eta_c*e_c*x;
    
    y_d=w_d*x';
    e_d=d-y_d;
    e1_d(i)=e_d*e_d'/2;
    w_d=w_d+eta_d*e_d*x; 
    
    t=t+1;
    i=i+1;
end

w_lms_a=w1_a(epoch);%LMS%
b_lms_a=w0_a(epoch);
x_num=0:epoch;
y1_a=w_lms_a.*x_num+b_lms_a;

w_lms_b=w1_b(epoch);%LMS%
b_lms_b=w0_b(epoch);
x_num=0:epoch;
y1_b=w_lms_b.*x_num+b_lms_b;

w_lms_c=w1_c(epoch);%LMS%
b_lms_c=w0_c(epoch);
x_num=0:epoch;
y1_c=w_lms_c.*x_num+b_lms_c;

w_lms_d=w1_d(epoch);%LMS%
b_lms_d=w0_d(epoch);
x_num=0:epoch;
y1_d=w_lms_d.*x_num+b_lms_d;

figure(1)
plot(x_num,y1_a,'color','r','LineWidth',1);
hold on;
plot(x_num,y1_b,'color','b','LineWidth',1);
hold on;
plot(x_num,y1_c,'color','y','LineWidth',1);
hold on;
plot(x_num,y1_d,'color','g','LineWidth',1);
hold on;
legend('0.008','0.01','0.03','0.05');
scatter([0.5,1.5,3,4.0,5.0],[8.0,6.0,5,2,0.5],'r','o');
axis([-1,12,-1,12]);
title('Linear Regression of LMS');
xlabel('x');
ylabel('y');

%Plot Trajectory of error
figure(5)
subplot(2,2,1);
x_epoch=1:epoch;
plot(x_epoch,e1_a,'color','b','LineWidth',1);
hold on;
title('Error function versus epochs with 0.008 learning rate');
xlabel('epoch');
ylabel('Average error');

subplot(2,2,2);
x_epoch=1:epoch;
plot(x_epoch,e1_b,'color','b','LineWidth',1);
hold on;
title('Error function versus epochs with 0.01 learning rate');
xlabel('epoch');
ylabel('Average error');

subplot(2,2,3);
x_epoch=1:epoch;
plot(x_epoch,e1_c,'color','b','LineWidth',1);
hold on;
title('Error function versus epochs with 0.03 learning rate');
xlabel('epoch');
ylabel('Average error');

subplot(2,2,4);
x_epoch=1:epoch;
plot(x_epoch,e1_d,'color','b','LineWidth',1);
hold on;
title('Error function versus epochs with 0.05 learning rate');
xlabel('epoch');
ylabel('Average error');
