clear all, close all, clc
% Script para hacer algunos cálculos sobre la comparación con resultados
% comerciales. No realiza plots. 
% Con nuestras propiedades, sin convección ni radiación
load('comparacion_comercial.mat');

deltaT = abs(Tin-Tout); % °C o K
Qtransferido = QTot_norteMat{1}(end); % W/m
qtransferido = Qtransferido/sum(b); % W/m2
Req = deltaT/qtransferido; % m2*K/W

Req_comerciales = 1./[0.59 0.38 0.25 0.52 0.36 0.24 1.22 ...
                      0.042/91e-3 0.043/91e-3 0.046/91e-3];
Req_norma = 1./[0.32 0.83 1 0.18 0.19 0.45 0.48 0.72 0.76];
Req_norma_min = 1/1; % m2K/W

diff_Req = abs(mean(Req_comerciales)-Req);
diff_porcentual = diff_Req*100/mean([Req mean(Req_comerciales)]);
fprintf('La diferencia entre las resistencias equivalentes entre\n guía y nuestro modelo adaptado es de D = %.2f K*m2/W, equivalente a una diferencia del %.2f%%\n',diff_Req,diff_porcentual);
