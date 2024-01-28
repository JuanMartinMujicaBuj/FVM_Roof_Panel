clear all, clc, close all
%Script que toma datos obtenidos del solver principal para obtener gr�ficos
%para el informe. An�lisis de evoluci�n de potencia para comparar refrigeraci�n y calefacci�n.
load('resultados_principales_3.mat');

% Ordenamos datos de potencia por cara sur
todos_sur = [];
for i = 1:length(todos_QTot_surMat)
    todos_sur = [todos_sur todos_QTot_surMat{i}(288:384)]; % [W]
end
calor = todos_sur*dt; % [J], es el �rea bajo la curva de potencia
A_positiva = sum(calor(calor>0)); % �rea positiva bajo la curva de potencia
A_negativa = -sum(calor(calor<0)); % �rea negativa bajo la curva de potencia
A_tot = sum(abs(calor)); % �rea total

% Recordar: positiva es de calefacci�n, negativa es de refrigeraci�n
ratio_positivo = 100*A_positiva/A_tot; % Proporci�n del total del �rea que es positiva
ratio_negativo = 100*A_negativa/A_tot; % Proporci�n del total del �rea que es positiva