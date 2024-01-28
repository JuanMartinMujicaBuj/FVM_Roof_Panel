%Script que llama a la función get_curva_rad_y_temp para obtener gráficos
%para el informe
clc,clear,close all
[out_curvaRad,out_curvaTemp] = get_curva_rad_y_temp('curvaTipoAvg',900);
figure
subplot(1,3,1)
%Plots de curva de temperatura de cada mes, a lo largo del día
for i=1:2:12
    if i==1 || i==7
        plot(linspace(0,24,length(out_curvaTemp(1,:))+1),[out_curvaTemp(i,end) out_curvaTemp(i,:)]-273); hold on
    else
        plot(linspace(0,24,length(out_curvaTemp(1,:))+1),[out_curvaTemp(i,end) out_curvaTemp(i,:)]-273,'--'); hold on
    end
end
axis([0 24 7 33])
legend({'Enero','Marzo','Mayo','Julio','Septiembre','Noviembre'},'interpreter','latex');
grid on
title({'Temperatura exterior a lo largo del d\''ia -','distintos meses'},'interpreter','latex');
xlabel('Horas del d\''ia','interpreter','latex');
ylabel('$T_{out}$ [$^{\circ}$C]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';

subplot(1,3,2)
%Plots de curvas de radiación para cada mes, a lo largo del día
for i=1:2:12
    if i==1 || i==7
        plot(linspace(0,24,length(out_curvaRad(1,:))+1),[out_curvaRad(i,end) out_curvaRad(i,:)]); hold on
    else
        plot(linspace(0,24,length(out_curvaRad(1,:))+1),[out_curvaRad(i,end) out_curvaRad(i,:)],'--'); hold on
    end
end
axis([0 24 -10 800])
legend({'Enero','Marzo','Mayo','Julio','Septiembre','Noviembre'},'interpreter','latex');
grid on
title({'Radiaci\''on solar a lo largo del d\''ia -','distintos meses'},'interpreter','latex');
xlabel('Horas del d\''ia','interpreter','latex');
ylabel('$q_{Sol}$ [$W/m^2$]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';

subplot(1,3,3)
%Plots de curvas de radiación en enero, para distintas condiciones de
%nubosidad, a lo largo del día
for i=[6 4 2 1]
        [out_curvaRad,~] = get_curva_rad_y_temp(['curvaTipo' num2str(i)],900);
        plot(linspace(0,24,length(out_curvaRad(1,:))+1),[out_curvaRad(1,end) out_curvaRad(1,:)]); hold on       
end
axis([0 24 -10 1000])
legend({'Despejado','Ma$\tilde{n}$ana nublada','Tarde nublada','D\''ia nublado'},'interpreter','latex');
grid on
title({'Radiaci\''on solar a lo largo del d\''ia -','enero - nubosidad variable'},'interpreter','latex');
xlabel('Horas del d\''ia','interpreter','latex');
ylabel('$q_{Sol}$ [$W/m^2$]','interpreter','latex');
ax=gca; ax.TickLabelInterpreter='latex';
