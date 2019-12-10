clear all;
clc;


A=xlsread('algo_2008');
t=A(:,1);
d=A(:,2); m=max(d);
d=d';
x=d(127286:141685)./m;
x1=d(127286:143125)./m;
wname='haar';
[c1,l1]=wavedec(x,6,wname);
[c2,l2]=wavedec(x1,6,wname);

al6=c1(1:225);
dl6=c1(226:450);
dl5=c1(451:900);
dl4=c1(901:1800);
dl3=c1(1801:3600);
dl2=c1(3601:7200);
dl1=c1(7201:14400);


%% predict approx l-6
apl6_in=al6(1:200);
apl6_tar=al6(26:225);
apl6_sample=al6(203:225);
apl6net=newff(apl6_in,apl6_tar, [5,12,15,7] ,{'tansig','tansig','tansig','tansig','purelin'},'trainbr');
apl6net.trainParam.show = 50; 
apl6net.trainParam.lr = 0.05;
apl6net.trainParam.epochs =1000;
apl6net.trainParam.goal = 1e-3;
apl6net = train(apl6net,apl6_in,apl6_tar); 
ap16_p= sim(apl6net,apl6_sample);
apl6_pre=[al6 ap16_p];

%% predict detail l6
dpl6_in=dl6(1:200);
dpl6_tar=dl6(26:225);
dpl6_sample=dl6(203:225);
dpl6net=newff(dpl6_in,dpl6_tar, [5,12,15,7] ,{'tansig','tansig','tansig','tansig','purelin'},'trainbr');
dpl6net.trainParam.show = 50; 
dpl6net.trainParam.lr = 0.05;
dpl6net.trainParam.epochs =1000;
dpl6net.trainParam.goal = 1e-3;
dpl6net = train(dpl6net,dpl6_in,dpl6_tar); 
dp16_p= sim(dpl6net,dpl6_sample);
dpl6_pre=[dl6 dp16_p];

%% predict detail l5
dpl5_in=dl5(1:405);
dpl5_tar=dl5(46:450);
dpl5_sample=dl5(406:450);
dpl5net=newff(dpl5_in,dpl5_tar, [5,12,15,7] ,{'tansig','tansig','tansig','tansig','purelin'},'trainbr');
dpl5net.trainParam.show = 50; 
dpl5net.trainParam.lr = 0.05;
dpl5net.trainParam.epochs =1000;
dpl5net.trainParam.goal = 1e-3;
dpl5net = train(dpl5net,dpl5_in,dpl5_tar); 
dpl5_p= sim(dpl5net,dpl5_sample);
dpl5_pre=[dl5 dpl5_p];

%% predict detail l4
dpl4_in=dl4(1:810);
dpl4_tar=dl4(91:900);
dpl4_sample=dl4(811:900);
dpl4net=newff(dpl4_in,dpl4_tar, [5,12,15,7] ,{'tansig','tansig','tansig','tansig','purelin'},'trainbr');
dpl4net.trainParam.show = 50; 
dpl4net.trainParam.lr = 0.05;
dpl4net.trainParam.epochs =1000;
dpl4net.trainParam.goal = 1e-3;
dpl4net = train(dpl4net,dpl4_in,dpl4_tar); 
dpl4_p= sim(dpl4net,dpl4_sample);
dpl4_pre=[dl4 dpl4_p];

%% predict detai l3
dpl3_in=dl3(1:1620);
dpl3_tar=dl3(181:1800);
dpl3_sample=dl3(1621:1800);
dpl3net=newff(dpl3_in,dpl3_tar, [5,12,15,7] ,{'tansig','tansig','tansig','tansig','purelin'},'trainbr');
dpl3net.trainParam.show = 50; 
dpl3net.trainParam.lr = 0.05;
dpl3net.trainParam.epochs =1000;
dpl3net.trainParam.goal = 1e-3;
dpl3net = train(dpl3net,dpl3_in,dpl3_tar); 
dpl3_p= sim(dpl3net,dpl3_sample);
dpl3_pre=[dl3 dpl3_p];

%% predict detail l2
dpl2_in=dl2(1:3240);
dpl2_tar=dl2(361:3600);
dpl2_sample=dl2(3241:3600);
dpl2net=newff(dpl2_in,dpl2_tar, [5,12,15,7] ,{'tansig','tansig','tansig','tansig','purelin'},'trainbr');
dpl2net.trainParam.show = 50; 
dpl2net.trainParam.lr = 0.05;
dpl2net.trainParam.epochs =1000;
dpl2net.trainParam.goal = 1e-3;
dpl2net = train(dpl2net,dpl2_in,dpl2_tar); 
dpl2_p= sim(dpl2net,dpl2_sample);
dpl2_pre=[dl2 dpl2_p];

%% predict detail l1

dpl1_in=dl1(1:6480);
dpl1_tar=dl1(721:7200);
dpl1_sample=dl1(6481:7200);
dpl1net=newff(dpl1_in,dpl1_tar, [5,12,15,7] ,{'tansig','tansig','tansig','tansig','purelin'},'trainbr');
dpl1net.trainParam.show = 50; 
dpl1net.trainParam.lr = 0.05;
dpl1net.trainParam.epochs =1000;
dpl1net.trainParam.goal = 1e-3;
dpl1net = train(dpl1net,dpl1_in,dpl1_tar); 
dpl1_p= sim(dpl1net,dpl1_sample);
dpl1_pre=[dl1 dpl1_p];
%%
C=[apl6_pre dpl6_pre dpl5_pre dpl4_pre dpl3_pre dpl2_pre dpl1_pre];L=l2;
ptec=waverec(C,L,wname);

rmsewann=sqrt(mean((x1-ptec).^(2)))
[cann,lann]=xcorr(x1,ptec,0,'coeff')
