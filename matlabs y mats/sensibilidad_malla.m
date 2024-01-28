close all
%Script que toma datos obtenidos del solver principal para obtener gráficos
%para el informe. Análisis de sensibilidad espacial de malla.
load('sensibilidad_malla_a225grados.mat');

% Ordenamos los datos
QrefrigeracionVec(QrefrigeracionVec<0) = 0;
QcalefaccionVec(QcalefaccionVec<0) = 0;

%Plot de potencia vs nro de elementos - enero
figure
subplot(2,1,1)
plot(nelVec(5),QpromedioVec(5),'g*'); hold on
plot(nelVec(1:2:19),QpromedioVec(1:2:19),'Color',[0.8500 0.3250 0.0980],'Marker','*'); %en 22.5°C
plot(nelVec(5),QpromedioVec(5),'g*');
legend({'Nro. de elementos elegido'},'interpreter','latex');
title('Potencia promedio vs n\''umero de elementos - enero - $T_{in}$=22.5$^{\circ}$C','interpreter','latex'); grid on
xlabel('Cantidad de elementos','interpreter','latex');
ylabel('Potencia [W]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';
axis([0 11000 0.7535 0.7539])

%Plot de potencia vs nro de elementos - julio
subplot(2,1,2)
plot(nelVec(6),QpromedioVec(6),'g*'); hold on
plot(nelVec(2:2:20),QpromedioVec(2:2:20),'Color',[0 0.4470 0.7410],'Marker','*'); %en 22.5°C
plot(nelVec(6),QpromedioVec(6),'g*');
legend({'Nro. de elementos elegido'},'interpreter','latex');
title('Potencia promedio vs n\''umero de elementos - julio - $T_{in}$=22.5$^{\circ}$C','interpreter','latex'); grid on
xlabel('Cantidad de elementos','interpreter','latex');
ylabel('Potencia [W]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';
axis([0 11000 1.80183 1.8034])
clear all
load('sensibilidad_malla_todastemps.mat');

nelMat = reshape(nelVec,16,12)';
nroMesMat = reshape(nroMesVec,16,12)';
TinMat = reshape(TinVec,16,12)';
QpromedioMat = reshape(QpromedioVec,16,12)';
QrefrigeracionMat = reshape(QrefrigeracionVec,16,12)';
QcalefaccionMat = reshape(QcalefaccionVec,16,12)';

% Plots de las curvas de potencia a lo largo del día, para c/u de las
% distintas mallas (con más o menos elementos). Enero
figure
for i = 1:2:11
    plot(TinMat(i,:),QpromedioMat(i,:),'*-'); hold on
    plot(TinMat(i,:),QrefrigeracionMat(i,:),'o-'); hold on
    plot(TinMat(i,:),QcalefaccionMat(i,:),'--'); hold on
    title('Flujo de calor en funci\''on de Tin para enero','interpreter','latex'); grid on
end
legend({'Q promedio','Q refrigeraci\''on','Q calefacci\''on'},'interpreter','latex');
xlabel('Temperatura interior [$^{\circ}$C]','interpreter','latex');
ylabel('Flujo de calor [W/m]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';

% Plots de las curvas de potencia a lo largo del día, para c/u de las
% distintas mallas (con más o menos elementos). Julio
figure
for i = 2:2:12
    plot(TinMat(i,:),QpromedioMat(i,:),'*-'); hold on
    plot(TinMat(i,:),QrefrigeracionMat(i,:),'o-'); hold on
    plot(TinMat(i,:),QcalefaccionMat(i,:),'--'); hold on
    title('Flujo de calor en funci\''on de Tin para julio','interpreter','latex'); grid on
    
end
legend({'Q promedio','Q refrigeraci\''on','Q calefacci\''on'},'interpreter','latex');
xlabel('Temperatura interior [$^{\circ}$C]','interpreter','latex');
ylabel('Flujo de calor [W/m]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';


% Cálculo de error, absoluto y relativo
for j = 1:12
    errorQpromedioEnero(j) = abs(max(QpromedioMat(1:2:11,j))-min(QpromedioMat(1:2:11,j)));
    errorQrefrigeracionEnero(j) = abs(max(QrefrigeracionMat(1:2:11,j))-min(QrefrigeracionMat(1:2:11,j)));
    errorQcalefaccionEnero(j) = abs(max(QcalefaccionMat(1:2:11,j))-min(QcalefaccionMat(1:2:11,j)));
end
errorQpromedioEnero = max(errorQpromedioEnero);
errorQrefrigeracionEnero = max(errorQrefrigeracionEnero);
errorQcalefaccionEnero = max(errorQcalefaccionEnero);
for j = 1:12
    errorQpromedioJulio(j) = abs(max(QpromedioMat(2:2:12,j))-min(QpromedioMat(2:2:12,j)));
    errorQrefrigeracionJulio(j) = abs(max(QrefrigeracionMat(2:2:12,j))-min(QrefrigeracionMat(2:2:12,j)));
    errorQcalefaccionJulio(j) = abs(max(QcalefaccionMat(2:2:12,j))-min(QcalefaccionMat(2:2:12,j)));
end
errorQpromedioJulio = max(errorQpromedioJulio);
errorQrefrigeracionJulio = max(errorQrefrigeracionJulio);
errorQcalefaccionJulio = max(errorQcalefaccionJulio);

peorError = max([errorQpromedioEnero;errorQrefrigeracionEnero;errorQcalefaccionEnero;
                errorQpromedioJulio;errorQrefrigeracionJulio;errorQcalefaccionJulio]);