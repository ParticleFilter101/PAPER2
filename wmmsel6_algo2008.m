clc; close all; clear all;
A=xlsread('algo_2008');
d=A(:,2);
data=d(127286:143125);m=max(data);
y=d(127286:141685);
T=length(y);
data_original=d(141686:143125);
%% level 6 DWT
wname='haar';
level=6;
[cy,ly] = wavedec(y,level,wname);
[cd,ld]=wavedec(data,level,wname);
yapprox=cy(1:225);
ydetail6=cy(226:450);
ydetail5=cy(451:900);
ydetail4=cy(901:1800);
ydetail3=cy(1800:3600);
ydetail2=cy(3601:7200);
ydetail1=cy(7201:14400);

%% predict approx
p=0:3;lp=length(p);
q=0:3;lq=length(q);
loglapprox=zeros(lp,lq);
aicapprox=zeros(lp,lq);
bicapprox=zeros(lp,lq);
innovarapprox=zeros(lp,lq);
for i=1:lp
    for j=1:lq
        Mdl=arima(p(i),0,q(j));
        [EstMdl,EstParamCov,logL,info] = estimate(Mdl,yapprox);
        loglapprox(i,j)=logL;
        [n,m1]=size(EstParamCov);
        [aicapprox(i,j), bicapprox(i,j)]=aicbic(loglapprox(i,j),n,T);
        innovarapprox(i,j)=EstParamCov(n,n);
    end
end
[M1approx,I1approx] = min(aicapprox(:));
[row_aicapprox, col_aicapprox] = ind2sub(size(aicapprox),I1approx);
mdlaicapprox=arima(row_aicapprox-1,0,col_aicapprox-1)
[estmdlapproxaic,parmcovapproxaic,loglikapproxaic,inforapproxaic]=estimate(mdlaicapprox,yapprox);
res_aicapprox = infer(estmdlapproxaic,yapprox);
rng('default')
Ysim_aicapprox = simulate(estmdlapproxaic,23,'NumPaths',50,'Y0',yapprox,'E0',res_aicapprox);
mn_aicapprox = mean(Ysim_aicapprox,2);
pcdapproxaic=[yapprox;mn_aicapprox];

[M11approx,I11approx] = min(bicapprox(:));
[row_bicapprox, col_bicapprox] = ind2sub(size(bicapprox),I11approx);
mdlbicapprox=arima(row_bicapprox-1,0,col_bicapprox-1)
[estmdlapproxbic,parmcovapproxbic,loglikapproxbic,inforapproxbic]=estimate(mdlbicapprox,yapprox);
res_bicapprox = infer(estmdlapproxbic,yapprox);
rng('default')
Ysim_bicapprox = simulate(estmdlapproxbic,23,'NumPaths',50,'Y0',yapprox,'E0',res_bicapprox);
mn_bicapprox = mean(Ysim_bicapprox,2);
pcdapproxbic=[yapprox;mn_bicapprox];


[M111approx,I111approx] = min(innovarapprox(:));
[row_innovarapprox, col_innovarapprox] = ind2sub(size(innovarapprox),I111approx);
mdlinnovarapprox=arima(row_innovarapprox-1,0,col_innovarapprox-1)
[estmdlapproxinnovar,parmcovapproxinnovar,loglikapproxinnovar,inforapproxinnovar]=estimate(mdlinnovarapprox,yapprox);
res_innovarapprox = infer(estmdlapproxinnovar,yapprox);
rng('default')
Ysim_innovarapprox = simulate(estmdlapproxinnovar,23,'NumPaths',50,'Y0',yapprox,'E0',res_innovarapprox);
mn_innovarapprox = mean(Ysim_innovarapprox,2);
pcdapproxinnovar=[yapprox;mn_innovarapprox];

%% predict detail 6
p=0:3;lp=length(p);
q=0:3;lq=length(q);
logldetail6=zeros(lp,lq);
aicdetail6=zeros(lp,lq);
bicdetail6=zeros(lp,lq);
innovardetail6=zeros(lp,lq);
for i=1:lp
    for j=1:lq
        Mdl=arima(p(i),0,q(j));
        [EstMdl,EstParamCov,logL,info] = estimate(Mdl,ydetail6);
        logldetail6(i,j)=logL;
        [n,m1]=size(EstParamCov);
        [aicdetail6(i,j), bicdetail6(i,j)]=aicbic(logldetail6(i,j),n,T);
        innovardetail6(i,j)=EstParamCov(n,n);
    end
