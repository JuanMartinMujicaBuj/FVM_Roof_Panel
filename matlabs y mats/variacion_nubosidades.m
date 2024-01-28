close all, clear all, clc
%Script que toma datos obtenidos del solver principal para obtener gráficos
%para el informe. Análisis de variación de estados de nubosidad.
load('variacion_nubosidades.mat');
nombres = {'Despejado','Nubosidad en la ma$\tilde{n}$ana','Nubosidad en el mediod\''ia',...
           'Nubosidad en la tarde','Nubosidad en todo el d\''ia'}; % estados de nubosidad en el orden de interés
numerosCurva = [6 4 7 2 1]; % las curvaTipo de interés en el orden de interés

figure
% plot([0:1/4:24],QTot_surMat(7,:),...
%      [0:1/4:24],QTot_surMat(5,:),...
%      [0:1/4:24],QTot_surMat(9,:),...
%      [0:1/4:24],QTot_surMat(3,:),...
%      [0:1/4:24],QTot_surMat(1,:)); hold on

% Grafica la potencia cara norte durante las horas del día para distintas
% nubosidades en enero
for i = 1:5
    subplot(2,5,i)
    plot([0:1/4:24],QTot_norteMat{2*numerosCurva(i)-1}(:),'Color',[0.8500 0.3250 0.0980]); hold on
    plot([0:1/4:24],zeros(1,length([0:1/4:24])),'k--');
    title({nombres{i},'Enero - $T_{in}$=22.5$^{\circ}$C'},'interpreter','latex');
    xlabel('Horas del d\''ia','interpreter','latex'); grid on
    ylabel('Potencia cara norte [W]','interpreter','latex');
    ax=gca; ax.TickLabelInterpreter='latex';
    axis([0 24 -12 12]);
end
% Grafica la potencia cara norte durante las horas del día para distintas
% nubosidades en julio
for i = 1:5
    subplot(2,5,i+5)
    plot([0:1/4:24],QTot_norteMat{2*numerosCurva(i)}(:),'Color',[0 0.4470 0.7410]); hold on
    plot([0:1/4:24],zeros(1,length([0:1/4:24])),'k--');
    title({nombres{i},'Julio - $T_{in}$=22.5$^{\circ}$C'},'interpreter','latex');
    xlabel('Horas del d\''ia','interpreter','latex'); grid on
    ylabel('Potencia cara norte [W]','interpreter','latex');
    ax=gca; ax.TickLabelInterpreter='latex';
    axis([0 24 -12 12]);
end

% idem anterior pero lo grafica en una misma figura, en lugar de un subplot
% plot([0:1/4:24],QTot_surMat(8,:),...
%      [0:1/4:24],QTot_surMat(6,:),...
%      [0:1/4:24],QTot_surMat(10,:),...
%      [0:1/4:24],QTot_surMat(4,:),...
%      [0:1/4:24],QTot_surMat(2,:)); hold on
% plot([0:1/4:24],QTot_norteMat(8,:),...
%      [0:1/4:24],QTot_norteMat(6,:),...
%      [0:1/4:24],QTot_norteMat(10,:),...
%      [0:1/4:24],QTot_norteMat(4,:),...
%      [0:1/4:24],QTot_norteMat(2,:));
% legend({'Despejado','Nubosidad en la ma$\tilde{n}$ana','Nubosidad en el mediod\''ia',...
%     'Nubosidad en la tarde','Nubosidad en todo el d\''ia'},'interpreter','latex');
% title('Flujo dalor a trav\''es de la cara norte durante un d\''ia de julio','interpreter','latex');
% xlabel('Horas del d\''ia [hs]','interpreter','latex'); grid on
% ylabel('Flujo de calor por la cara norte [W/m]','interpreter','latex');
% ax=gca; ax.TickLabelInterpreter='latex';

% Grafica calor promedio, de refrigeración y calefacción para distintas
% condiciones de nubosidad en enero
figure
subplot(2,1,1)
plot(QpromedioVec(1:2:9),'g*-'); hold on
plot(QrefrigeracionVec(1:2:9),'b*-'); grid on
plot(QcalefaccionVec(1:2:9),'r*-'); 
ax=gca; ax.TickLabelInterpreter='latex';
set(gca,'xtick',[1:5],'xticklabel',nombres);
legend({'Calor promedio','Calor de refrigeraci\''on','Calor de calefacci\''on'},'interpreter','latex');
title('Flujos de calor para distintas condiciones clim\''aticas en enero','interpreter','latex');
ylabel('Flujo de calor [W/m]','interpreter','latex');

% Grafica calor promedio, de refrigeración y calefacción para distintas
% condiciones de nubosidad en julio
subplot(2,1,2)
plot(QpromedioVec(2:2:10),'g*-'); hold on
plot(QrefrigeracionVec(2:2:10),'b*-'); grid on
plot(QcalefaccionVec(2:2:10),'r*-'); 
ax=gca; ax.TickLabelInterpreter='latex';
set(gca,'xtick',[1:5],'xticklabel',nombres);
legend({'Calor promedio','Calor de refrigeraci\''on','Calor de calefacci\''on'},'interpreter','latex');
title('Flujos de calor para distintas condiciones clim\''aticas en julio','interpreter','latex');
ylabel('Flujo de calor [W/m]','interpreter','latex');