%init
clc;clf;clear;

%para
eta=0.5;  %learning rate%
t=0;
i=1;
max_epoch=20;

%COMPLEMENT
x_com=[0,1];
d_com=[1,0];
w_com=rand(1,2);
x_com=[ones(1,2);x_com];
w0_com=zeros(1,max_epoch);
w1_com=zeros(1,max_epoch);

%learning procedure of complement
while (t<max_epoch)
    w0_com(i)=w_com(1); %COM%
    w1_com(i)=w_com(2); %COM%
    v_com=w_com*x_com;
    y_com=hardlim(v_com);
    e_com=d_com-y_com;
    w_com=w_com+eta*e_com*x_com'; 
 
    i=i+1;
    t=t+1;    
end

%Plot Trajectory of COMPLEMNET weights
subplot(1,2,1);
x_com=1:max_epoch;
plot(x_com,w0_com,'o-','color','g','LineWidth',1.5);
hold on;
plot(x_com,w1_com,'d-','color','b','LineWidth',1.5);
hold on;
legend('w0','W1');
axis([0,max_epoch,-3,3]);
title('Trajectory of weights for COMPLEMENT');
xlabel('t');
ylabel('w');

%Plot Result
subplot(1,2,2);
scatter([1],[0],'r','d');
hold on;
grid on;
scatter([0],[0],'b','y');
axis([-1,2,-1,2]);
x_com=-w0_com(max_epoch)/w1_com(max_epoch);
x_com=[x_com,x_com,x_com];
y_com=[-10,0.01,10];
plot(x_com,y_com,'LineWidth',3);
title('Decision Boundary of COMPLEMENT');