end
[M1detail6,I1detail6] = min(aicdetail6(:));
[row_aicdetail6, col_aicdetail6] = ind2sub(size(aicdetail6),I1detail6);
mdlaicdetail6=arima(row_aicdetail6-1,0,col_aicdetail6-1)
[estmdldetail6aic,parmcovdetail6aic,loglikdetail6aic,infordetail6aic]=estimate(mdlaicdetail6,ydetail6);
res_aicdetail6 = infer(estmdldetail6aic,ydetail6);
rng('default')
Ysim_aicdetail6 = simulate(estmdldetail6aic,23,'NumPaths',50,'Y0',ydetail6,'E0',res_aicdetail6);
mn_aicdetail6 = mean(Ysim_aicdetail6,2);
pcddetail6aic=[ydetail6;mn_aicdetail6];


[M11detail6,I11detail6] = min(bicdetail6(:));
[row_bicdetail6, col_bicdetail6] = ind2sub(size(bicdetail6),I11detail6);
mdlbicdetail6=arima(row_bicdetail6-1,0,col_bicdetail6-1)
[estmdldetail6bic,parmcovdetail6bic,loglikdetail6bic,infordetail6bic]=estimate(mdlbicdetail6,ydetail6);
res_bicdetail6 = infer(estmdldetail6bic,ydetail6);
rng('default')
Ysim_bicdetail6 = simulate(estmdldetail6bic,23,'NumPaths',50,'Y0',ydetail6,'E0',res_bicdetail6);
mn_bicdetail6 = mean(Ysim_bicdetail6,2);
pcddetail6bic=[ydetail6;mn_bicdetail6];

[M111detail6,I111detail6] = min(innovardetail6(:));
[row_innovardetail6, col_innovardetail6] = ind2sub(size(innovardetail6),I111detail6);
mdlinnovardetail6=arima(row_innovardetail6-1,0,col_innovardetail6-1)
[estmdldetail6innovar,parmcovdetail6innovar,loglikdetail6innovar,infordetail6innovar]=estimate(mdlinnovardetail6,ydetail6);
res_innovardetail6 = infer(estmdldetail6innovar,ydetail6);
rng('default')
Ysim_innovardetail6 = simulate(estmdldetail6innovar,23,'NumPaths',50,'Y0',ydetail6,'E0',res_innovardetail6);
mn_innovardetail6 = mean(Ysim_innovardetail6,2);
pcddetail6innovar=[ydetail6;mn_innovardetail6];

%% predict detail 5
p=0:3;lp=length(p);
q=0:3;lq=length(q);
logldetail5=zeros(lp,lq);
aicdetail5=zeros(lp,lq);
bicdetail5=zeros(lp,lq);
innovardetail5=zeros(lp,lq);
for i=1:lp
    for j=1:lq
        Mdl=arima(p(i),0,q(j));
        [EstMdl,EstParamCov,logL,info] = estimate(Mdl,ydetail5);
        logldetail5(i,j)=logL;
        [n,m1]=size(EstParamCov);
        [aicdetail5(i,j), bicdetail5(i,j)]=aicbic(logldetail5(i,j),n,T);
        innovardetail5(i,j)=EstParamCov(n,n);
    end
end
[M1detail5,I1detail5] = min(aicdetail5(:));
[row_aicdetail5, col_aicdetail5] = ind2sub(size(aicdetail5),I1detail5);
mdlaicdetail5=arima(row_aicdetail5-1,0,col_aicdetail5-1)
[estmdldetail5aic,parmcovdetail5aic,loglikdetail5aic,infordetail5aic]=estimate(mdlaicdetail5,ydetail5);
res_aicdetail5 = infer(estmdldetail5aic,ydetail5);
rng('default')
Ysim_aicdetail5 = simulate(estmdldetail5aic,45,'NumPaths',50,'Y0',ydetail5,'E0',res_aicdetail5);
mn_aicdetail5 = mean(Ysim_aicdetail5,2);
pcddetail5aic=[ydetail5;mn_aicdetail5];


