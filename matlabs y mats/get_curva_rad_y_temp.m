function [out_curvaRad,out_curvaTemp] = get_curva_rad_y_temp(in_curvaTipo,dt)

plotsRad=0; %por si se quieren ver los inputs al modelo, se puede graficar la curva de radiación y/o temperatura
plotsTemp=0;
%% Radiación
% Crea un vector de potencias de radiación cada 15 min, para las 24hs de un
% día, a partir de la radiación media durante las horas de Sol, y una curva
% "típica" de radiación a lo largo del día. sunrise, sunset: horas
% a las que sale y se pone el Sol. MeanRadVec: radiación promedio en ese
% mes. curvaTipoN: N ejemplos de curvas típicas, con y sin nubosidad.
%Output: out_curvaRad. curvaRad(i,:) tiene las radiaciones cada cuarto de hora
%del mes i-ésimo.

curvaTipo1 = [10 59 107 151 188 215 238 234 273 394 223 129 82 34]; %nubosidad esparcida en todo el dia
curvaTipo2 = [10 160 397 470 525 603 348 235 228 240 188 272 93 56]; %nubosidad tarde
curvaTipo3= [10 160 397 400 184 603 348 235 228 240 188 272 93 56]; %nubosidad mañana y tarde
curvaTipo4 = [30 215 317 149 432 678 844 902 893 822 699 540 357 163]; %nubosidad mañana 1
curvaTipo5 = [0 49 98 143 181 211 229 425 559 616 667 555 377 182]; %nubosidad mañana 2
curvaTipo6 = [32 227 419 596 745 857 923 940 906 823 697 537 354 159]; %sin nubosidad
curvaTipo7 = [4 124 248 552 362 409 229 240 353 412 374 308 217 128]; %nubosidad al mediodia
curvaTipoAvg=([17 211 404 582 734 849 920 941 911 831 679 538 277 145]+...
             [15 209 402 579 729 848 919 941 911 832 710 553 371 177]+...
             [13 172 400 579 732 848 919 937 911 833 688 537 318 137]+...
             [10 160 397 400 184 603 348 235 228 240 188 272 93 56]+...
             [4 124 248 552 362 409 229 240 353 412 374 308 217 128]+...
             [6 201 394 574 727 844 917 937 890 762 639 487 319 156]+...
             [4 198 392 572 726 843 916 940 912 835 700 450 94 45])/7;

%Usamos curvaTipoAvg para todo el trabajo, y curvaTipo1
%(nubosidad esparcida en todo el día), curvaTipo2 (nubosidad por la tarde),
%curvaTipo5 (nubosidad por la mañana), curvaTipo6 (despejado) y curvaTipo7
%(nubosidad al mediodía), para análisis de calidad.

hsSolCurvaTipo = 6:19;

curvaTipo=eval(in_curvaTipo);

%radiación promedio por mes, de enero a diciembre
meanRadVec=[479.651 437.888 417.799 349.834 272.176 246.511 239.899 313.467 367.647 429.707 468.474 486.063];
%sunrise: 5:58 6:30 7:00 7:26 7:53 8:11 8:08 7:40 6:57 6:12 5:40 5:35
%sunset: 20:20 19:56 19:16 18:32 17:59 19:00 18:02 18:26 18:51 19:18 19:49 20:16
sunriseVec=[6 6.5 7 7.5 8 8.25 8.25 7.75 7 6.25 5.75 5.5];
sunsetVec=[20.25 20 19.25 18.5 18 17.75 18 18.5 18.75 19.25 19.75 20.25];

paso=1/4; %dt/3600; %en hs
curvaRad=zeros(13,24/paso); %un valor cada dt

for i=1:12 %enero a diciembre + caso promedio
    meanRad=meanRadVec(i); %W/m2
    sunrise=sunriseVec(i);
    sunset=sunsetVec(i);

    %hsDeSol = sunrise:paso:sunset;
    curvaTipoTransformada = meanRad*curvaTipo/mean(curvaTipoAvg);
    curvaRad(i,round(sunrise/paso):round(sunset/paso))=interp1(1:length(curvaTipo),curvaTipoTransformada,linspace(1,length(curvaTipo),length(round(sunrise/paso):round(sunset/paso))),'splines');

    %plots
    if plotsRad==1
        curvaOriginal=zeros(1,24); curvaOriginal(hsSolCurvaTipo)=curvaTipo;
        figure, plot(1:24,curvaOriginal,'r',(1:length(curvaRad(i,:)))*paso,curvaRad(i,:),'b');
        hold on
        title(['mes nro ' num2str(i)]);
    end
