clear all, close all, clc
% Script para hacer algunos cálculos sobre la comparación con resultados
% de modelo analítico resistivo de la guía 1. No realiza plots. 
% Con nuestras propiedades, sin convección ni radiación
load('comparacion_guia.mat');

deltaT = abs(Tin-Tout); % °C o K
Qtransferido = abs(QTot_norteMat{1}(end)); % W/m
qtransferido = Qtransferido/sum(b); % W/m2
Req = deltaT/qtransferido; % m2*K/W

Req_guia = 44.994; % K*m2/W

diff_Req = abs(Req_guia-Req);
diff_porcentual = diff_Req*100/((Req+Req_guia)/2);
fprintf('La diferencia entre las resistencias equivalentes entre\n guía y nuestro modelo adaptado es de D = %.2f K*m2/W, equivalente a una diferencia del %.2f%%\n',diff_Req,diff_porcentual);

% Extras
flujoCalor_guia = 27/(Req_guia/0.4); % W
RconvecSur = 10; % K/W
RconvecNorte = 100; % K/W
TCaraSur = -5+flujoCalor_guia*RconvecSur;
TCaraNorte = 22-flujoCalor_guia*RconvecNorte;