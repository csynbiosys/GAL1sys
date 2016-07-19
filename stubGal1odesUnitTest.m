clear;clc
input = load('input_measured.mat');
output=load('output_filtered_positive.mat');

gfp = output.gfp';
u = input.input_measured';
tu=0:5:(length(u)-1)*5;
load par
t0=0;
tf=(length(gfp)-1).*5;
y_0=0.6777;
ts=t0:5:tf;
tu=ts;
u=u>mean(u);%square(tu./100+1000)./2+0.5
pend=zeros(1,length(ts)-1);
[yteor,iflag]=gal1bbmodel(t0,tf,ts,y_0,par,u,pend,tu);

plot(ts,gfp,ts,yteor,tu,u)



load par
t0=0;
tf=995;
y_0=0.6777;
%y_0=0;
ts=0:5:995;
load('par.mat')
u=zeros(length(ts),1);
tu=ts;
pend=zeros(length(ts)-1,1);
[yteor,iflag]=gal1bbmodel(t0,tf,ts,y_0,par,u',pend',tu)


output=load('output_filtered_positive.mat');
gfp = output.gfp;

%simulazione del modello con i parametri assegnati in par e input ideale
% sol = ode23s(@Gal1,[0 length(gfp)]*5, par(6), [],par);

% %simulazione del modello con i parametri assegnati in par e input simulato


