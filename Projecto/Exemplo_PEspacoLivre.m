% Aula 05.03.2018
clear all, 
close all
smithchart
f= 1e9; %Hz
c=3e8 %m/s
lambda=c/f;%m
     
Gtx=0 , Grx=0 % dB
Ptx=0 %dBm

for i=-50:1:50
    for j=-50:1:50
        distance_map(i+51,j+51)=sqrt(i^2+j^2);
    end
end

L=20*log10(4*pi.*distance_map/lambda);

Prx_dBm=Ptx+Gtx+Grx-L;
Prx_dBm(51,51)=0; % at the location of the base station

%plot(d,Prx_dBm)
meshc(-50:1:50,-50:1:50,Prx_dBm)
xlabel('Distance x')
ylabel('Distance y')
zlabel('P_r_x [dBm]')
colorbar

