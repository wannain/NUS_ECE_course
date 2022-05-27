%init
clc;clf;clear;

x=[1,0.5;1,1.5;1,3;1,4.0;1,5.0];
d=[8.0;6.0;5;2;0.5];
%temp variables%
temp_1=x'*x;
temp_2=temp_1^-1;
temp_3=temp_2*x'*d;

w=temp_3(2);
b=temp_3(1);
%Plot Trajectory of weights
figure(1);
x=-10:10;
y=w.*x+b;
plot(x,y,'color','g','LineWidth',1.5);
hold on;
scatter([0.5,1.5,3,4.0,5.0],[8.0,6.0,5,2,0.5],'r','o');
axis([-1,12,-1,12]);
title('Linear Regression of LLS');
xlabel('x');
ylabel('y');
