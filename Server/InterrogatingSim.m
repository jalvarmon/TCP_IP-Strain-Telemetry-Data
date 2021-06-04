% Script to generate random vector simulating sensors
%Creation: Dec. 17, 2017 By Alejandro Carvajal Castrillon
%Last Update: Dec. 17, 2017

%Set lower boundary
a = 1525;

%Set upper boundary
b = 1570;

%Set number of sensors
n = 20;

%Generate fake measurements
 data = a + (b-a).*rand(1,n);