end
curvaRad(13,:)=sum(curvaRad(1:12,:))/12; %Caso promedio de los 12 meses. Finalmente no fue usado en el informe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Temperatura
% Crea un vector de temperaturas cada 15 min, para las 24hs de un
% día, a partir de las temperaturas máxima y mínima promedio por mes, y una
% curva "típica" de temperatura a lo largo del día.
% curvaTempN: pronóstico de temperaturas a lo largo de una semana, usadas
% para obtener la curva "típica" de temperatura.
% Output: out_curvaTemp. curvaTemp(i,:) tiene las temperaturas cada cuarto de
% hora del mes i-ésimo.

%horas: 20, 23 (del día anterior), 2, 5, 8, 11, 14, 17, 20, 23, 2 (del día siguiente), 5
hs=[-4 -1 2 5 8 11 14 17 20 23 26 29];
curvaTemp1 = [25 25 23 23 24 26 27 27 25 25 23 23];
curvaTemp2 = [28 27 25 24 25 29 32 31 28 27 25 24];
curvaTemp3 = [29 29 27 26 27 31 33 32 29 29 27 26];
curvaTemp4 = [29 27 28 27 28 31 32 32 29 27 28 27];
curvaTemp5 = [26 25 24 23 24 27 28 28 26 25 24 23];
curvaTemp6 = [27 25 24 24 26 28 30 29 27 25 24 24];
curvaTemp7 = [27 26 24 24 25 28 29 30 27 26 24 24];
curvaTempAvg = (curvaTemp1+curvaTemp2+curvaTemp3+curvaTemp4+curvaTemp5+...
                curvaTemp6+curvaTemp7)/7;
% curvaTempAvgSplines = interp1(hs,curvaTempAvg,paso:paso:24,'splines');
curvaTempAvgInterp = interp1(hs,curvaTempAvg,paso:paso:24,'makima');
% figure,plot(0:paso:24,curvaTempAvgMak,'b*-',0:paso:24,curvaTempAvgSplines,'go-',hs,curvaTempAvg,'r');
%Optamos por la interpolación 'makima'.
if plotsTemp==1
    figure,plot(paso:paso:24,curvaTempAvgInterp,'b*-',hs,curvaTempAvg,'r');
end
minCurvaTempAvg=min(curvaTempAvgInterp);
maxCurvaTempAvg=max(curvaTempAvgInterp);
meanCurvaTempAvg=mean(curvaTempAvgInterp);

%Enero a diciembre
minTempVec=[20.1 19.2 17.7 13.8 10.7 8.1 7.4 8.8 10.3 13.3 15.9 18.4];
maxTempVec=[30.1 28.7 26.8 22.9 19.3 16 15.3 17.7 19.3 22.7 25.6 28.5];
meanTempVec=0.5*(minTempVec+maxTempVec);

for i=1:12 %enero a diciembre + caso promedio
    meanTemp=meanTempVec(i); %°C
    minTemp=minTempVec(i);
    maxTemp=maxTempVec(i);
        
    curvaTemp(i,:) = (curvaTempAvgInterp-meanCurvaTempAvg)*(maxTemp-minTemp)/(maxCurvaTempAvg-minCurvaTempAvg)+meanTemp;

    %plots
    if plotsTemp==1
        figure
        plot(paso:paso:24,curvaTempAvgInterp,'r-',paso:paso:24,curvaTemp(i,:),'b*');
        hold on
        title(['mes nro ' num2str(i)]);
    end
end
curvaTemp(13,:)=sum(curvaTemp(1:12,:))/12; %Caso promedio de los 12 meses. Finalmente no fue usado en el informe
curvaTemp=curvaTemp+273; %grados celsius a grados kelvin

out_curvaRad = curvaRad;
out_curvaTemp = curvaTemp;
end