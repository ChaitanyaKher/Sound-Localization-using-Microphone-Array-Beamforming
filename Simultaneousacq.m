clc;
close all;
clear all;
a=arduino;
samples=100;
v0 = readVoltage(a,'A0');
v1 = readVoltage(a,'A1');
v2 = readVoltage(a,'A2');
b=zeros(samples,1);
while 1
    tic;
    for i=1:samples
        b(i)=[v0 v1 v2];
        disp(b);
    end
    toc;
end