[M11detail5,I11detail5] = min(bicdetail5(:));
[row_bicdetail5, col_bicdetail5] = ind2sub(size(bicdetail5),I11detail5);
mdlbicdetail5=arima(row_bicdetail5-1,0,col_bicdetail5-1)
[estmdldetail5bic,parmcovdetail5bic,loglikdetail5bic,infordetail5bic]=estimate(mdlbicdetail5,ydetail5);
res_bicdetail5 = infer(estmdldetail5bic,ydetail5);
rng('default')
Ysim_bicdetail5 = simulate(estmdldetail5bic,45,'NumPaths',50,'Y0',ydetail5,'E0',res_bicdetail5);
mn_bicdetail5 = mean(Ysim_bicdetail5,2);
pcddetail5bic=[ydetail5;mn_bicdetail5];

[M111detail5,I111detail5] = min(innovardetail5(:));
[row_innovardetail5, col_innovardetail5] = ind2sub(size(innovardetail5),I111detail5);
mdlinnovardetail5=arima(row_innovardetail5-1,0,col_innovardetail5-1)
[estmdldetail5innovar,parmcovdetail5innovar,loglikdetail5innovar,infordetail5innovar]=estimate(mdlinnovardetail5,ydetail5);
res_innovardetail5 = infer(estmdldetail5innovar,ydetail5);
rng('default')
Ysim_innovardetail5 = simulate(estmdldetail5innovar,45,'NumPaths',50,'Y0',ydetail5,'E0',res_innovardetail5);
mn_innovardetail5 = mean(Ysim_innovardetail5,2);
pcddetail5innovar=[ydetail5;mn_innovardetail5];

%% predict detail 4
p=0:3;lp=length(p);
q=0:3;lq=length(q);
logldetail4=zeros(lp,lq);
aicdetail4=zeros(lp,lq);
bicdetail4=zeros(lp,lq);
innovardetail4=zeros(lp,lq);
for i=1:lp
    for j=1:lq
        Mdl=arima(p(i),0,q(j));
        [EstMdl,EstParamCov,logL,info] = estimate(Mdl,ydetail4);
        logldetail4(i,j)=logL;
        [n,m1]=size(EstParamCov);
        [aicdetail4(i,j), bicdetail4(i,j)]=aicbic(logldetail4(i,j),n,T);
        innovardetail4(i,j)=EstParamCov(n,n);
    end
end
[M1detail4,I1detail4] = min(aicdetail4(:));
[row_aicdetail4, col_aicdetail4] = ind2sub(size(aicdetail4),I1detail4);
mdlaicdetail4=arima(row_aicdetail4-1,0,col_aicdetail4-1)
[estmdldetail4aic,parmcovdetail4aic,loglikdetail4aic,infordetail4aic]=estimate(mdlaicdetail4,ydetail4);
res_aicdetail4 = infer(estmdldetail4aic,ydetail4);
rng('default')
Ysim_aicdetail4 = simulate(estmdldetail4aic,90,'NumPaths',50,'Y0',ydetail4,'E0',res_aicdetail4);
mn_aicdetail4 = mean(Ysim_aicdetail4,2);
pcddetail4aic=[ydetail4;mn_aicdetail4];


[M11detail4,I11detail4] = min(bicdetail4(:));
[row_bicdetail4, col_bicdetail4] = ind2sub(size(bicdetail4),I11detail4);
mdlbicdetail4=arima(row_bicdetail4-1,0,col_bicdetail4-1)
[estmdldetail4bic,parmcovdetail4bic,loglikdetail4bic,infordetail4bic]=estimate(mdlbicdetail4,ydetail4);
res_bicdetail4 = infer(estmdldetail4bic,ydetail4);
rng('default')
Ysim_bicdetail4 = simulate(estmdldetail4bic,90,'NumPaths',50,'Y0',ydetail4,'E0',res_bicdetail4);
mn_bicdetail4 = mean(Ysim_bicdetail4,2);
pcddetail4bic=[ydetail4;mn_bicdetail4];

