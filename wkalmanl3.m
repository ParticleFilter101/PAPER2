
clc; close all; clear all;
A=xlsread('algo_2008');
d=A(:,2);
data=d(127286:143125);m=max(data);
y=d(127286:141685);
T=length(y);
data_original=d(141686:143125);
%% level 3 DWT
wname='haar';
level=3;
[cy,ly] = wavedec(y,level,wname);
[cd,ld]=wavedec(data,level,wname);

yapprox=cy(1:1800);
ydetail3=cy(1801:3600);
ydetail2=cy(3601:7200);
ydetail1=cy(7201:14400);

%% predict approx
[a,e] = aryule(yapprox,2);
F=[-a(2) -a(3);1 0];
H=[1 0];
x=[2.05; 2.05];
P=[0 0;0 e];
Q=[e 0;0 0];
R=e;
z=yapprox;
Aapprox=[];
for i=1:length(z)
    [xpred,Ppred]=predict(x,P,F,Q);
    [nu,S]=innovation(xpred,Ppred,z(i),H,R);
    [x,P]=innovation_update(xpred,Ppred,nu,S,H);
    Aapprox(:,i)=x;
end

A2approx=[];
for i=1:180
    A2approx(:,i)=(F^180)*Aapprox(:,(length(z)-180)+i);
end
A22approx=[Aapprox A2approx];
papprox=A22approx(1,:);

%% predict detail 3
[a,e] = aryule(ydetail3,2);
F=[-a(2) -a(3);1 0];
H=[1 0];
x=[2.05; 2.05];
P=[0 0;0 e];
Q=[e 0;0 0];
R=e;
z=ydetail3;
Adetail3=[];
for i=1:length(z)
    [xpred,Ppred]=predict(x,P,F,Q);
    [nu,S]=innovation(xpred,Ppred,z(i),H,R);
    [x,P]=innovation_update(xpred,Ppred,nu,S,H);
    Adetail3(:,i)=x;
end

A2detail3=[];
for i=1:180
    A2detail3(:,i)=(F^180)*Adetail3(:,(length(z)-180)+i);
end
A22detail3=[Adetail3 A2detail3];
pdetail3=A22detail3(1,:);

%% predict detail 2

[a,e] = aryule(ydetail2,2);
F=[-a(2) -a(3);1 0];
H=[1 0];
x=[2.05; 2.05];
P=[0 0;0 e];
Q=[e 0;0 0];
R=e;
z=ydetail2;
Adetail2=[];
for i=1:length(z)
    [xpred,Ppred]=predict(x,P,F,Q);
    [nu,S]=innovation(xpred,Ppred,z(i),H,R);
    [x,P]=innovation_update(xpred,Ppred,nu,S,H);
    Adetail2(:,i)=x;
end

A2detail2=[];
for i=1:360
    A2detail2(:,i)=(F^360)*Adetail2(:,(length(z)-360)+i);
end
A22detail2=[Adetail2 A2detail2];
pdetail2=A22detail2(1,:);
%% predict detail 1

[a,e] = aryule(ydetail1,2);
F=[-a(2) -a(3);1 0];
H=[1 0];
x=[2.05; 2.05];
P=[0 0;0 e];
Q=[e 0;0 0];
R=e;
z=ydetail1;
Adetail1=[];
for i=1:length(z)
    [xpred,Ppred]=predict(x,P,F,Q);
    [nu,S]=innovation(xpred,Ppred,z(i),H,R);
    [x,P]=innovation_update(xpred,Ppred,nu,S,H);
    Adetail1(:,i)=x;
end

A2detail1=[];
for i=1:720
    A2detail1(:,i)=(F^720)*Adetail1(:,(length(z)-720)+i);
end
A22detail1=[Adetail1 A2detail1];
pdetail1=A22detail1(1,:);
%% reconstruction
C=[papprox';pdetail3';pdetail2';pdetail1'];
L=[1980;1980;3960;7920;15840];
Xp=waverec(C,L,wname);

%%
plot(data,'k','Linewidth',2)
hold on
plot([T+1:T+1440],Xp(14401:15840),'r', 'Linewidth',2)
hold on
kalman=load('p_kalman_algo2008.mat');
kalman=kalman.predicted_kalman_algo2008;
plot([T+1:T+1440],kalman,'b', 'Linewidth',2)

%% rmse 
rmse=sqrt(mean((Xp(14401:15840)./m-data_original./m).^(2)))
[c,lag]=xcorr(Xp(14401:15840),data_original,0,'coeff')


%% Function

function [xpred,Ppred]=predict(x,P,F,Q)
    xpred=F*x;
    Ppred=F*P*F'+Q;
end
    
    function [nu,S]=innovation(xpred,Ppred,z,H,R)
        nu=z-H*xpred;
        S=R+H*Ppred*H';
    end
        
        function [xnew,Pnew]=innovation_update(xpred,Ppred,nu,S,H)
            K=Ppred*H'*inv(S);
            xnew=xpred+K*nu;
            Pnew=Ppred-K*S*K';
        end