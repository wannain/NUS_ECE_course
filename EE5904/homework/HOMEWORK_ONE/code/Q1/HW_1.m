%ini
clc;clf;clear;

%logistic function
figure(1);
x=-3:0.01:3;
y=(x-1).*(x-1)+5;
plot(x,y);
xlabel('v');ylabel('φ(v)');
title('1. Quadratic function');

%hyperbolic tangent function
figure(2);
x=-10:0.01:10;
a=1+abs(x);
y=x./a;
plot(x,y);
axis([-10,10,-1.5,1.5]);
xlabel('v');ylabel('φ(v)');
title('2.hyperbolic tangent function');

%gaussian function
figure(3);
x=-10:0.01:10;
a=-0.5.*x.*x;
y=exp(a);
plot(x,y);
axis([-10,10,-0.5,1.5]);
xlabel('v');ylabel('φ(v)');
title('3.gaussian function');