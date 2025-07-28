clc
clear
close all

%physical params
g = 9.81;
L1 = 1;
L2 = 1;
m1 = 1;
m2 = 1;
dt = 0.05;  %updates every .01sec

%initial and final time
t0 = 0;
tf = 20;    %so in total 20*.01=2000 time steps

%initial contidions
%[@1,w1,@2,w2]
IC1 = [pi/2, 4.5, pi/2, 0];
IC2 = [pi/2+0.01, 4.5, pi/2-0.01, 0];


%%implementing the classes
pendulum = doublependulum(g,L1,L2,m1,m2,dt);
[time, Y1, Y2] = pendulum.simulatecomparison(t0,tf,IC1,IC2);

visualize(time,Y1,Y2,L1,L2);