[M111detail4,I111detail4] = min(innovardetail4(:));
[row_innovardetail4, col_innovardetail4] = ind2sub(size(innovardetail4),I111detail4);
mdlinnovardetail4=arima(row_innovardetail4-1,0,col_innovardetail4-1)
[estmdldetail4innovar,parmcovdetail4innovar,loglikdetail4innovar,infordetail4innovar]=estimate(mdlinnovardetail4,ydetail4);
res_innovardetail4 = infer(estmdldetail4innovar,ydetail4);
rng('default')
Ysim_innovardetail4 = simulate(estmdldetail4innovar,90,'NumPaths',50,'Y0',ydetail4,'E0',res_innovardetail4);
mn_innovardetail4 = mean(Ysim_innovardetail4,2);
pcddetail4innovar=[ydetail4;mn_innovardetail4];

%% predict detail 3

p=0:3;lp=length(p);
q=0:3;lq=length(q);
logldetail3=zeros(lp,lq);
aicdetail3=zeros(lp,lq);
bicdetail3=zeros(lp,lq);
innovardetail3=zeros(lp,lq);
for i=1:lp
    for j=1:lq
        Mdl=arima(p(i),0,q(j));
        [EstMdl,EstParamCov,logL,info] = estimate(Mdl,ydetail3);
        logldetail3(i,j)=logL;
        [n,m1]=size(EstParamCov);
        [aicdetail3(i,j), bicdetail3(i,j)]=aicbic(logldetail3(i,j),n,T);
        innovardetail3(i,j)=EstParamCov(n,n);
    end
end
[M1detail3,I1detail3] = min(aicdetail3(:));
[row_aicdetail3, col_aicdetail3] = ind2sub(size(aicdetail3),I1detail3);
mdlaicdetail3=arima(row_aicdetail3-1,0,col_aicdetail3-1)
[estmdldetail3aic,parmcovdetail3aic,loglikdetail3aic,infordetail3aic]=estimate(mdlaicdetail3,ydetail3);
res_aicdetail3 = infer(estmdldetail3aic,ydetail3);
rng('default')
Ysim_aicdetail3 = simulate(estmdldetail3aic,180,'NumPaths',50,'Y0',ydetail3,'E0',res_aicdetail3);
mn_aicdetail3 = mean(Ysim_aicdetail3,2);
pcddetail3aic=[ydetail3;mn_aicdetail3];


[M11detail3,I11detail3] = min(bicdetail3(:));
[row_bicdetail3, col_bicdetail3] = ind2sub(size(bicdetail3),I11detail3);
mdlbicdetail3=arima(row_bicdetail3-1,0,col_bicdetail3-1)
[estmdldetail3bic,parmcovdetail3bic,loglikdetail3bic,infordetail3bic]=estimate(mdlbicdetail3,ydetail3);
res_bicdetail3 = infer(estmdldetail3bic,ydetail3);
rng('default')
Ysim_bicdetail3 = simulate(estmdldetail3bic,180,'NumPaths',50,'Y0',ydetail3,'E0',res_bicdetail3);
mn_bicdetail3 = mean(Ysim_bicdetail3,2);
pcddetail3bic=[ydetail3;mn_bicdetail3];

[M111detail3,I111detail3] = min(innovardetail3(:));
[row_innovardetail3, col_innovardetail3] = ind2sub(size(innovardetail3),I111detail3);
mdlinnovardetail3=arima(row_innovardetail3-1,0,col_innovardetail3-1)
[estmdldetail3innovar,parmcovdetail3innovar,loglikdetail3innovar,infordetail3innovar]=estimate(mdlinnovardetail3,ydetail3);
res_innovardetail3 = infer(estmdldetail3innovar,ydetail3);
rng('default')
Ysim_innovardetail3 = simulate(estmdldetail3innovar,180,'NumPaths',50,'Y0',ydetail3,'E0',res_innovardetail3);
mn_innovardetail3 = mean(Ysim_innovardetail3,2);
pcddetail3innovar=[ydetail3;mn_innovardetail3];

