clc;
close all; 
clear a;
a= arduino('com3','uno');%detect the arduino board

samples=10;
v0=zeros(samples,1);
v1=zeros(samples,1);
v2=zeros(samples,1);


%t0=milliseconds(v0);
%t1=milliseconds(v1);
%t2=milliseconds(v2);

%figure
%h = animatedline;
%ax = gca;
%ax.YGrid = 'on';
%ax.YLim = [0 7];

%startTime = datetime('now');
while 1
    for i=1:samples
        v0(i) = readVoltage(a,'A0');
        v1(i) = readVoltage(a,'A1');
        v2(i) = readVoltage(a,'A2');
    end
    dot_product = dot(v0,v1);
norm_product = (norm(v0)*norm(v1));
phase_shift_in_degrees = acos(dot_product/norm_product)*(180/pi);
disp(phase_shift_in_degrees);
end
clear a;