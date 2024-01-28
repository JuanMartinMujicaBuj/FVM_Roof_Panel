clear all, close all, clc
%Script que toma datos obtenidos del solver principal para obtener gráficos
%para el informe. Análisis de potencia en función de Tin para varios meses.

load('resultados_principales.mat');

% Ordenamos los datos
QrefrigeracionVec(QrefrigeracionVec<0) = 0;
QcalefaccionVec(QcalefaccionVec<0) = 0;
nroMesMat = reshape(nroMesVec,17,12)';
TinMat = reshape(TinVec,17,12)';
QpromedioMat = reshape(QpromedioVec,17,12)';
QrefrigeracionMat = reshape(QrefrigeracionVec,17,12)';
QcalefaccionMat = reshape(QcalefaccionVec,17,12)';

meses = {'Enero','Febrero','Marzo','Abril','Mayo','Junio',...
         'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'};

% Plots
% Gráficos separados (grafica QPromedio Qcalefaccion y Qrefrigeracion en
% función de TIn para todos los meses)
% En subplot
% for i = 1:12
%     subplot(6,2,i)
%     plot(TinMat(i,:),QpromedioMat(i,:)); hold on
%     plot(TinMat(i,:),QcalefaccionMat(i,:));
%     plot(TinMat(i,:),QrefrigeracionMat(i,:)); grid on
%     title(meses{i},'interpreter','latex');
%     legend({'Promedio','Calefacci\''on','Refrigeraci\''on'},'interpreter','latex');
%     xlabel('Temperatura interior [$^{\circ}$C]','interpreter','latex');
%     ylabel('Flujo de calor [W/m]','interpreter','latex');
%     ax=gca; ax.TickLabelInterpreter='latex';
% end
figure
vecLoc={'NorthEast','NorthEast','NorthEast','NorthWest','NorthWest','NorthWest',...
    'NorthWest','NorthWest','NorthWest','NorthWest','NorthWest','NorthWest'};
for i = 1:12
    subplot(4,3,i) % idem anteior con otra disposición de subplot
    plot(TinMat(i,:),QpromedioMat(i,:)); hold on
    plot(TinMat(i,:),QcalefaccionMat(i,:),'--');
    plot(TinMat(i,:),QrefrigeracionMat(i,:),'--'); grid on
    title(meses{i},'interpreter','latex');
    legend({'Promedio','M\''ax. calefacci\''on','M\''ax. refrigeraci\''on'},'interpreter','latex','FontSize',7,'Location',vecLoc{i});
    xlabel('Temperatura interior [$^{\circ}$C]','interpreter','latex','FontSize',8);
    ylabel('Potencia [W]','interpreter','latex','FontSize',8);
    ax=gca; ax.TickLabelInterpreter='latex';
    axis([15 30 -0.1 4.1095])
end

% Busco temperatura que da menor consumo promedio
QPROMEDIO = mean(QpromedioMat,1); % promedio de potencia de todos los meses para cada Tin
T_optima1 = TinMat(1,find(QPROMEDIO==min(QPROMEDIO)));
QTOTAL = sum(QpromedioMat,1);
T_optima2 = TinMat(1,find(QTOTAL==min(QTOTAL)));


% Cada uno en su figure (grafica lo mismo que el subplot anterior pero cada
% caso en una nueva figura) 
% for i = 1:12
%     figure
%     plot(TinMat(i,:),QpromedioMat(i,:),'Color',[0 0.4470 0.7410],'Marker','*'); hold on
%     plot(TinMat(i,:),QcalefaccionMat(i,:),'Color',[0.8500 0.3250 0.0980]);
%     plot(TinMat(i,:),QrefrigeracionMat(i,:),'Color',[0.3010 0.7450 0.9330]); grid on
%     title(meses{i},'interpreter','latex');
%     legend({'Promedio','M\''ax. calefacci\''on','M\''ax. refrigeraci\''on'},'interpreter','latex');
%     xlabel('Temperatura interior [$^{\circ}$C]','interpreter','latex');
%     ylabel('Flujo de calor [W/m]','interpreter','latex');
%     ax=gca; ax.TickLabelInterpreter='latex';
% end

% % Gráficos juntos (grafica lo mismo que los subplots pero todos los meses
% % en una misma figuta)
% figure
% for i = 1:12
%     plot(TinMat(i,:),QpromedioMat(i,:)); hold on
% end
% legend(meses,'interpreter','latex'); grid on
% title('Flujos de calor en funci\''on de la temperatura interior','interpreter','latex');
% legend({'Promedio','Calefacci\''on','Refrigeraci\''on'},'interpreter','latex');
% xlabel('Temperatura interior [$^{\circ}$C]','interpreter','latex');
% ylabel('Flujo de calor [W/m]','interpreter','latex');
% ax=gca; ax.TickLabelInterpreter='latex';


% Por estación (idem anterior separado por estación)
% figure; lgd = [];
% for i = [12 1 2]
%     plot(TinMat(i,:),QpromedioMat(i,:)); hold on
%     title('Flujo de calor en los meses de verano','interpreter','latex');
%     lgd = [lgd meses(i)]; grid on
%     xlabel('Temperatura interior [$^{\circ}$C]','interpreter','latex');
%     ylabel('Flujo de calor [W/m]','interpreter','latex');
%     ax=gca; ax.TickLabelInterpreter='latex';
% end
% legend(lgd,'interpreter','latex');
% 
% figure; lgd = [];
% for i = [3 4 5]
%     plot(TinMat(i,:),QpromedioMat(i,:)); hold on
%     title('Flujo de calor en los meses de oto$\tilde{n}$o','interpreter','latex');
%     lgd = [lgd meses(i)]; grid on
%     xlabel('Temperatura interior [$^{\circ}$C]','interpreter','latex');
%     ylabel('Flujo de calor [W/m]','interpreter','latex');
%     ax=gca; ax.TickLabelInterpreter='latex';
% end
% legend(lgd,'interpreter','latex');
% 
% figure; lgd = [];
% for i = [6 7 8]
%     plot(TinMat(i,:),QpromedioMat(i,:)); hold on
%     title('Flujo de calor en los meses de invierno','interpreter','latex');
%     lgd = [lgd meses(i)]; grid on
%     xlabel('Temperatura interior [$^{\circ}$C]','interpreter','latex');
%     ylabel('Flujo de calor [W/m]','interpreter','latex');
%     ax=gca; ax.TickLabelInterpreter='latex';
% end
% legend(lgd,'interpreter','latex');
% 
% figure; lgd = [];
% for i = [9 10 11]
%     plot(TinMat(i,:),QpromedioMat(i,:)); hold on
%     title('Flujo de calor en los meses de verano','interpreter','latex');
%     lgd = [lgd meses(i)]; grid on
%     xlabel('Temperatura interior [$^{\circ}$C]','interpreter','latex');
%     ylabel('Flujo de calor [W/m]','interpreter','latex');
%     ax=gca; ax.TickLabelInterpreter='latex';
% end
% legend(lgd,'interpreter','latex');