%% predict detail 2
p=0:3;lp=length(p);
q=0:3;lq=length(q);
logldetail2=zeros(lp,lq);
aicdetail2=zeros(lp,lq);
bicdetail2=zeros(lp,lq);
innovardetail2=zeros(lp,lq);
for i=1:lp
    for j=1:lq
        Mdl=arima(p(i),0,q(j));
        [EstMdl,EstParamCov,logL,info] = estimate(Mdl,ydetail2);
        logldetail2(i,j)=logL;
        [n,m1]=size(EstParamCov);
        [aicdetail2(i,j), bicdetail2(i,j)]=aicbic(logldetail2(i,j),n,T);
        innovardetail2(i,j)=EstParamCov(n,n);
    end
end
[M1detail2,I1detail2] = min(aicdetail2(:));
[row_aicdetail2, col_aicdetail2] = ind2sub(size(aicdetail2),I1detail2);
mdlaicdetail2=arima(row_aicdetail2-1,0,col_aicdetail2-1)
[estmdldetail2aic,parmcovdetail2aic,loglikdetail2aic,infordetail2aic]=estimate(mdlaicdetail2,ydetail2);
res_aicdetail2 = infer(estmdldetail2aic,ydetail2);
rng('default')
Ysim_aicdetail2 = simulate(estmdldetail2aic,360,'NumPaths',50,'Y0',ydetail2,'E0',res_aicdetail2);
mn_aicdetail2 = mean(Ysim_aicdetail2,2);
pcddetail2aic=[ydetail2;mn_aicdetail2];


[M11detail2,I11detail2] = min(bicdetail2(:));
[row_bicdetail2, col_bicdetail2] = ind2sub(size(bicdetail2),I11detail2);
mdlbicdetail2=arima(row_bicdetail2-1,0,col_bicdetail2-1)
[estmdldetail2bic,parmcovdetail2bic,loglikdetail2bic,infordetail2bic]=estimate(mdlbicdetail2,ydetail2);
res_bicdetail2 = infer(estmdldetail2bic,ydetail2);
rng('default')
Ysim_bicdetail2 = simulate(estmdldetail2bic,360,'NumPaths',50,'Y0',ydetail2,'E0',res_bicdetail2);
mn_bicdetail2 = mean(Ysim_bicdetail2,2);
pcddetail2bic=[ydetail2;mn_bicdetail2];

[M111detail2,I111detail2] = min(innovardetail2(:));
[row_innovardetail2, col_innovardetail2] = ind2sub(size(innovardetail2),I111detail2);
mdlinnovardetail2=arima(row_innovardetail2-1,0,col_innovardetail2-1)
[estmdldetail2innovar,parmcovdetail2innovar,loglikdetail2innovar,infordetail2innovar]=estimate(mdlinnovardetail2,ydetail2);
res_innovardetail2 = infer(estmdldetail2innovar,ydetail2);
rng('default')
Ysim_innovardetail2 = simulate(estmdldetail2innovar,360,'NumPaths',50,'Y0',ydetail2,'E0',res_innovardetail2);
mn_innovardetail2 = mean(Ysim_innovardetail2,2);
pcddetail2innovar=[ydetail2;mn_innovardetail2];

%% predict detail 1

p=0:3;lp=length(p);
q=0:3;lq=length(q);
logldetail=zeros(lp,lq);
aicdetail1=zeros(lp,lq);
bicdetail1=zeros(lp,lq);
innovardetail1=zeros(lp,lq);
for i=1:lp
    for j=1:lq
        Mdl=arima(p(i),0,q(j));
        [EstMdl,EstParamCov,logL,info] = estimate(Mdl,ydetail1);
        logldetail1(i,j)=logL;
        [n,m1]=size(EstParamCov);
        [aicdetail1(i,j), bicdetail1(i,j)]=aicbic(logldetail1(i,j),n,T);
        innovardetail1(i,j)=EstParamCov(n,n);
    end
