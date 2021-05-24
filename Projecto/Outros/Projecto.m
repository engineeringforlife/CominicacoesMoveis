
clear all, 
close all

load Estacoes.mat
SquareSize=200;
step=5;
c=3e8 %m/s


% Cria a lista de sinais atrasmitidos em função do numero de funçoes base
for i=1:1:length(est)
    signal(i).freq=est(i).freq
end

%Calcula a potência em cada ponto Considerando apenas FSL, a potência dos
%sinais e o ganho das antenas.

for i=-SquareSize:1:SquareSize
    for j=-SquareSize:1:SquareSize
        for k=1:1:length(est)
          distance_map=pdist([est(k).cord(1),est(k).cord(2);i,j],'euclidean');
          lambda=c/est(1).freq;%m
          L=20*log10(4*pi.*distance_map/lambda);    
          signal(k).power(i+(SquareSize+1),j+(SquareSize+1))=est(k).ptx+est(k).gtx - L;
        end
    end
end

%Considera a potencia do sinal nas coordenadas da antena.
%De outra forma obter-se-ia inf.
for k=1:1:length(est)
    signal(k).power(est(k).cord(1)+(SquareSize+1),est(k).cord(2)+(SquareSize+1))=est(k).ptx+est(k).gtx;
end

%Faz o plot dos sinais nao longo do mapa
for k=1:1:length(est)
    if signal(k).freq==est(1).freq
        hold on
        mesh(-SquareSize:1:SquareSize,-SquareSize:1:SquareSize,signal(k).power, 'edgecolor', 'r', 'FaceLighting' ,'gouraud')
    elseif signal(k).freq==est(2).freq
        hold on
        mesh(-SquareSize:1:SquareSize,-SquareSize:1:SquareSize,signal(k).power, 'edgecolor', 'g', 'FaceLighting' ,'gouraud')
    else
        hold on
        mesh(-SquareSize:1:SquareSize,-SquareSize:1:SquareSize,signal(k).power, 'edgecolor', 'b', 'FaceLighting' ,'gouraud')
    end
end

xlabel('Distance x')
ylabel('Distance y')
zlabel('P_r_x [dBm]')
%colorbar


