%init
clc;clf;clear;

%para
eta=0.5;  %learning rate%
t=0;
i=1;
max_epoch=20;

%OR
x_or=[0,0,1,1;0,1,0,1];
d_or=[0,1,1,1];
w_or=rand(1,3);
x_or=[ones(1,4);x_or];
w0_or=zeros(1,max_epoch);
w1_or=zeros(1,max_epoch);
w2_or=zeros(1,max_epoch);

%learning procedure of OR
while (t<max_epoch)
    w0_or(i)=w_or(1); %OR%
    w1_or(i)=w_or(2); %OR%
    w2_or(i)=w_or(3); %OR%
    v_or=w_or*x_or;
    y_or=hardlim(v_or);
    e_or=d_or-y_or;
    w_or=w_or+eta*e_or*x_or'; 
 
    i=i+1;
    t=t+1;    
end

%Plot Trajectory of OR weights
subplot(1,2,1);
x_or=1:max_epoch;
plot(x_or,w0_or,'o-','color','g','LineWidth',1.5);
hold on;
plot(x_or,w1_or,'d-','color','b','LineWidth',1.5);
hold on;
plot(x_or,w2_or,'p-','color','m','LineWidth',1.5);
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
x_or=-5:0.01:5;
y_or=x_or*(-w_or(2)/w_or(3))-w_or(1)/w_or(3);
plot(x_or,y_or,'LineWidth',3);
title('Decision Boundary of OR');