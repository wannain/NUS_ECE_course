%para
eta=0.5;%learning rate 
i=1;%iteration number

x_value=zeros(1,1000);%init vector
y_value=zeros(1,1000);
f_value=zeros(1,1000);
iter_value=zeros(1,1000);

x=rand;%random x,y
x=double(x);
y=rand;
y=double(y);
f=(1-x).^2+100.*(y-x.^2).^2;

while f>0.00000001
    x_value(i)=x;%recording trajectory
    y_value(i)=y;
    f_value(i)=f;
    iter_value(i)=i;
    
    dx=400*x^3-400*x*y+2*x-2;%derivation 
    dy=200*y-200*x^2;
    
    x=x-eta*dx;%update
    y=y-eta*dy;
    f=(1-x).^2+100.*(y-x.^2).^2;
    
    i=i+1;   
end

%plot out (x,y) trajectory 
figure(1);
scatter(x_value,y_value,'.');
hold on;
title('The trajectory of (x,y)');
xlabel('x');
ylabel('y');
%plot out function f value
figure(2);
scatter(iter_value,f_value,'.');
hold on;
title('The function f(x,y) value versus iteration');
xlabel('iteration');
ylabel('f(x,y)');
x=double(x);
y=double(y);