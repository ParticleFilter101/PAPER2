clc;clear all; close all;
A=xlsread('algo_2008');
t=A(:,1);
d=A(:,2);
d=d';
a1=d(127286:128725);
a2=d(128726:130165);
a3=d(130166:131605);
a4=d(131606:133045);
a5=d(133046:134485);
a6=d(134486:135925);
a7=d(135926:137365);
a8=d(137366:138805);
a9=d(138806:140245);
a10=d(140246:141685);
a11=d(141686:143125);

d1=d(127286:143125);
m=max(d1);
t1=t(127286:143125); 
input = [a1 a2 a3 a4 a5 a6 a7 a8 a9 ]./m; 
  target= [a2 a3 a4 a5 a6 a7 a8 a9 a10]./m;
  sample=   [a10]./m;
  original= [a11]./m;
  original_ann_algo2008=original.*m;
  
  in_len=length(input);
  s_len=length(sample);
  net=newff(input,target, [5,12,15,7], {'tansig','tansig','tansig','tansig','purelin'},'trainlm');
  net.trainParam.show = 50; 
  net.trainParam.lr = 0.05;
  net.trainParam.epochs =1000;
  net.trainParam.goal = 1e-3;
  net = train(net,input,target); 
  a1= sim(net,sample);
  predicted1=a1;
  predicted_ann_algo2008=predicted1.*m;
  
   RMS_error= sqrt(sum((original-predicted1).^2)/length(a11))
  correlation_coefficient=corr2(original,predicted1)
  plot(t1,d1,'Linewidth',2)
  hold on
  t2=t(141686:143125);
  plot(t2,predicted1*m,'Linewidth',2)
  t2=t(141686:143125);