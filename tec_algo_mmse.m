tic;
clc; close all; clear all;
A=xlsread('algo_2008');
d=A(:,2);
data=d(127286:143125);m=max(data);
y=d(127286:141685);
T=length(y);
data_original=d(141686:143125);
p=0:3;lp=length(p);
q=0:3;lq=length(q);
logl=zeros(lp,lq);
aic=zeros(lp,lq);
bic=zeros(lp,lq);
innovar=zeros(lp,lq);
for i=1:lp
    for j=1:lq
Mdl=arima(p(i),0,q(j));
[EstMdl,EstParamCov,logL,info] = estimate(Mdl,y);
logl(i,j)=logL;
[n,m1]=size(EstParamCov);
[aic(i,j), bic(i,j)]=aicbic(logl(i,j),n,T);
innovar(i,j)=EstParamCov(n,n)
    end
end
%% min AIC
[M1,I1] = min(aic(:));
[row_aic, col_aic] = ind2sub(size(aic),I1)
mdl=arima(row_aic-1,0,col_aic-1);
[estmdl,parmcov,loglik,infor]=estimate(mdl,y);
res_aic = infer(estmdl,y);
rng('default')
Ysim_aic = simulate(estmdl,1440,'NumPaths',50,'Y0',y,'E0',res_aic);
mn_aic = mean(Ysim_aic,2);
paic= mn_aic;
figure(1)
% plot(y,'k')
% hold on
% plot(T+1:T+1440,Ysim,'Color',[.85,.85,.85]);
plot(T+1:T+1440,data_original,'k--','Linewidth',2)
hold on
h = plot(T+1:T+1440,mn_aic,'r--','LineWidth',2);
hold on
xlim([T+1,T+1440])
rmserraic=sqrt(mean(((mn_aic./m)-(data_original./m)).^2))
[caic,lags] = xcorr(mn_aic,data_original,0,'coeff');
%% min BIC

[M2,I2] = min(bic(:));
[row_bic, col_bic] = ind2sub(size(bic),I2)
mdl1=arima(row_bic,0,col_bic-1);
[estmdl1,parmcov1,loglik1,infor1]=estimate(mdl1,y);
res_bic = infer(estmdl1,y);
rng('default')
Ysim_bic = simulate(estmdl1,1440,'NumPaths',50,'Y0',y,'E0',res_bic);
mn_bic = mean(Ysim_bic,2);
pbic= mn_bic;
figure(1)
% plot(y,'k')
% hold on
% plot(T+1:T+1440,Ysim,'Color',[.85,.85,.85]);
% plot(T+1:T+1440,data_original,'r--','Linewidth',2)
% hold on
plot(T+1:T+1440,mn_bic,'b--','LineWidth',2);
hold on
xlim([T+1,T+1440])
rmserrbic=sqrt(mean(((mn_bic./m)-(data_original./m)).^2))
[cbic,lags] = xcorr(mn_bic,data_original,0,'coeff');
%% min innovar

[M3,I3] = min(innovar(:));
[row_inno, col_inno] = ind2sub(size(innovar),I1)
mdl2=arima(row_inno-1,0,col_inno-1);
[estmdl2,parmcov2,loglik2,infor2]=estimate(mdl2,y);
res_inno = infer(estmdl2,y);
rng('default')
Ysim_inno = simulate(estmdl2,1440,'NumPaths',50,'Y0',y,'E0',res_inno);
mn_inno = mean(Ysim_inno,2);
pinno= mn_inno;
rmserrinno=sqrt(mean(((data_original./m)-(pinno./m)).^2));
[cinno,lags] = xcorr(pinno,data_original,0,'coeff');
plot(T+1:T+1440,pinno,'c--','LineWidth',2);



toc;