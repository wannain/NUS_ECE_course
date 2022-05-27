%init
clc;clf;clear;

%para
eta=1.0;  %learning rate%
t=0;
i=1;
max_epoch=20;

%XOR
x_xor=[0,1,0,1;0,0,1,1];
d_xor=[0,1,1,0];
w_xor=rand(1,3);
x_xor=[ones(1,4);x_xor];
w0_xor=zeros(1,max_epoch);
w1_xor=zeros(1,max_epoch);
w2_xor=zeros(1,max_epoch);

%learning procedure of XOR
while (t<max_epoch)
    w0_xor(i)=w_xor(1); %XOR%
    w1_xor(i)=w_xor(2); %XOR%
    w2_xor(i)=w_xor(3); %XOR%
    v_xor=w_xor*x_xor;
    y_xor=hardlim(v_xor);
    e_xor=d_xor-y_xor;
    w_xor=w_xor+eta*e_xor*x_xor'; 
 
    i=i+1;
    t=t+1;    
end

%Plot Trajectory of OR weights
subplot(1,2,1);
x_xor=1:max_epoch;
plot(x_xor,w0_xor,'o-','color','g','LineWidth',1.5);
hold on;
plot(x_xor,w1_xor,'d-','color','b','LineWidth',1.5);
hold on;
plot(x_xor,w2_xor,'p-','color','m','LineWidth',1.5);
hold on;
legend('w0','W1','W2');
axis([0,max_epoch,-3,3]);
title('Trajectory of weights for OR');
xlabel('t');
ylabel('w');

%Plot Result
subplot(1,2,2);
scatter([0],[0],'b','y');
hold on;
grid on;
scatter([1,0,1],[1,1,0],'r','d');
axis([-1,2,-1,2]);
x_xor=-5:0.01:5;
y_xor=x_xor*(-w_xor(2)/w_xor(3))-w_xor(1)/w_xor(3);
plot(x_xor,y_xor,'LineWidth',3);
title('Decision Boundary of XOR');