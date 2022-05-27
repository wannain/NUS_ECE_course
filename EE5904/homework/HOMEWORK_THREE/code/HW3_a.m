%init
close all;clear;clc;
mkdir q3_a_image

x=linspace(-pi,pi,400);
trainX=[x;2*sin(x)];%2x400 matrix 

%parameter
w=rand(36,2); %randomly init weigth 36 neurons in output layer
sigma0=sqrt(1^2+36^2)/2;%M=1,N=36
eta0=0.1;

for T=[1:10,20:20:100,200:200:1000,2000:1000:10000]
%T=100;%iterations
    tau1=T/log(sigma0);
    tau2=T;
    eta=eta0;
sigma=sigma0;

%algorithm
    for n=1:T
        i=randperm(size(trainX,2),1);%randomly select vector x
        %competitive process
        [min_dist,Idx]=min(dist(trainX(:,i)',w'));% 1*2 * 2*36 =1*36
        %adaptation process
        for j=1:36
            h=exp((j-Idx).^2/-(2*sigma.^2));
            w(j,:)=w(j,:)+eta*h*(trainX(:,i)'-w(j,:));
        end 
        %update eta&sigma
        eta=eta0*exp(-n/tau2);
        sigma=sigma0*exp(-n/tau1);
    end
    figure(1)
    plot(trainX(1,:),trainX(2,:),'--','LineWidth',1.5);hold on;
    plot(w(:,1),w(:,2),'LineWidth',1); hold on;
    scatter(w(:,1),w(:,2),'o');hold on;
    title(['The topological adjacent neurons , T=',num2str(T)]);
    legend('ideal output','SOM output','neurons');
    saveas(gcf,strcat("q3_a_image/a_",num2str(T),".jpg"));
end