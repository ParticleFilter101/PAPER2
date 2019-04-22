clc;clear all; close all;
% [A1,dilimiterout2]=importdata('algo2008_tec_interp_by_sample.txt');
%  tec1=A1.data(:,2);
A=xlsread('algo_2008');
tec1=A(:,2);
tsig1=tec1(127286:141685);tsig1_max=max(tsig1);
tsig1=tsig1/(tsig1_max);
figure(1)
plot(tsig1)
[a,e] = aryule(tsig1,2);
%%  %%%kalman filter eq.
F=[-a(2) -a(3);1 0];
H=[1 0];
x=[2.05; 2.05];
P=[0 0;0 e];
Q=[e 0;0 0];
R=e;
z=tsig1;
A=[];
for i=1:length(z)
    [xpred,Ppred]=predict(x,P,F,Q);
    [nu,S]=innovation(xpred,Ppred,z(i),H,R);
    [x,P]=innovation_update(xpred,Ppred,nu,S,H);
    A(:,i)=x;
end

t=linspace(1,11,15840);
s1=tec1(127286:143125)/max(tec1(127286:143125));
%%
A2=[];
for i=1:1440
    A2(:,i)=(F^1440)*A(:,(14400-1440)+i);
end
A22=[A A2];
figure(3)
plot(t,s1*max(tec1(127286:143125)),t,A22(1,:)*max(tec1(127286:143125)))
p_sqerr=(A2(1,:)-(tec1(141686:143125))'/max(tec1(141686:143125))).^2;
rms_err=sqrt(mean(p_sqerr))
[c,lags] = xcorr(A2(1,:),(tec1(196141:197580))',0,'coeff')

original_kalman_algo2008=(s1(14401:15840))*max(tec1(127286:143125));
predicted_kalman_algo2008=(A22(1,14401:15840))'*max(tec1(127286:143125));



%%

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
            
            

