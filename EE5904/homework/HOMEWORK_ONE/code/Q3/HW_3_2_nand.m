%init
clc;clf;clear;

%para
eta=0.5;  %learning rate%
t=0;
i=1;
max_epoch=20;
%NAND
x_nand=[0,0,1,1;0,1,0,1];
d_nand=[1,1,1,0];
w_nand=rand(1,3);
x_nand=[ones(1,4);x_nand];
w0_nand=zeros(1,max_epoch);
w1_nand=zeros(1,max_epoch);
w2_nand=zeros(1,max_epoch);

%learning procedure of nand
while (t<max_epoch)    
    w0_nand(i)=w_nand(1); %NAND%
    w1_nand(i)=w_nand(2); %NAND%
    w2_nand(i)=w_nand(3); %NAND%
    v_nand=w_nand*x_nand;
    y_nand=hardlim(v_nand);
    e_nand=d_nand-y_nand;
    w_nand=w_nand+eta*e_nand*x_nand'; 
 
    i=i+1;
    t=t+1;    
end

%Plot Trajectory of NAND weights
subplot(1,2,1);
x_nand=1:max_epoch;
plot(x_nand,w0_nand,'o-','color','g','LineWidth',1.5);
hold on;
plot(x_nand,w1_nand,'d-','color','b','LineWidth',1.5);
hold on;
plot(x_nand,w2_nand,'p-','color','m','LineWidth',1.5);
hold on;
legend('w0','W1','W2');
axis([0,max_epoch,-3,3]);
title('Trajectory of weights for NAND');
xlabel('t');
ylabel('w');

%Plot Result
subplot(1,2,2);
scatter([0,1,0],[0,0,1],'r','d');
hold on;
grid on;
scatter([1],[1],'b','y');
axis([-1,2,-1,2]);
x_nand=-5:0.01:5;
y_nand=x_nand*(-w_nand(2)/w_nand(3))-w_nand(1)/w_nand(3);
plot(x_nand,y_nand,'LineWidth',3);
title('Decision Boundary of NAND');