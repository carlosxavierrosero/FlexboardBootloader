% plant

A=[0 -23.8; 0 0];
B=[0; -23.8];
C=[1 0];
D=0;

sysCont=ss(A,B,C,D)

h=0.05;

sysDisc=c2d(sysCont,h);

desiredPoles=[-10+20i -10-20i];

Kd=acker(sysDisc.a, sysDisc.b, exp(desiredPoles*h))


%%%%%%%%%%%%

% s = tf('s');
% di = 566.44/s^2;
% 
% Ts = 0.05;
% ddi = c2d(di,Ts,'zoh')
% 
% numddiz = [0.7081 0.708];
% denddiz = [1 -2 1];
% ddiz = tf(numddiz,denddiz,Ts);
% 
% [x,t] = step(ddiz,5)
% stairs(t,x)

Kp=1;
Kd=0.1;
Ts=0.05
z = tf('z',Ts);
ddiz = 1.0*(0.1133*z + 0.1133)/(z^2 - 2*z + 1);


figure(1); 
[x,t] = step(ddiz,5); 
stairs(t,x)

figure(2);  
sys_cl = feedback(Kp*ddiz,1); 
[x,t] = step(sys_cl,1); stairs(t,x)

figure(3); 
C = ((Kp+Kd)*z^2 - (Kp+2*Kd)*z + Kd)/(z^2 + z)
sys_cl = feedback(C*ddiz,1);
[x,t] = step(sys_cl,5); stairs(t,x)


% controlador trobat amb MATLAB
P=0.0138551576497267;
I=4.44803769023006e-05;
D=0.442382641424155;
N=0.862662739489541;

a=P;
b=N*Ts*P-2*P+I*Ts+N*D;
c=P-N*Ts*P-I*Ts+N*Ts^2*I-D*N;
d=-2+N*Ts;
e=1-N*Ts;


%u(k)=-d*u(k-1)-e*u(k-2)+a*e(k)+b*e(k-1)+c*e(k-2)


%%%%%%%%%%%%%%%%%%%%%

Ts=0.05

syms kp kd Ki z
fz=(0.00125*z+0.00125)/(z^2 - 2*z + 1)


controlador=kp+kd*(z-1)/z+Ki*z/(z-1)

fzllt=controlador*fz/(1+controlador*fz)

denllt=(800*z - kd + kp*z + kd*z^2 + kp*z^2 - 1600*z^2 + 800*z^3);

pdesitjat=(z- 0.3277 + 0.5104i)*(z-0.3277 - 0.5104i)*(z-0.3)

