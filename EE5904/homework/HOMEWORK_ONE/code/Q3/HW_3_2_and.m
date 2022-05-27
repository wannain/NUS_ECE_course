%init
clc;clf;clear;

%para
eta=0.5;  %learning rate%
t=0;
i=1;
max_epoch=20;

%AND
x_and=[0,0,1,1;0,1,0,1];
d_and=[0,0,0,1];
w_and=rand(1,3);
x_and=[ones(1,4);x_and];
w0_and=zeros(1,max_epoch);
w1_and=zeros(1,max_epoch);
w2_and=zeros(1,max_epoch);

%learning procedure of AND
while (t<max_epoch)
    w0_and(i)=w_and(1); %AND%
    w1_and(i)=w_and(2); %AND%
    w2_and(i)=w_and(3); %AND%

    v_and=w_and*x_and;
    y_and=hardlim(v_and);
    e_and=d_and-y_and;
    w_and=w_and+eta*e_and*x_and'; 
    i=i+1;
    t=t+1;    
end

%Plot Trajectory of AND weights
subplot(1,2,1);
x_and_series=1:max_epoch;
plot(x_and_series,w0_and,'o-','color','g','LineWidth',1.5);
hold on;
plot(x_and_series,w1_and,'d-','color','b','LineWidth',1.5);
hold on;
plot(x_and_series,w2_and,'p-','color','m','LineWidth',1.5);
hold on;
legend('w0','W1','W2');
axis([0,max_epoch,-3,3]);
title('Trajectory of weights for AND');
xlabel('t');
ylabel('w');
box on;

%Plot Result
subplot(1,2,2);
scatter([1],[1],'r','d');
hold on;
grid on;
scatter([0,1,0],[0,0,1],'b','y');
axis([-1,2,-1,2]);
x_and_test=-5:0.01:5;
y_and=x_and_test*(-w_and(2)/w_and(3))-w_and(1)/w_and(3);
plot(x_and_test,y_and,'LineWidth',3);
title('Decision Boundary of AND');