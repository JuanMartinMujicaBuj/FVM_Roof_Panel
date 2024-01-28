close all, clear all, clc
%Script que toma datos obtenidos del solver principal para obtener gráficos
%para el informe. Análisis de variación de dimensiones de materiales del módulo de techo.
load('variacion_espesores_metal.mat');

% Orden de datos
QrefrigeracionVec(QrefrigeracionVec<0) = 0;
QcalefaccionVec(QcalefaccionVec<0) = 0;
QpromedioVec_orig = QpromedioVec(find(hMetalVec==h_orig(3)));
% Gráficos
% Gráfico potencia promedio en enero variando espesor de metal
figure
subplot(2,3,1)
plot(h_orig(3)*1000,QpromedioVec_orig(1),'g*'); hold on
plot(hMetalVec(1:2:39)*1000,QpromedioVec(1:2:39),'Color',[0.8500 0.3250 0.0980],'Marker','*');
plot(h_orig(3)*1000,QpromedioVec_orig(1),'g*'); grid on
title('Potencia promedio - enero - $T_{in}$=22.5$^{\circ}$C','interpreter','latex');
xlabel('Espesor de metal [mm]','interpreter','latex');
ylabel('Potencia [W]','interpreter','latex');
legend({'Espesor original de metal'},'interpreter','latex','Location','NorthWest');
ax=gca; ax.TickLabelInterpreter='latex';
% Gráfico potencia promedio en julio variando espesor de metal
subplot(2,3,4)
plot(h_orig(3)*1000,QpromedioVec_orig(2),'g*'); hold on
plot(hMetalVec(2:2:40)*1000,QpromedioVec(2:2:40),'Color',[0 0.4470 0.7410],'Marker','*');
plot(h_orig(3)*1000,QpromedioVec_orig(2),'g*'); grid on
title('Potencia promedio - julio - $T_{in}$=22.5$^{\circ}$C','interpreter','latex');
xlabel('Espesor de metal [mm]','interpreter','latex');
ylabel('Potencia [W]','interpreter','latex');
legend({'Espesor original de metal'},'interpreter','latex','Location','NorthWest');
ax=gca; ax.TickLabelInterpreter='latex';

clear all

load('variacion_espesores_yeso.mat');
% Orden de datos
QrefrigeracionVec(QrefrigeracionVec<0) = 0;
QcalefaccionVec(QcalefaccionVec<0) = 0;
QpromedioVec_orig = QpromedioVec(find(hYesoVec==h_orig(1)));
% Gráficos
% Gráfico potencia promedio en enero variando espesor de yeso
subplot(2,3,2)
plot(h_orig(1)*1000,QpromedioVec_orig(1),'g*'); hold on
plot(hYesoVec(1:2:31)*1000,QpromedioVec(1:2:31),'Color',[0.8500 0.3250 0.0980],'Marker','*'); 
plot(h_orig(1)*1000,QpromedioVec_orig(1),'g*'); grid on
title('Potencia promedio - enero - $T_{in}$=22.5$^{\circ}$C','interpreter','latex');
xlabel('Espesor de yeso [mm]','interpreter','latex');
ylabel('Potencia [W]','interpreter','latex');
legend({'Espesor original de yeso'},'interpreter','latex','Location','NorthWest');
ax=gca; ax.TickLabelInterpreter='latex';
% Gráfico potencia promedio en julio variando espesor de yeso
subplot(2,3,5)
plot(h_orig(1)*1000,QpromedioVec_orig(2),'g*'); hold on
plot(hYesoVec(2:2:32)*1000,QpromedioVec(2:2:32),'Color',[0 0.4470 0.7410],'Marker','*');
plot(h_orig(1)*1000,QpromedioVec_orig(2),'g*'); grid on
title('Potencia promedio - julio - $T_{in}$=22.5$^{\circ}$C','interpreter','latex');
xlabel('Espesor de yeso [mm]','interpreter','latex');
ylabel('Potencia [W]','interpreter','latex');
legend({'Espesor original de yeso'},'interpreter','latex','Location','NorthWest');
ax=gca; ax.TickLabelInterpreter='latex';

clear all

load('variacion_espesores_maderaislante.mat');
% Orden de datos
QrefrigeracionVec(QrefrigeracionVec<0) = 0;
QcalefaccionVec(QcalefaccionVec<0) = 0;
QpromedioVec_orig = QpromedioVec(find(bMaderaVec==b_orig(2)));
% Gráficos
% Gráfico potencia promedio en enero variando largo de madera y aislante
subplot(2,3,3)
plot(b_orig(2)*1000,QpromedioVec_orig(1),'g*'); hold on
plot(bMaderaVec(1:2:25)*1000,QpromedioVec(1:2:25),'Color',[0.8500 0.3250 0.0980],'Marker','*');
plot(b_orig(2)*1000,QpromedioVec_orig(1),'g*'); grid on
title('Potencia promedio - enero - $T_{in}$=22.5$^{\circ}$C','interpreter','latex');
xlabel('Largo de madera [mm]','interpreter','latex');
ylabel('Potencia [W]','interpreter','latex');
legend({'Largo original de madera-aislante'},'interpreter','latex','Location','NorthWest');
ax=gca; ax.TickLabelInterpreter='latex';
% Gráfico potencia promedio en julio variando largo de madera y aislante
subplot(2,3,6)
plot(b_orig(2)*1000,QpromedioVec_orig(2),'g*'); hold on
plot(bMaderaVec(2:2:26)*1000,QpromedioVec(2:2:26),'Color',[0 0.4470 0.7410],'Marker','*');
plot(b_orig(2)*1000,QpromedioVec_orig(2),'g*'); grid on
title('Potencia promedio - julio - $T_{in}$=22.5$^{\circ}$C','interpreter','latex');
xlabel('Largo de madera [mm]','interpreter','latex');
ylabel('Potencia [W]','interpreter','latex');
legend({'Largo original de madera-aislante'},'interpreter','latex','Location','NorthWest');
ax=gca; ax.TickLabelInterpreter='latex';
% Aunque con lo que sigue pisamos los últimos dos subplots (la tercera
% columna)

% Plot con dos escalas en x
variacion_espesores_2;
