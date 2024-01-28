clear all, close all, clc
%Script que toma datos obtenidos del solver principal para obtener gráficos
%para el informe. Análisis de sensibilidad temporal de malla.
load('sensibilidad_malla_temporal.mat');

% Plot de potencia promedio vs paso temporal. Enero.
figure
subplot(2,1,1)
semilogx(dtVec(7)/60,QpromedioVec(7),'g*'); hold on
semilogx(dtVec(1:2:17)/60,QpromedioVec(1:2:17),'Color',[0.8500 0.3250 0.0980],'Marker','*'); grid on
semilogx(dtVec(7)/60,QpromedioVec(7),'g*');
title('Potencia promedio vs paso temporal - enero - $T_{in}$=22.5$^{\circ}$C','interpreter','latex');
legend({'$\Delta$t elegido'},'interpreter','latex');
xlabel('Paso temporal $\Delta$t [min]','interpreter','latex');
ylabel('Potencia [W]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';

% Plot de potencia promedio vs paso temporal. Julio.
subplot(2,1,2)
semilogx(dtVec(8)/60,QpromedioVec(8),'g*'); hold on
semilogx(dtVec(2:2:18)/60,QpromedioVec(2:2:18),'Color',[0 0.4470 0.7410],'Marker','*'); grid on
semilogx(dtVec(8)/60,QpromedioVec(8),'g*');
title('Potencia promedio vs paso temporal - julio - $T_{in}$=22.5$^{\circ}$C','interpreter','latex');
legend({'$\Delta$t elegido'},'interpreter','latex');
xlabel('Paso temporal $\Delta$t [min]','interpreter','latex');
ylabel('Potencia [W]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';

% Plots de potencia a lo largo del día, para cada uno de los pasos
% temporales.
figure 
       %15min, 1min, 1/2horas, 6horas
subplot(2,1,1) % enero (norte y sur)
plot([0:1/60:24],QTot_norteMat{1},'b',...
     [0:1/4:24],QTot_norteMat{7},'r',...
     [0:1:24],QTot_norteMat{11},'g',...
     [0:6:24],QTot_norteMat{17},'m',...
     [0:1/60:24],QTot_surMat{1},'b--',...
     [0:1/4:24],QTot_surMat{7},'r--',...
     [0:1:24],QTot_surMat{11},'g--',...
     [0:6:24],QTot_surMat{17},'m--');
 grid on
title('Flujo de calor norte (l\''inea s\''olida) y sur (l\''inea punteada) en un d\''ia de enero','interpreter','latex');
lgd=legend({'$\Delta$t=1 minutos','$\Delta$t=15 minutos','$\Delta$t=1 hora','$\Delta$t=6 horas'},'interpreter','latex');
lgd.FontSize = 8;
xlabel('Horas del d\''ia [hs]','interpreter','latex');
ylabel('Flujo de calor [W/m]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';
subplot(2,1,2) % julio (norte y sur)
plot([0:1/60:24],QTot_norteMat{2},'b',...
     [0:1/4:24],QTot_norteMat{8},'r',...
     [0:1:24],QTot_norteMat{12},'g',...
     [0:6:24],QTot_norteMat{18},'m',...
     [0:1/60:24],QTot_surMat{2},'b--',...
     [0:1/4:24],QTot_surMat{8},'r--',...
     [0:1:24],QTot_surMat{12},'g--',...
     [0:6:24],QTot_surMat{18},'m--');
 grid on
title('Flujo de calor norte (l\''inea s\''olida) y sur (l\''inea punteada) en un d\''ia de julio','interpreter','latex');
lgd=legend({'$\Delta$t=1 minutos','$\Delta$t=15 minutos','$\Delta$t=1 hora','$\Delta$t=6 horas'},'interpreter','latex');
lgd.FontSize = 8;
xlabel('Horas del d\''ia [hs]','interpreter','latex');
ylabel('Flujo de calor [W/m]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';

%Error al tomar paso de 15min o menores
maxEnero=max(QpromedioVec(1:2:7));
minEnero=min(QpromedioVec(1:2:7));
maxJulio=max(QpromedioVec(2:2:8));
minJulio=min(QpromedioVec(2:2:8));
maxDifEnero=maxEnero-minEnero;
maxDifJulio=maxJulio-minJulio;
maxDif15minOMenor=max(maxDifEnero,maxDifJulio)

%Error al pasar de 2hs a 4hs
error2a4AbsEnero=abs(QpromedioVec(13)-QpromedioVec(15));
error2a4AbsJulio=abs(QpromedioVec(14)-QpromedioVec(16));
maxErrorAbs2a4=max(error2a4AbsEnero,error2a4AbsJulio)
maxErrorPorcentual2a4=100*max(error2a4AbsEnero/QpromedioVec(13),error2a4AbsJulio/QpromedioVec(14))