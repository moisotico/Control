%Parameter estimation from inverse response to step input
%Anupam Srivastava and Ashok K. Verma

load test;

t1=200;
t2=439;
Area1=trapz(y(1:t1));
Area2=trapz(y(t1:t2));

t1=t1/1000;
t2=t2/1000;

kp=(max(y)-(Area2)/t2)/(t1-0.5*t2)

tau1 =t1-(max(y)/kp)
tau2=((Area1 /kp)-0.5*t1^2+tau1*t1)/(tau1-t1)

s=tf('s');
ps= kp*(-tau1*s+1)/(s*(tau2*s+1));
figure
step(ps)
hold on

psorig=-2*(-0.25*s+1)/(s*(0.5*s+1));
step(psorig)

xlim([0 4])