clc;
close all;
clear all;

a= arduino;%detect the arduino board
f=1000;%in Hz
c=343;%in m/sec
%v=343;%speed of
samples=input('Enter the input sample size: ');
lambda=c/f; %source wavelength in m
l=.04;%in m
%filename = 'Testdata.xlsx';
v0=zeros(samples,1);%A0
v1=zeros(samples,1);%A1
v2=zeros(samples,1);%A2

v3=zeros(samples,1);%A1
v4=zeros(samples,1);%A2
v5=zeros(samples,1);%A0

v6=zeros(samples,1);%A2
v7=zeros(samples,1);%A0
v8=zeros(samples,1);%A1


while 1
    %tic;
    %1st for loop(Sampling order= 0 1 2)
    for i=1:samples
        v0(i) = readVoltage(a,'A0');
        v1(i) = readVoltage(a,'A1');
        v2(i) = readVoltage(a,'A2');
    end
    %2nd for loop(Sampling order= 1 2 0)
    for i=1:samples
        v3(i) = readVoltage(a,'A1');
        v4(i) = readVoltage(a,'A2');
        v5(i) = readVoltage(a,'A0');
    end
    %3rd for loop(Sampling order= 2 0 1)
    for i=1:samples
        v6(i) = readVoltage(a,'A2');
        v7(i) = readVoltage(a,'A0');
        v8(i) = readVoltage(a,'A1');
    end
 
    %Phase Seq 1
    phim101 = myphase(v0,v1);
    phim112 = myphase(v1,v2);
        
    %Phase seq 2
    phim201 = myphase(v5,v3);
    phim212 = myphase(v3,v4);
    
    %Phase seq 3
    phim301 = myphase(v7,v8);
    phim312 = myphase(v8,v6);
    
    phi1=myphase((v0+v5+v7)/3,(v1+v3+v8)/3);
    phi2=myphase((v1+v3+v8)/3,(v2+v4+v6)/3);
    theta2=(phi1+phi2)/2;
    
    %fprintf('Phi1: %f\t%f\t%f\n',phim101,phim201,phim301);
    %fprintf('Phi2: %f\t%f\t%f\n',phim112,phim212,phim312);
    P1=phim101*phim112;
    P2=phim201*phim212;
    P3=phim301*phim312;
    
    if(P1>=0)
        if(P2>=0)
            if(P3>=0)
                ph_diff1=(phim101+phim201+phim301)/3;
                ph_diff2=(phim112+phim212+phim312)/3;
            else
                ph_diff1=(phim101+phim201)/2;
                ph_diff2=(phim112+phim212)/2;
            end
        elseif(P3>=0)
            ph_diff1=(phim101+phim301)/2;
            ph_diff2=(phim112+phim312)/2;
        else
            ph_diff1=phim101;
            ph_diff2=phim112;
        end
    elseif(P2>=0)
        if(P3>=0)
            ph_diff1=(phim201+phim301)/2;
            ph_diff2=(phim212+phim312)/2;
        else
            ph_diff1=phim201;
            ph_diff2=phim212;
        end
    elseif(P3>=0)
        ph_diff1=phim301;
        ph_diff2=phim312;
    else
        ph_diff1=pi/2;
        ph_diff2=pi/2;
    end
    
    
    AngleOfArrival12=asin((ph_diff1*lambda)/(2*pi*l));
    %disp(AngleOfArrival12_deg);
    
    AngleOfArrival23=asin((ph_diff2*lambda)/(2*pi*l));

    theta=(AngleOfArrival12+AngleOfArrival23)/2;
    polarscatter(theta2,1);
    drawnow;
    %toc;
end
