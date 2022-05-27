%init
close all;clear;clc;

%para
i=1;%iteration number

x_value=zeros(1,1000);%init vector
y_value=zeros(1,1000);
f_value=zeros(1,1000);
iter_value=zeros(1,1000);

x=rand;%random x,y
x=double(x);
y=rand;
y=double(y);

dx=400*x^3-400*x*y+2*x-2;%derivation
dy=200*y-200*x^2;
dxx=1200.*x.^2-400.*y+2;
dyy=200;
dxy=-400.*x;
f=(1-x).^2+100.*(y-x.^2).^2;
H=[dxx,dxy;dxy,dyy];

while f>0.00000001
    x_value(i)=x;%recording trajectory
    y_value(i)=y;
    f_value(i)=f;
    iter_value(i)=i;
    
    dx=400*x^3-400*x*y+2*x-2;%derivation
    dy=200*y-200*x^2;
    dxx=1200.*x.^2-400.*y+2;
    dyy=200;
    dxy=-400.*x;
    H=[dxx,dxy;dxy,dyy];
    h=inv(H);
    
    x=x-h(1,1).*dx-h(1,2).*dy;%update
    y=y-h(2,1).*dx-h(2,2).*dy;
    f=(1-x).^2+100.*(y-x.^2).^2;
    i=i+1;
end

%plot out (x,y) trajectory 
figure(1);
x_value=x_value(1:i-1);
y_value=y_value(1:i-1);
plot(x_value,y_value,'o-');
hold on;
title('The trajectory of (x,y)');
xlabel('x');
ylabel('y');
%plot out function f value
figure(2);
iter_value=iter_value(1:i-1);
f_value=f_value(1:i-1);
plot(iter_value,f_value,'o-');
hold on;
title('The function f(x,y) value versus iteration');
xlabel('iteration');
ylabel('f(x,y)');