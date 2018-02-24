%
% Universidad de Costa Rica
% Escuela de Ing Eléctrica
% IE0431 Sistemas de Control
%
% Moises F. Campos Zepeda
% Emilio Javier Rojas Alvarez
% Sara Daniela Diaz Marin
%
%Metodo de Anupam Srivastava and Ashok K. Verma
%
% Se limpia el área de trabajo
clc
clear
%caargamos el achivo con los datos de la planta real
load test;
 [Ymax,tmin]= max(y); t1=t(tmin);       %calculo de t1 y Ymax
 Area1=trapz([y(1:tmin)])*itv;          %integral de y de 0 a t1
 w = length(y);
	for i = tmin:w
		if y(i)<0
            t2=t(i); counter = i; break    %calculo del valor de t1 
		else 
			continue
		end 
	end
Area2=trapz([y(1:counter)])*itv;        %integral de y 0 a t2
%calculos de ganancia y tau 1 y 2
kp=(Ymax-(Area2)/t2)/(t1-0.5*t2);       
tau1 =t1-(Ymax/kp);
tau2=((Area1 /kp)-0.5*t1^2+tau1*t1)/(tau1-t1);
Parameters= [tau1 tau2 kp];

%definimos un sistema dinamico
s=tf('s');
ps= kp*(-tau1*s+1)/(s*(tau2*s+1));
figure('rend','painters','pos',[5 5 800 800])
title('Comparacion de respuesta de la plata y modelo utilizando Srivastava y Verma ')
%grafica de modelo identificado
step(ps, 'r-.')
hold on
psorig= -2*(-0.25*s+1)/(s*(0.5*s+1));
%grafica de modelo original
step(psorig)
xlim([0 4])

escalon=heaviside(t);

proceso=lsim(ps,escalon,t);
modelo=lsim(psorig,escalon,t);
%grafica de error
error=modelo-proceso;
%IAE
IAE4 = abs(trapz(error(1:400000))*itv );
IAE6 = abs(trapz(error(1:600000))*itv );
IAE10 = abs(trapz(error(1:1000000))*itv );

%ISE
ISE4 = abs(trapz(error(1:400000).^2)*itv );
ISE6 = abs(trapz(error(1:600000).^2)*itv );
ISE10 = abs(trapz(error(1:1000000).^2)*itv );

figure('rend','painters','pos',[5 5 800 800])
title('Error del Modelo')
hold on
plot(t,error,'k')
plot(t,0*t,'k:')
legend('error','0')