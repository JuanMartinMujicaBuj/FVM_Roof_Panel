clear all, clc, close all
%Script que toma datos obtenidos del solver principal para obtener gráficos
%para el informe. Análisis de evolución de potencia para comparar refrigeración y calefacción.
load('resultados_principales_3.mat');

% Ordenamos datos de potencia por cara sur
todos_sur = [];
for i = 1:length(todos_QTot_surMat)
    todos_sur = [todos_sur todos_QTot_surMat{i}(288:384)]; % [W]
end
calor = todos_sur*dt; % [J], es el área bajo la curva de potencia
A_positiva = sum(calor(calor>0)); % Área positiva bajo la curva de potencia
A_negativa = -sum(calor(calor<0)); % Área negativa bajo la curva de potencia
A_tot = sum(abs(calor)); % Área total

% Recordar: positiva es de calefacción, negativa es de refrigeración
ratio_positivo = 100*A_positiva/A_tot; % Proporción del total del área que es positiva
ratio_negativo = 100*A_negativa/A_tot; % Proporción del total del área que es positiva