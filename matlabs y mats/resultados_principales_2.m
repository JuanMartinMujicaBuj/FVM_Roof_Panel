clear all, close all, clc
%Script que usa resultados del solver principal para obtener gráficos para
%el informe
load('resultados_principales_2.mat');

% Curva de 4 días para mostrar estabilización
% figure
% subplot(2,1,1)
% plot([15/60:15/60:24*4]/24,todos_QTot_norteMat{1},[15/60:15/60:24*4]/24,todos_QTot_surMat{1},...
%      [15/60:15/60:24*4]/24,todos_QAlmMat{1}); grid on
% legend({'Flujo cara norte','Flujo cara sur','Calor almacenado'},'interpreter','latex');
% title('Flujos de calor y calor almacenado a lo largo de cuatro d\''ias en enero','interpreter','latex');
% xlabel('D\''ias','interpreter','latex');
% ylabel('Flujos de calor y calor almacenado [W/m]','interpreter','latex');
% ax=gca; ax.TickLabelInterpreter='latex';
% subplot(2,1,2)
% plot([15/60:15/60:24*4]/24,todos_QTot_norteMat{2},[15/60:15/60:24*4]/24,todos_QTot_surMat{2},...
%      [15/60:15/60:24*4]/24,todos_QAlmMat{2}); grid on
% legend({'Flujo cara norte','Flujo cara sur','Calor almacenado'},'interpreter','latex');
% title('Flujos de calor y calor almacenado a lo largo de cuatro d\''ias en julio','interpreter','latex');
% xlabel('D\''ias','interpreter','latex');
% ylabel('Flujos de calor y calor almacenado [W/m]','interpreter','latex');
% ax=gca; ax.TickLabelInterpreter='latex';

% Curva de 1 día para mostrar conservación
% figure
% subplot(2,1,1)
% plot([0:15/60:24],QTot_norteMat{1}+QTot_surMat{1},'bo-',...
%      [0:15/60:24],todos_QAlmMat{1}(3*length(todos_QAlmMat{1})/4:end),'r*-');
% title('Suma de flujos de calor de las caras norte y sur y calor almacenado en un d\''ia de enero','interpreter','latex');
% legend({'Flujo cara sur + flujo cara norte','Calor almacenado'},'interpreter','latex');
% xlabel('Horas del d\''ia [hs]','interpreter','latex'); grid on
% ylabel('Flujos de calor sumados y calor almacenado','interpreter','latex');
% ax=gca; ax.TickLabelInterpreter='latex';
% subplot(2,1,2)
% plot([0:15/60:24],QTot_norteMat{2}+QTot_surMat{2},'bo-',...
%      [0:15/60:24],todos_QAlmMat{2}(3*length(todos_QAlmMat{2})/4:end),'r*-');
% title('Suma de flujos de calor de las caras norte y sur y calor almacenado en un d\''ia de julio','interpreter','latex');
% legend({'Flujo cara sur + flujo cara norte','Calor almacenado'},'interpreter','latex');
% xlabel('Horas del d\''ia [hs]','interpreter','latex'); grid on
% ylabel('Flujos de calor sumados y calor almacenado','interpreter','latex');
% ax=gca; ax.TickLabelInterpreter='latex';

%Plots de flujo de calor por la cara norte, por la cara sur, y calor
%almacenado (derivada temporal de la energía) a lo largo de 4 días
%Enero
figure
subplot(2,2,1)
plot([15/60/24:15/60/24:4],todos_QAlmMat{1}(:),...
    'Color',[0.8500 0.3250 0.0980],'LineStyle','--');
hold on;
plot([15/60/24:15/60/24:4],todos_QTot_norteMat{1},'Color',[0 0.4470 0.7410]);
plot([15/60/24:15/60/24:4],todos_QTot_surMat{1},'Color',[0.9290 0.6940 0.1250]);
plot([0 4],[0 0],'k--');
patch([3 4 4 3],[-7 -7 8 8],[73, 201, 107]/256,'FaceAlpha',0.15,'EdgeColor','none');
title('Enero - $T_{in}$=22,5$^{\circ}$C','interpreter','latex');
legend({'Calor almacenado','Flujo cara norte','Flujo cara sur'},...
    'interpreter','latex','Location','best','Orientation','horizontal');
xlabel('D\''ias','interpreter','latex'); grid on
ylabel('Potencia [W]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';
axis([0 4 -7 8])

%Julio
subplot(2,2,3)
plot([15/60/24:15/60/24:4],todos_QAlmMat{2}(:),...
    'Color',[0.8500 0.3250 0.0980],'LineStyle','--');
hold on;
plot([15/60/24:15/60/24:4],todos_QTot_norteMat{2},'Color',[0 0.4470 0.7410]);
plot([15/60/24:15/60/24:4],todos_QTot_surMat{2},'Color',[0.9290 0.6940 0.1250]);
plot([0 4],[0 0],'k--');
patch([3 4 4 3],[-7 -7 8 8],[73, 201, 107]/256,'FaceAlpha',0.15,'EdgeColor','none');
title('Julio - $T_{in}$=22,5$^{\circ}$C','interpreter','latex');
legend({'Calor almacenado','Flujo cara norte','Flujo cara sur'},...
    'interpreter','latex','Location','best','Orientation','horizontal');
xlabel('D\''ias','interpreter','latex'); grid on
ylabel('Potencia [W]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';
axis([0 4 -7 8])

%Plots de flujo norte + flujo sur, y calor almacenado. Verificación de la
%conservación de la energía.
%Enero
subplot(2,2,2)
plot([0:15/60:24],QTot_norteMat{1}+QTot_surMat{1},'Color',[0 0.4470 0.7410]);
hold on;
plot([0:15/60:24],todos_QAlmMat{1}(3*length(todos_QAlmMat{1})/4:end),...
    'Color',[0.8500 0.3250 0.0980],'Marker','o','MarkerSize',5,'LineStyle','none');
plot([0 24],[0 0],'k--');
title('Enero - $T_{in}$=22,5$^{\circ}$C','interpreter','latex');
legend({'Flujos caras sur + norte','Calor almacenado'},'interpreter','latex','Location','best');
xlabel('Horas del $4^{to}$ d\''ia','interpreter','latex'); grid on
ylabel('Potencia [W]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';
axis([0 24 -7.2 6.7])

%Julio
subplot(2,2,4)
plot([0:15/60:24],QTot_norteMat{2}+QTot_surMat{2},'Color',[0 0.4470 0.7410]);
hold on;
plot([0:15/60:24],todos_QAlmMat{2}(3*length(todos_QAlmMat{2})/4:end),...
    'Color',[0.8500 0.3250 0.0980],'Marker','o','MarkerSize',5,'LineStyle','none');
plot([0 24],[0 0],'k--');
title('Julio - $T_{in}$=22,5$^{\circ}$C','interpreter','latex');
legend({'Flujos caras sur + norte','Calor almacenado'},'interpreter','latex','Location','best');
xlabel('Horas del $4^{to}$ d\''ia','interpreter','latex'); grid on
ylabel('Potencia [W]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';
axis([0 24 -7.2 6.7])



% Cálculo del error
error = max(abs([QTot_norteMat{1}+QTot_surMat{1}-todos_QAlmMat{1}(3*length(todos_QAlmMat{1})/4:end)...
                 QTot_norteMat{2}+QTot_surMat{2}-todos_QAlmMat{2}(3*length(todos_QAlmMat{2})/4:end) ]));