end
[M1detail1,I1detail1] = min(aicdetail1(:));
[row_aicdetail1, col_aicdetail1] = ind2sub(size(aicdetail1),I1detail1);
mdlaicdetail1=arima(row_aicdetail1-1,0,col_aicdetail1-1)
[estmdldetail1aic,parmcovdetail1aic,loglikdetail1aic,infordetail1aic]=estimate(mdlaicdetail1,ydetail1);
res_aicdetail1 = infer(estmdldetail1aic,ydetail1);
rng('default')
Ysim_aicdetail1 = simulate(estmdldetail1aic,720,'NumPaths',50,'Y0',ydetail1,'E0',res_aicdetail1);
mn_aicdetail1 = mean(Ysim_aicdetail1,2);
pcddetail1aic=[ydetail1;mn_aicdetail1];


[M11detail1,I11detail1] = min(bicdetail1(:));
[row_bicdetail1, col_bicdetail1] = ind2sub(size(bicdetail1),I11detail1);
mdlbicdetail1=arima(row_bicdetail1-1,0,col_bicdetail1-1)
[estmdldetail1bic,parmcovdetail1bic,loglikdetail1bic,infordetail1bic]=estimate(mdlbicdetail1,ydetail1);
res_bicdetail1 = infer(estmdldetail1bic,ydetail1);
rng('default')
Ysim_bicdetail1 = simulate(estmdldetail1bic,720,'NumPaths',50,'Y0',ydetail1,'E0',res_bicdetail1);
mn_bicdetail1 = mean(Ysim_bicdetail1,2);
pcddetail1bic=[ydetail1;mn_bicdetail1];

[M111detail1,I111detail1] = min(innovardetail1(:));
[row_innovardetail1, col_innovardetail1] = ind2sub(size(innovardetail1),I111detail1);
mdlinnovardetail1=arima(row_innovardetail1-1,0,col_innovardetail1-1)
[estmdldetail1innovar,parmcovdetail1innovar,loglikdetail1innovar,infordetail1innovar]=estimate(mdlinnovardetail1,ydetail1);
res_innovardetail1 = infer(estmdldetail1innovar,ydetail1);
rng('default')
Ysim_innovardetail1 = simulate(estmdldetail1innovar,720,'NumPaths',50,'Y0',ydetail1,'E0',res_innovardetail1);
mn_innovardetail1 = mean(Ysim_innovardetail1,2);
pcddetail1innovar=[ydetail1;mn_innovardetail1];
%% reconstruction

Caic=[pcdapproxaic;pcddetail6aic;pcddetail5aic;pcddetail4aic;pcddetail3aic;pcddetail2aic;pcddetail1aic];
Cbic=[pcdapproxbic;pcddetail6bic;pcddetail5bic;pcddetail4bic;pcddetail3bic;pcddetail2bic;pcddetail1bic];
Cinnovar= [pcdapproxinnovar;pcddetail6innovar;pcddetail5innovar;pcddetail4innovar;pcddetail3innovar;pcddetail2innovar;pcddetail1innovar];
L=[248;248;495;990;1980;3960;7920;15840];
Xpaic=waverec(Caic,L,wname);
Xpbic=waverec(Cbic,L,wname);
Xpinnovar=waverec(Cinnovar,L,wname);
%% rms error and error
rmseaic= sqrt(mean(((Xpaic(14401:15840)./m)-(data_original./m)).^2))
[corraic,lags]=xcorr((Xpaic(14401:15840)),data_original,0,'coeff')

rmsebic= sqrt(mean(((Xpbic(14401:15840)./m)-(data_original./m)).^2))
[corrbic,lags]=xcorr((Xpbic(14401:15840)),data_original,0,'coeff')

rmseinnovar= sqrt(mean(((Xpinnovar(14401:15840)./m)-(data_original./m)).^2))
[corrinnovar,lags]=xcorr((Xpinnovar(14401:15840)),data_original,0,'coeff')
%% plot
plot(data,'k','Linewidth',2)
hold on
plot([T+1:T+1440],Xpaic(14401:15840),'r','Linewidth',2)
hold on
plot([T+1:T+1440],Xpbic(14401:15840),'b','Linewidth',2)
hold on
plot([T+1:T+1440],Xpinnovar(14401:15840),'g','Linewidth',2)

