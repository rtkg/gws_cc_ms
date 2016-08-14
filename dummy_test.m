clear all; close all; clc;

GW(1).W=[0 1; 0 0];
GW(2).W=[1 -1; 0 0];
GW(3).W=[-1 -1; 0 0];
T=[0 -1];
options.GWS='union';
[q_u tq]=graspQuality(GW,T,options);
q_u
options.GWS='minkowski';
[q_m tq]=graspQuality(GW,T,options);
q_m