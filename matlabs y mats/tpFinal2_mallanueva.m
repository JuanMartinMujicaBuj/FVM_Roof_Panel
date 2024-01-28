clear all, close all, clc
tic

% Vectores a completar con datos útiles para plots
QpromedioVec = [];
QcalefaccionVec = [];
QrefrigeracionVec = [];
nelVec = [];
nroMesVec = [];
TinVec = [];
dtVec = [];
% hMetalVec = [];
% hYesoVec = [];
% hMAVec = [];
% bMaderaVec = [];
% bMitadAislanteVec = [];
% dts=60*[1 5 10 15 30 60 120 240 360]; % [s] 9 casos
% curvaTipoCell = [];
QTot_norteMat = [];
QTot_surMat = [];
todos_QTot_norteMat = [];
todos_QTot_surMat = [];
todos_QAlmMat = [];

%Loops de iteraciones, para correr varios casos a la vez (ej: variando la
%temperatura interior, o variando el mes)
for i_caso = 1
    for nroMes = [1 7]
        for Tin = 22.5+273 
            dt =900;
%             dt = dts(i_caso); %usado en loops de iteración
            caseManager_mallanueva;
            nelVec = [nelVec nel];
            nroMesVec = [nroMesVec nroMes];
            TinVec = [TinVec Tin-273];
            dtVec = [dtVec dt];
%             curvaTipoCell = [curvaTipoCell {curvaTipo}];
%             hMetalVec = [hMetalVec h(3)];
%             hYesoVec = [hYesoVec h(1)];
%             hMAVec = [hMAVec h(2)];
%             bMaderaVec = [bMaderaVec b(2)];
%             bMitadAislanteVec = [bMitadAislanteVec b(1)]; % si pongo b(3) es lo mismo

            %% Creación de las matrices A y B para resolver T(t) = A\(B-A0*T(t-1))
            Tout=curvaTemp(nroMes,1); %[K], Tout inicial
            T=ones(nel,1)*(Tin+Tout)/2; %Tinicial
            A = sparse(nel,nel);
            A0 = sparse(nel,nel);
            B = sparse(nel,1);

            %Para chequear que se esten tomando los i,j correctos: correr lo de arriba,
            %luego:
            % plot(x_centros(i),y_centros(j),'o'); y ver que se pinten los
            % nodos indicados

            % Llenado de A, A0 y B - distintas regiones de la malla:
            % Elementos internos yeso (1)
            % Elementos internos madera (2)
            % Elementos internos aislante (3)
            % Elementos internos metal (4)
            % Elementos interfaz yeso-madera (5)
            % Elementos interfaz yeso-aislante (6)
            % Elementos interfaz metal-madera (7)
            % Elementos interfaz metal-aislante (8)
            % Elementos interfaz madera-aislante (9)
            % Elementos cara yeso-sur(10)
            % Elementos cara metal-norte(11)
            % Elementos cara yeso-oeste (12)
            % Elementos cara aislante-oeste (13)
            % Elementos cara metal-oeste (14)
            % Elementos cara yeso-este (15)
            % Elementos cara aislante-este (16)
            % Elementos cara metal-este (17)
            % Elementos interfaz yeso-madera-aislante (18)
            % Elementos interfaz metal-madera-aislante (19)
            % Elemento cara yeso-aislante-oeste (20)
            % Elemento cara aislante-metal-oeste (21)
            % Elemento cara yeso-aislante-este (22)
            % Elemento cara aislante-metal-este (23)
            % Elemento vertice yeso-sudoeste (24)
            % Elemento vertice yeso-sudeste (25)
            % Elemento vertice metal-noroeste (26)
            % Elemento vertice metal-noreste (27)

            if plotT>0
                surfTemp = figure;
                set(surfTemp, 'WindowStyle', 'Docked');
            end

            [X,Y]=meshgrid(x_centros,y_centros);

            hin=ones(totNelInLength,1)*0.25; %hasta que codeemos el como iterarla
            TmatrizPrev=reshape(T,totNelInHeight,totNelInLength);
            time=zeros(1,length(1:3600*24*(diasEstabilizacion+1)/dt));
            Temp=zeros(nel,length(1:3600*24*(diasEstabilizacion+1)/dt));
            C2out=2*k_metal/(2*k_metal+hout*dy(3));
            
            %% Elementos que no requieren iteración

            % Elementos internos yeso (1)
            for i = 2:totNelInLength-1
                for j = 2:nelInHeight(1)
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -rho_yeso*c_yeso*dx*dy(1)/dt;
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = 2*k_yeso*dx/dy(1) + 2*k_yeso*dy(1)/dx + rho_yeso*c_yeso*dx*dy(1)/dt; %   -- coeficiente central
                    aux(i,j+1) = -k_yeso*dx/dy(1); %            -- coeficiente norte
                    aux(i,j-1) = -k_yeso*dx/dy(1); %            -- coeficiente sur
                    aux(i+1,j) = -k_yeso*dy(1)/dx; %            -- coeficiente este
                    aux(i-1,j) = -k_yeso*dy(1)/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos internos madera (2)
            for i = nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1
                for j = nelInHeight(1)+2:nelInHeight(1)+nelInHeight(2)+1
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -rho_madera*c_madera*dx*dy(2)/dt;
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = 2*k_madera*dx/dy(2) + 2*k_madera*dy(2)/dx + rho_madera*c_madera*dx*dy(2)/dt; %   -- coeficiente central
                    aux(i,j+1) = -k_madera*dx/dy(2); %            -- coeficiente norte
                    aux(i,j-1) = -k_madera*dx/dy(2); %            -- coeficiente sur
                    aux(i+1,j) = -k_madera*dy(2)/dx; %            -- coeficiente este
                    aux(i-1,j) = -k_madera*dy(2)/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos internos aislante (3)
            for i = [2:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength-1]
                for j = nelInHeight(1)+2:nelInHeight(1)+1+nelInHeight(2)
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -rho_aislante*c_aislante*dx*dy(2)/dt;
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = 2*k_aislante*dx/dy(2) + 2*k_aislante*dy(2)/dx + rho_aislante*c_aislante*dx*dy(2)/dt; %   -- coeficiente central
                    aux(i,j+1) = -k_aislante*dx/dy(2); %            -- coeficiente norte
                    aux(i,j-1) = -k_aislante*dx/dy(2); %            -- coeficiente sur
                    aux(i+1,j) = -k_aislante*dy(2)/dx; %            -- coeficiente este
                    aux(i-1,j) = -k_aislante*dy(2)/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos internos metal (4)
            for i = 2:(totNelInLength-1)
                for j = (nelInHeight(1)+nelInHeight(2)+3):(totNelInHeight-1)
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -rho_metal*c_metal*dx*dy(3)/dt;
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = 2*k_metal*dx/dy(3) + 2*k_metal*dy(3)/dx + rho_metal*c_metal*dx*dy(3)/dt; %   -- coeficiente central
                    aux(i,j+1) = -k_metal*dx/dy(3); %            -- coeficiente norte
                    aux(i,j-1) = -k_metal*dx/dy(3); %            -- coeficiente sur
                    aux(i+1,j) = -k_metal*dy(3)/dx; %            -- coeficiente este
                    aux(i-1,j) = -k_metal*dy(3)/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos interfaz yeso-madera (5)
            for i = nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1
                for j = nelInHeight(1)+1
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -(rho_yeso*c_yeso*dy(1)+rho_madera*c_madera*dy(2))*dx/(2*dt);
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = k_madera*dx/dy(2) + k_yeso*dx/dy(1) + k_madera*dy(2)/dx + k_yeso*dy(1)/dx + (rho_yeso*c_yeso*dy(1)+rho_madera*c_madera*dy(2))*dx/(2*dt); %   -- coeficiente central
                    aux(i,j+1) = -k_madera*dx/dy(2); %            -- coeficiente norte
                    aux(i,j-1) = -k_yeso*dx/dy(1); %            -- coeficiente sur
                    aux(i+1,j) = -0.5*(k_madera*dy(2)+k_yeso*dy(1))/dx; %            -- coeficiente este
                    aux(i-1,j) = -0.5*(k_madera*dy(2)+k_yeso*dy(1))/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos interfaz yeso-aislante (6)
            for i = [2:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength-1]
                for j = nelInHeight(1)+1
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -(rho_yeso*c_yeso*dy(1)+rho_aislante*c_aislante*dy(2))*dx/(2*dt);
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = k_aislante*dx/dy(2) + k_yeso*dx/dy(1) + k_aislante*dy(2)/dx + k_yeso*dy(1)/dx + (rho_yeso*c_yeso*dy(1)+rho_aislante*c_aislante*dy(2))*dx/(2*dt); %   -- coeficiente central
                    aux(i,j+1) = -k_aislante*dx/dy(2); %            -- coeficiente norte
                    aux(i,j-1) = -k_yeso*dx/dy(1); %            -- coeficiente sur
                    aux(i+1,j) = -0.5*(k_aislante*dy(2)+k_yeso*dy(1))/dx; %            -- coeficiente este
                    aux(i-1,j) = -0.5*(k_aislante*dy(2)+k_yeso*dy(1))/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos interfaz metal-madera (7)
            for i = nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1 
                for j = nelInHeight(1)+2+nelInHeight(2)
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -(rho_metal*c_metal*dy(3)+rho_madera*c_madera*dy(2))*dx/(2*dt);
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = k_metal*dx/dy(3) + k_madera*dx/dy(2) + k_metal*dy(3)/dx + k_madera*dy(2)/dx + (rho_metal*c_metal*dy(3)+rho_madera*c_madera*dy(2))*dx/(2*dt); %   -- coeficiente central
                    aux(i,j+1) = -k_metal*dx/dy(3); %            -- coeficiente norte
                    aux(i,j-1) = -k_madera*dx/dy(2); %            -- coeficiente sur
                    aux(i+1,j) = -0.5*(k_metal*dy(3)+k_madera*dy(2))/dx; %            -- coeficiente este
                    aux(i-1,j) = -0.5*(k_metal*dy(3)+k_madera*dy(2))/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos interfaz metal-aislante (8)
            for i = [2:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength-1]
                for j = nelInHeight(1)+2+nelInHeight(2)
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -(rho_metal*c_metal*dy(3)+rho_aislante*c_aislante*dy(2))*dx/(2*dt);
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = k_metal*dx/dy(3) + k_aislante*dx/dy(2) + k_metal*dy(3)/dx + k_aislante*dy(2)/dx + (rho_metal*c_metal*dy(3)+rho_aislante*c_aislante*dy(2))*dx/(2*dt); %   -- coeficiente central
                    aux(i,j+1) = -k_metal*dx/dy(3); %            -- coeficiente norte
                    aux(i,j-1) = -k_aislante*dx/dy(2); %            -- coeficiente sur
                    aux(i+1,j) = -0.5*(k_metal*dy(3)+k_aislante*dy(2))/dx; %            -- coeficiente este
                    aux(i-1,j) = -0.5*(k_metal*dy(3)+k_aislante*dy(2))/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos interfaz madera-aislante (9.oeste)
            for i = nelInLength(1)+1
                for j = (nelInHeight(1)+2):(nelInHeight(1)+1+nelInHeight(2))
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -(rho_madera*c_madera+rho_aislante*c_aislante)*dy(2)*dx/(2*dt);
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = k_madera*dx/dy(2) + k_aislante*dx/dy(2) + k_madera*dy(2)/dx + k_aislante*dy(2)/dx + (rho_madera*c_madera+rho_aislante*c_aislante)*dy(2)*dx/(2*dt); %   -- coeficiente central
                    aux(i,j+1) = -0.5*(k_madera*dx+k_aislante*dx)/dy(2); %            -- coeficiente norte
                    aux(i,j-1) = -0.5*(k_madera*dx+k_aislante*dx)/dy(2); %            -- coeficiente sur
                    aux(i+1,j) = -k_madera*dy(2)/dx; %            -- coeficiente este
                    aux(i-1,j) = -k_aislante*dy(2)/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos interfaz madera-aislante (9.este)
            for i = nelInLength(1)+nelInLength(2)+2
                for j = (nelInHeight(1)+2):(nelInHeight(1)+1+nelInHeight(2))
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -(rho_madera*c_madera+rho_aislante*c_aislante)*dy(2)*dx/(2*dt);
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = k_madera*dx/dy(2) + k_aislante*dx/dy(2) + k_madera*dy(2)/dx + k_aislante*dy(2)/dx + (rho_madera*c_madera+rho_aislante*c_aislante)*dy(2)*dx/(2*dt); %   -- coeficiente central
                    aux(i,j+1) = -0.5*(k_madera*dx+k_aislante*dx)/dy(2); %            -- coeficiente norte
                    aux(i,j-1) = -0.5*(k_madera*dx+k_aislante*dx)/dy(2); %            -- coeficiente sur
                    aux(i+1,j) = -k_aislante*dy(2)/dx; %            -- coeficiente este
                    aux(i-1,j) = -k_madera*dy(2)/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos cara yeso-oeste (12)
            for i = 1 
                for j = 2:nelInHeight(1)
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -rho_yeso*c_yeso*dy(1)*dx/dt;
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = 2*k_yeso*dx/dy(1) + k_yeso*dy(1)/dx + rho_yeso*c_yeso*dy(1)*dx/dt; %   -- coeficiente central
                    aux(i,j+1) = -k_yeso*dx/dy(1); %            -- coeficiente norte
                    aux(i,j-1) = -k_yeso*dx/dy(1); %            -- coeficiente sur
                    aux(i+1,j) = -k_yeso*dy(1)/dx; %            -- coeficiente este
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end
            % Elementos cara aislante-oeste (13)
            for i = 1 
                for j = (nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1)
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -rho_aislante*c_aislante*dy(2)*dx/dt;
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = 2*k_aislante*dx/dy(2) + k_aislante*dy(2)/dx + rho_aislante*c_aislante*dy(2)*dx/dt; %   -- coeficiente central
                    aux(i,j+1) = -k_aislante*dx/dy(2); %            -- coeficiente norte
                    aux(i,j-1) = -k_aislante*dx/dy(2); %            -- coeficiente sur
                    aux(i+1,j) = -k_aislante*dy(2)/dx; %            -- coeficiente este
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos cara metal-oeste (14)
            for i = 1 
                for j = (nelInHeight(1)+nelInHeight(2)+3):totNelInHeight-1
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -rho_metal*c_metal*dy(3)*dx/dt;
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = 2*k_metal*dx/dy(3) + k_metal*dy(3)/dx + rho_metal*c_metal*dy(3)*dx/dt; %   -- coeficiente central
                    aux(i,j+1) = -k_metal*dx/dy(3); %            -- coeficiente norte
                    aux(i,j-1) = -k_metal*dx/dy(3); %            -- coeficiente sur
                    aux(i+1,j) = -k_metal*dy(3)/dx; %            -- coeficiente este
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos cara yeso-este (15)
            for i = totNelInLength 
                for j = 2:nelInHeight(1)
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -rho_yeso*c_yeso*dy(1)*dx/dt;
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = 2*k_yeso*dx/dy(1) + k_yeso*dy(1)/dx + rho_yeso*c_yeso*dy(1)*dx/dt; %   -- coeficiente central
                    aux(i,j+1) = -k_yeso*dx/dy(1); %            -- coeficiente norte
                    aux(i,j-1) = -k_yeso*dx/dy(1); %            -- coeficiente sur
                    aux(i-1,j) = -k_yeso*dy(1)/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos cara aislante-este (16)
            for i = totNelInLength
                for j = (nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1)
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -rho_aislante*c_aislante*dy(2)*dx/dt;
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = 2*k_aislante*dx/dy(2) + k_aislante*dy(2)/dx + rho_aislante*c_aislante*dy(2)*dx/dt; %   -- coeficiente central
                    aux(i,j+1) = -k_aislante*dx/dy(2); %            -- coeficiente norte
                    aux(i,j-1) = -k_aislante*dx/dy(2); %            -- coeficiente sur
                    aux(i-1,j) = -k_aislante*dy(2)/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos cara metal-este (17)
            for i = totNelInLength 
                for j = (nelInHeight(1)+nelInHeight(2)+3):totNelInHeight-1
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -rho_metal*c_metal*dy(3)*dx/dt;
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = 2*k_metal*dx/dy(3) + k_metal*dy(3)/dx + rho_metal*c_metal*dy(3)*dx/dt; %   -- coeficiente central
                    aux(i,j+1) = -k_metal*dx/dy(3); %            -- coeficiente norte
                    aux(i,j-1) = -k_metal*dx/dy(3); %            -- coeficiente sur
                    aux(i-1,j) = -k_metal*dy(3)/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end


            % Elementos interfaz yeso-madera-aislante (18.oeste)
            for i = nelInLength(1)+1
                for j = nelInHeight(1)+1
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -(2*rho_yeso*c_yeso*dy(1)+rho_madera*c_madera*dy(2)+rho_aislante*c_aislante*dy(2))*dx/(4*dt);
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = 0.5*(k_madera+k_aislante)*dx/dy(2) + k_yeso*dx/dy(1) + (0.5*k_madera*dy(2)+0.5*k_aislante*dy(2)+k_yeso*dy(1))/dx + (2*rho_yeso*c_yeso*dy(1)+rho_madera*c_madera*dy(2)+rho_aislante*c_aislante*dy(2))*dx/(4*dt); %   -- coeficiente central
                    aux(i,j+1) = -0.5*(k_madera+k_aislante)*dx/dy(2); %            -- coeficiente norte
                    aux(i,j-1) = -k_yeso*dx/dy(1); %            -- coeficiente sur
                    aux(i+1,j) = -0.5*(k_madera*dy(2)+k_yeso*dy(1))/dx; %            -- coeficiente este
                    aux(i-1,j) = -0.5*(k_aislante*dy(2)+k_yeso*dy(1))/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos interfaz yeso-madera-aislante (18.este)
            for i = nelInLength(1)+nelInLength(2)+2
                for j = nelInHeight(1)+1
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -(2*rho_yeso*c_yeso*dy(1)+rho_madera*c_madera*dy(2)+rho_aislante*c_aislante*dy(2))*dx/(4*dt);
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = 0.5*(k_madera+k_aislante)*dx/dy(2) + k_yeso*dx/dy(1) + (0.5*k_madera*dy(2)+0.5*k_aislante*dy(2)+k_yeso*dy(1))/dx + (2*rho_yeso*c_yeso*dy(1)+rho_madera*c_madera*dy(2)+rho_aislante*c_aislante*dy(2))*dx/(4*dt); %   -- coeficiente central
                    aux(i,j+1) = -0.5*(k_madera+k_aislante)*dx/dy(2); %            -- coeficiente norte
                    aux(i,j-1) = -k_yeso*dx/dy(1); %            -- coeficiente sur
                    aux(i+1,j) = -0.5*(k_aislante*dy(2)+k_yeso*dy(1))/dx; %            -- coeficiente este
                    aux(i-1,j) = -0.5*(k_madera*dy(2)+k_yeso*dy(1))/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos interfaz metal-madera-aislante (19.oeste)
            for i = nelInLength(1)+1
                for j = nelInHeight(1)+nelInHeight(2)+2
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -(2*rho_metal*c_metal*dy(3)+rho_madera*c_madera*dy(2)+rho_aislante*c_aislante*dy(2))*dx/(4*dt);
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = 0.5*(k_madera+k_aislante)*dx/dy(2) + k_metal*dx/dy(3) + (0.5*k_madera*dy(2)+0.5*k_aislante*dy(2)+k_metal*dy(3))/dx + (2*rho_metal*c_metal*dy(3)+rho_madera*c_madera*dy(2)+rho_aislante*c_aislante*dy(2))*dx/(4*dt); %   -- coeficiente central
                    aux(i,j+1) = -k_metal*dx/dy(3); %            -- coeficiente norte
                    aux(i,j-1) = -0.5*(k_madera+k_aislante)*dx/dy(2); %            -- coeficiente sur
                    aux(i+1,j) = -0.5*(k_madera*dy(2)+k_metal*dy(3))/dx; %            -- coeficiente este
                    aux(i-1,j) = -0.5*(k_aislante*dy(2)+k_metal*dy(3))/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elementos interfaz metal-madera-aislante (19.este)
            for i = nelInLength(1)+nelInLength(2)+2
                for j = nelInHeight(1)+nelInHeight(2)+2
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -(2*rho_metal*c_metal*dy(3)+rho_madera*c_madera*dy(2)+rho_aislante*c_aislante*dy(2))*dx/(4*dt);
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = 0.5*(k_madera+k_aislante)*dx/dy(2) + k_metal*dx/dy(3) + (0.5*k_madera*dy(2)+0.5*k_aislante*dy(2)+k_metal*dy(3))/dx + (2*rho_metal*c_metal*dy(3)+rho_madera*c_madera*dy(2)+rho_aislante*c_aislante*dy(2))*dx/(4*dt); %   -- coeficiente central
                    aux(i,j+1) = -k_metal*dx/dy(3); %            -- coeficiente norte
                    aux(i,j-1) = -0.5*(k_madera+k_aislante)*dx/dy(2); %            -- coeficiente sur
                    aux(i+1,j) = -0.5*(k_aislante*dy(2)+k_metal*dy(3))/dx; %            -- coeficiente este
                    aux(i-1,j) = -0.5*(k_madera*dy(2)+k_metal*dy(3))/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elemento cara yeso-aislante-oeste (20)
            for i = 1 
                for j = nelInHeight(1)+1
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -(rho_yeso*c_yeso*dy(1)+rho_aislante*c_aislante*dy(2))*dx/(2*dt);
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = k_aislante*dx/dy(2) + k_yeso*dx/dy(1) + 0.5*(k_aislante*dy(2)+k_yeso*dy(1))/dx + (rho_yeso*c_yeso*dy(1)+rho_aislante*c_aislante*dy(2))*dx/(2*dt); %   -- coeficiente central
                    aux(i,j+1) = -k_aislante*dx/dy(2); %            -- coeficiente norte
                    aux(i,j-1) = -k_yeso*dx/dy(1); %            -- coeficiente sur
                    aux(i+1,j) = -0.5*(k_aislante*dy(2)+k_yeso*dy(1))/dx; %            -- coeficiente este
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elemento cara aislante-metal-oeste (21)
            for i = 1
                for j = nelInHeight(1)+nelInHeight(2)+2
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -(rho_metal*c_metal*dy(3)+rho_aislante*c_aislante*dy(2))*dx/(2*dt);
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = k_metal*dx/dy(3) + k_aislante*dx/dy(2) + 0.5*(k_aislante*dy(2)+k_metal*dy(3))/dx + (rho_metal*c_metal*dy(3)+rho_aislante*c_aislante*dy(2))*dx/(2*dt); %   -- coeficiente central
                    aux(i,j+1) = -k_metal*dx/dy(3); %            -- coeficiente norte
                    aux(i,j-1) = -k_aislante*dx/dy(2); %            -- coeficiente sur
                    aux(i+1,j) = -0.5*(k_aislante*dy(2)+k_metal*dy(3))/dx; %            -- coeficiente este
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end


            % Elemento cara yeso-aislante-este (22)
            for i = totNelInLength 
                for j = nelInHeight(1)+1
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -(rho_yeso*c_yeso*dy(1)+rho_aislante*c_aislante*dy(2))*dx/(2*dt);
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = k_aislante*dx/dy(2) + k_yeso*dx/dy(1) + 0.5*(k_aislante*dy(2)+k_yeso*dy(1))/dx + (rho_yeso*c_yeso*dy(1)+rho_aislante*c_aislante*dy(2))*dx/(2*dt); %   -- coeficiente central
                    aux(i,j+1) = -k_aislante*dx/dy(2); %            -- coeficiente norte
                    aux(i,j-1) = -k_yeso*dx/dy(1); %            -- coeficiente sur

                    aux(i-1,j) = -0.5*(k_aislante*dy(2)+k_yeso*dy(1))/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            % Elemento cara aislante-metal-este (23)
            for i = totNelInLength 
                for j = nelInHeight(1)+nelInHeight(2)+2
                    aux0 = sparse(totNelInLength,totNelInHeight);
                    aux0(i,j) = -(rho_metal*c_metal*dy(3)+rho_aislante*c_aislante*dy(2))*dx/(2*dt);
                    aux0=aux0';

                    aux = sparse(totNelInLength,totNelInHeight);
                    aux(i,j) = k_metal*dx/dy(3) + k_aislante*dx/dy(2) + 0.5*(k_aislante*dy(2)+k_metal*dy(3))/dx + (rho_metal*c_metal*dy(3)+rho_aislante*c_aislante*dy(2))*dx/(2*dt); %   -- coeficiente central
                    aux(i,j+1) = -k_metal*dx/dy(3); %            -- coeficiente norte
                    aux(i,j-1) = -k_aislante*dx/dy(2); %            -- coeficiente sur

                    aux(i-1,j) = -0.5*(k_aislante*dy(2)+k_metal*dy(3))/dx; %            -- coeficiente oeste
                    aux=aux';

                    nroFila = (j-1)*totNelInLength+i;
                    A0(nroFila,:)=aux0(:);
                    A(nroFila,:)=aux(:);
                    B(nroFila)=0;
                end
            end

            for iTime=1:3600*24*(diasEstabilizacion+1)/dt %4 días de corrida, 3 para que se estabilice el ciclo de temperaturas. Estudiamos los flujos de calor en el cuarto día.
                time(iTime)=dt*iTime;
                dia=ceil(time(iTime)/(3600*24));
                hora=floor(time(iTime)/3600)-(dia-1)*24;
                minutos=floor(time(iTime)/60)-(dia-1)*24*60-hora*60;
                                
                if floor((hora*60+minutos)/(900/60))==0
                    Taux1=curvaTemp(nroMes,1); %[K]
                else
                    Taux1=curvaTemp(nroMes,floor((hora*60+minutos)/(900/60))); %[K]
                end
                if ceil((hora*60+minutos)/(900/60))==0
                    Taux2=curvaTemp(nroMes,1); %[K]
                else
                    Taux2=curvaTemp(nroMes,ceil((hora*60+minutos)/(900/60))); %[K]
                end

                difFloorCeilTemp=ceil((hora*60+minutos)/(900/60))-floor((hora*60+minutos)/(900/60));
                distFloorTemp=((hora*60+minutos)/(900/60))-floor((hora*60+minutos)/(900/60));
                if difFloorCeilTemp==0
                    Tout = Taux1;
                else
                    Tout=Taux1+(Taux2-Taux1)*distFloorTemp/difFloorCeilTemp;
                end
                
                if floor((hora*60+minutos)/(900/60))==0
                    qaux1=curvaRad(nroMes,1); % [w/m2]
                else
                    qaux1=curvaRad(nroMes,floor((hora*60+minutos)/(900/60))); % [w/m2]
                end
                if ceil((hora*60+minutos)/(900/60))==0
                    qaux2=curvaRad(nroMes,1); % [w/m2]
                else
                    qaux2=curvaRad(nroMes,ceil((hora*60+minutos)/(900/60))); % [w/m2]
                end

                difFloorCeilRad=ceil((hora*60+minutos)/(900/60))-floor((hora*60+minutos)/(900/60)); % [w/m2]
                distFloorRad=((hora*60+minutos)/(900/60))-floor((hora*60+minutos)/(900/60));
                if difFloorCeilRad ==0
                    qrad=absorbancia_metal*qaux1;
                else
                    qrad=absorbancia_metal*(qaux1+(qaux2-qaux1)*distFloorRad/difFloorCeilRad); % [w/m2]
                end
                
                TsuperficieExt = ones(1,totNelInLength)*(Tout+Tin)/2; % [K]
                TsuperficieInt = ones(1,totNelInLength)*(Tout+Tin)/2; % [K]
                %Con estas se obtienen las temperaturas en las superficies:
                %Ts_norte=C1out+C2out*Tsuperior, Ts_sur=C1in+C2in*Tinferior
                C1out=hout*Tout*dy(3)/(2*k_metal+hout*dy(3));

                Temp(:,iTime)=T;

                %% Elementos que requieren iteración (con hr o hin)
                for iIter=1:5
                    for i=1:totNelInLength
                        hin(i) = get_h_in(Tin,TsuperficieInt(i));
                    end

                    % Elementos cara yeso-sur(10)
                    for i = 2:totNelInLength-1
                        for j = 1
                            aux0 = sparse(totNelInLength,totNelInHeight);
                            aux0(i,j) = -rho_yeso*c_yeso*dy(1)*dx/dt;
                            aux0=aux0';

                            aux = sparse(totNelInLength,totNelInHeight);
                            C1in(i)=hin(i)*Tin*dy(1)/(2*k_yeso+hin(i)*dy(1));
                            C2in(i)=2*k_yeso/(2*k_yeso+hin(i)*dy(1));
                            aux(i,j) = k_yeso*dx/dy(1) + 2*k_yeso*dy(1)/dx + hin(i)*dx*C2in(i) + rho_yeso*c_yeso*dy(1)*dx/dt; %   -- coeficiente central
                            aux(i,j+1) = -k_yeso*dx/dy(1); %            -- coeficiente norte
                            aux(i+1,j) = -k_yeso*dy(1)/dx; %            -- coeficiente este
                            aux(i-1,j) = -k_yeso*dy(1)/dx; %            -- coeficiente oeste
                            aux=aux';

                            nroFila = (j-1)*totNelInLength+i;
                            A0(nroFila,:)=aux0(:);
                            A(nroFila,:)=aux(:);
                            B(nroFila)=hin(i)*dx*(Tin-C1in(i));
                        end
                    end

                    % Elementos cara metal-norte(11)
                    for i = 2:totNelInLength-1
                        for j = totNelInHeight
                            aux0 = sparse(totNelInLength,totNelInHeight);
                            aux0(i,j) = -rho_metal*c_metal*dy(3)*dx/dt;
                            aux0=aux0';

                            aux = sparse(totNelInLength,totNelInHeight);
                            hr(i) = emisividad_metal*sigma*(TsuperficieExt(i)^2+Tout^2)*(TsuperficieExt(i)+Tout);

                            C1outtot(i)=(hr(i)+hout)*Tout*dy(3)/(2*k_metal+(hr(i)+hout)*dy(3));
                            C1outtotQ(i)=((hr(i)+hout)*Tout*dy(3)+qrad*dy(3))/(2*k_metal+(hr(i)+hout)*dy(3));
                            C2outtot(i)=2*k_metal/(2*k_metal+(hr(i)+hout)*dy(3));

                            aux(i,j) = k_metal*dx/dy(3) + 2*k_metal*dy(3)/dx + (hr(i)+hout)*dx*C2outtot(i) + rho_metal*c_metal*dy(3)*dx/dt; %   -- coeficiente central
                            aux(i,j-1) = -k_metal*dx/dy(3); %            -- coeficiente sur
                            aux(i+1,j) = -k_metal*dy(3)/dx; %            -- coeficiente este
                            aux(i-1,j) = -k_metal*dy(3)/dx; %            -- coeficiente oeste
                            aux=aux';

                            nroFila = (j-1)*totNelInLength+i;
                            A0(nroFila,:)=aux0(:);
                            A(nroFila,:)=aux(:);
                            B(nroFila)=(hr(i)+hout)*dx*(Tout-C1outtotQ(i))+qrad*dx;
                        end
                    end


                    % Elemento vertice yeso- sudoeste (24)
                    for i = 1 
                        for j = 1
                            aux0 = sparse(totNelInLength,totNelInHeight);
                            aux0(i,j) = -rho_yeso*c_yeso*dy(1)*dx/dt;
                            aux0=aux0';

                            aux = sparse(totNelInLength,totNelInHeight);
                            C1in(i)=hin(i)*Tin*dy(1)/(2*k_yeso+hin(i)*dy(1));
                            C2in(i)=2*k_yeso/(2*k_yeso+hin(i)*dy(1));
                            aux(i,j) = k_yeso*dx/dy(1) + k_yeso*dy(1)/dx + hin(i)*dx*C2in(i) + rho_yeso*c_yeso*dy(1)*dx/dt; %   -- coeficiente central
                            aux(i,j+1) = -k_yeso*dx/dy(1); %            -- coeficiente norte
                            aux(i+1,j) = -k_yeso*dy(1)/dx; %            -- coeficiente este
                            aux=aux';

                            nroFila = (j-1)*totNelInLength+i;
                            A0(nroFila,:)=aux0(:);
                            A(nroFila,:)=aux(:);
                            B(nroFila)=hin(i)*dx*(Tin-C1in(i));
                        end
                    end


                    % Elemento vertice yeso-sudeste (25)
                    for i = totNelInLength
                        for j = 1
                            aux0 = sparse(totNelInLength,totNelInHeight);
                            aux0(i,j) = -rho_yeso*c_yeso*dy(1)*dx/dt;
                            aux0=aux0';

                            aux = sparse(totNelInLength,totNelInHeight);
                            C1in(i)=hin(i)*Tin*dy(1)/(2*k_yeso+hin(i)*dy(1));
                            C2in(i)=2*k_yeso/(2*k_yeso+hin(i)*dy(1));
                            aux(i,j) = k_yeso*dx/dy(1) + k_yeso*dy(1)/dx + hin(i)*dx*C2in(i) + rho_yeso*c_yeso*dy(1)*dx/dt; %   -- coeficiente central
                            aux(i,j+1) = -k_yeso*dx/dy(1); %            -- coeficiente norte
                            aux(i-1,j) = -k_yeso*dy(1)/dx; %            -- coeficiente oeste
                            aux=aux';

                            nroFila = (j-1)*totNelInLength+i;
                            A0(nroFila,:)=aux0(:);
                            A(nroFila,:)=aux(:);
                            B(nroFila)=hin(i)*dx*(Tin-C1in(i));
                        end
                    end


                    % Elemento vertice metal-noroeste (26)
                    for i = 1
                        for j = totNelInHeight
                            aux0 = sparse(totNelInLength,totNelInHeight);
                            aux0(i,j) = -rho_metal*c_metal*dy(3)*dx/dt;
                            aux0=aux0';

                            aux = sparse(totNelInLength,totNelInHeight);
                            hr(i) = emisividad_metal*sigma*(TsuperficieExt(i)^2+Tout^2)*(TsuperficieExt(i)+Tout);

                            C1outtot(i)=(hr(i)+hout)*Tout*dy(3)/(2*k_metal+(hr(i)+hout)*dy(3));
                            C1outtotQ(i)=((hr(i)+hout)*Tout*dy(3)+qrad*dy(3))/(2*k_metal+(hr(i)+hout)*dy(3));
                            C2outtot(i)=2*k_metal/(2*k_metal+(hr(i)+hout)*dy(3));

                            aux(i,j) = k_metal*dx/dy(3) + k_metal*dy(3)/dx + (hr(i)+hout)*dx*C2outtot(i) + rho_metal*c_metal*dy(3)*dx/dt; %   -- coeficiente central
                            aux(i,j-1) = -k_metal*dx/dy(3); %            -- coeficiente sur
                            aux(i+1,j) = -k_metal*dy(3)/dx; %            -- coeficiente este
                            aux=aux';

                            nroFila = (j-1)*totNelInLength+i;
                            A0(nroFila,:)=aux0(:);
                            A(nroFila,:)=aux(:);
                            B(nroFila)=(hr(i)+hout)*dx*(Tout-C1outtotQ(i))+qrad*dx;
                        end
                    end


                    % Elemento vertice metal-noreste (27)
                    for i = totNelInLength 
                        for j = totNelInHeight
                            aux0 = sparse(totNelInLength,totNelInHeight);
                            aux0(i,j) = -rho_metal*c_metal*dy(3)*dx/dt;
                            aux0=aux0';

                            aux = sparse(totNelInLength,totNelInHeight);
                            hr(i) = emisividad_metal*sigma*(TsuperficieExt(i)^2+Tout^2)*(TsuperficieExt(i)+Tout);

                            C1outtot(i)=(hr(i)+hout)*Tout*dy(3)/(2*k_metal+(hr(i)+hout)*dy(3));
                            C1outtotQ(i)=((hr(i)+hout)*Tout*dy(3)+qrad*dy(3))/(2*k_metal+(hr(i)+hout)*dy(3));
                            C2outtot(i)=2*k_metal/(2*k_metal+(hr(i)+hout)*dy(3));

                            aux(i,j) = k_metal*dx/dy(3) + k_metal*dy(3)/dx + (hr(i)+hout)*dx*C2outtot(i) + rho_metal*c_metal*dy(3)*dx/dt; %   -- coeficiente central
                            aux(i,j-1) = -k_metal*dx/dy(3); %            -- coeficiente sur
                            aux(i-1,j) = -k_metal*dy(3)/dx; %            -- coeficiente oeste
                            aux=aux';

                            nroFila = (j-1)*totNelInLength+i;
                            A0(nroFila,:)=aux0(:);
                            A(nroFila,:)=aux(:);
                            B(nroFila)=(hr(i)+hout)*dx*(Tout-C1outtotQ(i))+qrad*dx;
                        end
                    end

                    % Solución numérica
                    TIter = A\(B-A0*T);

                    % Armado del meshgrid
                    % [X,Y]=meshgrid([x_centros],[0 y_centros sum(h)]);
                    Tmatriz=reshape(TIter,totNelInHeight,totNelInLength);
                    %Print para ver si la solución converge en cada
                    %timestep
                    if dispDifTemp==1
                        disp(['Máxima diferencia de temperatura en cara superior: ' num2str(max(abs(TsuperficieExt-Tmatriz(end,:))))]);
                    end
                    TsuperficieExt = (C1outtotQ+C2outtot.*Tmatriz(end,:));
                    TsuperficieInt = C1in+C2in.*Tmatriz(1,:);
                end
                T=TIter;


                % Matriz de temperaturas ampliada (para los plots)
                TmatrizA = zeros(size(Tmatriz)+2);
                TmatrizA(2:end-1,2:end-1) = Tmatriz;
                TmatrizA(2:end-1,1) = Tmatriz(:,1);
                TmatrizA(2:end-1,end) = Tmatriz(:,end);
                TmatrizA(1,2:end-1) = TsuperficieInt;
                TmatrizA(end,2:end-1) = TsuperficieExt;
                TmatrizA(1,1) = (TmatrizA(1,2)*dy(1)+TmatrizA(2,1)*dx)/(dy(1)+dx);
                TmatrizA(1,end) = (TmatrizA(1,end-1)*dy(1)+TmatrizA(2,end)*dx)/(dy(1)+dx);
                TmatrizA(end,1) = (TmatrizA(end,2)*dy(3)+TmatrizA(end-1,1)*dx)/(dy(3)+dx);
                TmatrizA(end,end) = (TmatrizA(end,end-1)*dy(3)+TmatrizA(end-1,end)*dx)/(dy(3)+dx);

                TsuperficieIntA = [TsuperficieInt(1) TsuperficieInt TsuperficieInt(end)];
                TsuperficieExtA = [TsuperficieExt(1) TsuperficieExt TsuperficieExt(end)];
                hinA = [hin(1) hin' hin(end)];

                if plotT==2 || (plotT==1 && dia==diasEstabilizacion+1)
                    figure(surfTemp)
                    surf(XA,YA,TmatrizA-273);
                    barra = colorbar;
                    barra.Label.String = 'T ($$^{\circ}$$C)';
                    barra.Label.Interpreter = 'latex';
                    barra.TickLabelInterpreter = 'latex';
                    ax=gca;
                    ax.TickLabelInterpreter='latex';
                    xlabel('x (m)','interpreter','latex'); ylabel('y (m)','interpreter','latex');
                    view([0 0 1]);
                %     caxis([15 60]);
                    title(['Campo de temperaturas - d\''ia ' num2str(dia) ' - ' num2str(hora, '%02.0f') ':' num2str(minutos, '%02.0f') ' hs'],'interpreter','latex');
                    drawnow
                %     pause(0.1)
                end


                % Flujos "un elemento antes del borde". positivo
                % es entrante o almacenado
                Q_norte_viejo=zeros(size(Tmatriz,2),1);
                Q_sur_viejo=zeros(size(Tmatriz,2),1);
                Q_este_viejo=zeros(size(Tmatriz,1),1);
                Q_oeste_viejo=zeros(size(Tmatriz,1),1);

                QNL=k_metal*(Tmatriz(end,:)-Tmatriz(end-1,:))/dy(3);
                QSL=k_yeso*(Tmatriz(1,:)-Tmatriz(2,:))/dy(1);
                QFL(iTime)=sum(QNL*dx)+sum(QSL*dx);

                Q_norte_viejo = k_metal.*(Tmatriz(end,2:end-1)-Tmatriz(end-1,2:end-1))./dy(3); % [W/m2]             -- flujo de calor a lo largo de la cara norte (si da positivo: es entrante)
                Q_sur_viejo = k_yeso.*(Tmatriz(1,2:end-1)-Tmatriz(2,2:end-1))./dy(1); % [W/m2]                      -- flujo de calor a lo largo de la cara sur (si da positivo: es entrante)

                Q_este_viejo(2:nelInHeight(1)) = k_yeso.*(Tmatriz(2:nelInHeight(1),end)-Tmatriz(2:nelInHeight(1),end-1))./dx; % [W/m2]              -- flujo de calor a lo largo de la cara este (si da positivo: es saliente)
                Q_este_viejo(nelInHeight(1)+1) = (k_yeso*dy(1)+k_aislante*dy(2))/(dy(1)+dy(2)).*(Tmatriz(nelInHeight(1)+1,end)-Tmatriz(nelInHeight(1)+1,end-1))./dx;
                Q_este_viejo(nelInHeight(1)+2:nelInHeight(1)+nelInHeight(2)+1) = k_aislante.*(Tmatriz(nelInHeight(1)+2:nelInHeight(1)+nelInHeight(2)+1,end)-Tmatriz(nelInHeight(1)+2:nelInHeight(1)+nelInHeight(2)+1,end-1))./dx;
                Q_este_viejo(nelInHeight(1)+nelInHeight(2)+2) = (k_aislante*dy(2)+k_metal*dy(3))/(dy(2)+dy(3)).*(Tmatriz(nelInHeight(1)+nelInHeight(2)+2,end)-Tmatriz(nelInHeight(1)+nelInHeight(2)+2,end-1))./dx;
                Q_este_viejo(nelInHeight(1)+nelInHeight(2)+3:end-1) = k_metal.*(Tmatriz(nelInHeight(1)+nelInHeight(2)+3:end-1,end)-Tmatriz(nelInHeight(1)+nelInHeight(2)+3:end-1,end-1))./dx;

                Q_oeste_viejo(2:nelInHeight(1)) = k_yeso.*(Tmatriz(2:nelInHeight(1),1)-Tmatriz(2:nelInHeight(1),2))./dx; % [W/m2]              -- flujo de calor a lo largo de la cara este (si da positivo: es saliente)
                Q_oeste_viejo(nelInHeight(1)+1) = (k_yeso*dy(1)+k_aislante*dy(2))/(dy(1)+dy(2)).*(Tmatriz(nelInHeight(1)+1,1)-Tmatriz(nelInHeight(1)+1,2))./dx;
                Q_oeste_viejo(nelInHeight(1)+2:nelInHeight(1)+nelInHeight(2)+1) = k_aislante.*(Tmatriz(nelInHeight(1)+2:nelInHeight(1)+nelInHeight(2)+1,1)-Tmatriz(nelInHeight(1)+2:nelInHeight(1)+nelInHeight(2)+1,2))./dx;
                Q_oeste_viejo(nelInHeight(1)+nelInHeight(2)+2) = (k_aislante*dy(2)+k_metal*dy(3))/(dy(2)+dy(3)).*(Tmatriz(nelInHeight(1)+nelInHeight(2)+2,1)-Tmatriz(nelInHeight(1)+nelInHeight(2)+2,2))./dx;
                Q_oeste_viejo(nelInHeight(1)+nelInHeight(2)+3:end-1) = k_metal.*(Tmatriz(nelInHeight(1)+nelInHeight(2)+3:end-1,1)-Tmatriz(nelInHeight(1)+nelInHeight(2)+3:end-1,2))./dx;

                Q_norte_viejo=Q_norte_viejo(:);
                Q_sur_viejo=Q_sur_viejo(:);
                Q_este_viejo=Q_este_viejo(:);
                Q_oeste_viejo=Q_oeste_viejo(:);
                %el 2:end-1 es simbolico xq en las posiciones 1 y end hay 0s
                QTot_norte_viejo(iTime) = sum(Q_norte_viejo.*dx); % [W/m]                                    -- flujo de calor total por la cara norte
                QTot_sur_viejo(iTime) = sum(Q_sur_viejo.*dx); % [W/m]                                        -- flujo de calor total por la cara sur
                QTot_este_viejo(iTime) = sum([Q_este_viejo(2:nelInHeight(1)).*dy(1)
                                        Q_este_viejo(nelInHeight(1)+1).*(dy(1)+dy(2))/2
                                        Q_este_viejo(nelInHeight(1)+2:nelInHeight(1)+nelInHeight(2)+1).*dy(2)
                                        Q_este_viejo(nelInHeight(1)+nelInHeight(2)+2).*(dy(2)+dy(3))/2
                                        Q_este_viejo(nelInHeight(1)+nelInHeight(2)+3:end-1).*dy(3)]); % [W/m]         -- flujo de calor total por la cara este
                QTot_oeste_viejo(iTime) = sum([Q_oeste_viejo(2:nelInHeight(1)).*dy(1)
                                         Q_oeste_viejo(nelInHeight(1)+1).*(dy(1)+dy(2))/2
                                         Q_oeste_viejo(nelInHeight(1)+2:nelInHeight(1)+nelInHeight(2)+1).*dy(2)
                                         Q_oeste_viejo(nelInHeight(1)+nelInHeight(2)+2).*(dy(2)+dy(3))/2
                                         Q_oeste_viejo(nelInHeight(1)+nelInHeight(2)+3:end-1).*dy(3)]); % [W/m]        -- flujo de calor total por la cara este

                % Flujos a través de las caras, calculados con h's - positivo es entrante
                Q_norte_nuevo = hout*(Tout-TsuperficieExt) + sigma*emisividad_metal*(Tout^4-TsuperficieExt.^4) + qrad; % [W/m2]             -- flujo de calor a lo largo de la cara norte (si da positivo: es entrante)
                Q_sur_nuevo = hin'.*(Tin-TsuperficieInt); % [W/m2]                      -- flujo de calor a lo largo de la cara sur (si da positivo con ese - incluido: es entrante)
                Q_este_nuevo = 0; % [W/m2]              -- flujo de calor a lo largo de la cara este (cero por definición, cond de borde: aislado)
                Q_oeste_nuevo = 0; % [W/m2]                     -- flujo de calor a lo largo de la cara oeste (cero por definición, cond de borde: aislado)
                % Este y oeste son 0 por condición de borde, es decir, para Q_este:
                % Text_este-Tmatriz(:,end)=0, idem para Q_oeste
                QTot_norte_nuevo(iTime) = sum(Q_norte_nuevo.*dx); % [W/m]                                    -- flujo de calor total por la cara norte
                QTot_sur_nuevo(iTime) = sum(Q_sur_nuevo.*dx); % [W/m]                                        -- flujo de calor total por la cara sur
                QTot_este_nuevo(iTime) = 0; % [W/m]         -- flujo de calor total por la cara este
                QTot_oeste_nuevo(iTime) = 0; % [W/m]        -- flujo de calor total por la cara este

                % Flujos a través de las caras, calculados con k's -
                % positivo es entrante
                Q_norte_2 = k_metal.*(TsuperficieExt-Tmatriz(end,:))./(0.5*dy(3));% + qrad; % [W/m2]             -- flujo de calor a lo largo de la cara norte (si da positivo: es entrante)
                Q_sur_2 = k_yeso.*(TsuperficieInt-Tmatriz(1,:))./(0.5*dy(1)); % [W/m2]                      -- flujo de calor a lo largo de la cara sur (si da positivo: es entrante)
                Q_este_2 = k_aislante.*(Tmatriz(:,end)-Tmatriz(:,end))./(0.5*dx); % [W/m2], es simbólico, da 0             -- flujo de calor a lo largo de la cara este (ceroooo)
                Q_oeste_2 = k_aislante.*(Tmatriz(:,1)-Tmatriz(:,1))./(0.5*dx); % [W/m2], es simbólico, da 0                     -- flujo de calor a lo largo de la cara oeste (ceroooo)

                QTot_norte_2(iTime) = sum(Q_norte_2.*dx); % [W/m]                                    -- flujo de calor total por la cara norte
                QTot_sur_2(iTime) = sum(Q_sur_2.*dx); % [W/m]                                        -- flujo de calor total por la cara sur
                QTot_este_2(iTime) = sum([Q_este_2(1:nelInHeight(1)).*dy(1)
                                        Q_este_2(nelInHeight(1)+1).*(dy(1)+dy(2))/2
                                        Q_este_2(nelInHeight(1)+2:nelInHeight(1)+nelInHeight(2)+1).*dy(2)
                                        Q_este_2(nelInHeight(1)+nelInHeight(2)+2).*(dy(2)+dy(3))/2
                                        Q_este_2(nelInHeight(1)+nelInHeight(2)+3:end).*dy(3)]); % [W/m]         -- flujo de calor total por la cara este
                QTot_oeste_2(iTime) = sum([Q_oeste_2(1:nelInHeight(1)).*dy(1)
                                         Q_oeste_2(nelInHeight(1)+1).*(dy(1)+dy(2))/2
                                         Q_oeste_2(nelInHeight(1)+2:nelInHeight(1)+nelInHeight(2)+1).*dy(2)
                                         Q_oeste_2(nelInHeight(1)+nelInHeight(2)+2).*(dy(2)+dy(3))/2
                                         Q_oeste_2(nelInHeight(1)+nelInHeight(2)+3:end).*dy(3)]); % [W/m]        -- flujo de calor total por la cara este


                QAlmacenado(iTime) = sum(sum(c_yeso*rho_yeso*dx*dy(1).*(Tmatriz(1:nelInHeight(1),:)-TmatrizPrev(1:nelInHeight(1),:))/dt))+... %elementos internos y laterales yeso
                                     sum(sum((c_yeso*rho_yeso*dy(1)+c_madera*rho_madera*dy(2))/2*dx.*(Tmatriz(nelInHeight(1)+1,nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1)-TmatrizPrev(nelInHeight(1)+1,nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1))/dt))+... %elementos interfaz yeso-madera
                                     sum(sum((2*c_yeso*rho_yeso*dy(1)+c_madera*rho_madera*dy(2)+rho_aislante*c_aislante*dy(2))/4*dx.*(Tmatriz(nelInHeight(1)+1,[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2])-TmatrizPrev(nelInHeight(1)+1,[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2]))/dt))+... %elementos interfaz yeso-madera-aislante
                                     sum(sum((c_yeso*rho_yeso*dy(1)+c_aislante*rho_aislante*dy(2))/2*dx.*(Tmatriz(nelInHeight(1)+1,[1:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength])-TmatrizPrev(nelInHeight(1)+1,[1:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength]))/dt))+... %elementos interfaz yeso-aislante
                                     sum(sum(c_madera*rho_madera*dx*dy(2).*(Tmatriz((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1)-TmatrizPrev((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1))/dt))+... %elementos internos madera
                                     sum(sum((c_madera*rho_madera+c_aislante*rho_aislante)/2*dy(2)*dx.*(Tmatriz((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2])-TmatrizPrev((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2]))/dt))+... %elementos interfaz madera-aislante
                                     sum(sum(c_aislante*rho_aislante*dx*dy(2).*(Tmatriz((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),[1:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength])-TmatrizPrev((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),[1:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength]))/dt))+... %elementos internos y laterales aislante
                                     sum(sum((c_madera*rho_madera*dy(2)+c_metal*rho_metal*dy(3))/2*dx.*(Tmatriz(nelInHeight(1)+nelInHeight(2)+2,nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1)-TmatrizPrev(nelInHeight(1)+nelInHeight(2)+2,nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1))/dt))+... %elementos interfaz madera-metal
                                     sum(sum((2*c_metal*rho_metal*dy(3)+c_madera*rho_madera*dy(2)+rho_aislante*c_aislante*dy(2))/4*dx.*(Tmatriz(nelInHeight(1)+nelInHeight(2)+2,[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2])-TmatrizPrev(nelInHeight(1)+nelInHeight(2)+2,[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2]))/dt))+... %elementos interfaz metal-madera-aislante
                                     sum(sum((c_aislante*rho_aislante*dy(2)+c_metal*rho_metal*dy(3))/2*dx.*(Tmatriz(nelInHeight(1)+nelInHeight(2)+2,[1:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength])-TmatrizPrev(nelInHeight(1)+nelInHeight(2)+2,[1:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength]))/dt))+... %elementos interfaz aislante-metal
                                     sum(sum(c_metal*rho_metal*dx*dy(3).*(Tmatriz(nelInHeight(1)+nelInHeight(2)+3:end,:)-TmatrizPrev(nelInHeight(1)+nelInHeight(2)+3:end,:))/dt)); %elementos internos y laterales metal
                                     % Calor almacenado (ganado) por todos los elementos al pasar de iTime-1 a iTime [W/m]

                QAlmacenadoLite(iTime) = sum(sum(c_yeso*rho_yeso*dx*dy(1).*(Tmatriz(2:nelInHeight(1),2:end-1)-TmatrizPrev(2:nelInHeight(1),2:end-1))/dt))+... %elementos internos y laterales yeso
                                     sum(sum((c_yeso*rho_yeso*dy(1)+c_madera*rho_madera*dy(2))/2*dx.*(Tmatriz(nelInHeight(1)+1,nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1)-TmatrizPrev(nelInHeight(1)+1,nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1))/dt))+... %elementos interfaz yeso-madera
                                     sum(sum((2*c_yeso*rho_yeso*dy(1)+c_madera*rho_madera*dy(2)+rho_aislante*c_aislante*dy(2))/4*dx.*(Tmatriz(nelInHeight(1)+1,[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2])-TmatrizPrev(nelInHeight(1)+1,[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2]))/dt))+... %elementos interfaz yeso-madera-aislante
                                     sum(sum((c_yeso*rho_yeso*dy(1)+c_aislante*rho_aislante*dy(2))/2*dx.*(Tmatriz(nelInHeight(1)+1,[2:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength-1])-TmatrizPrev(nelInHeight(1)+1,[2:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength-1]))/dt))+... %elementos interfaz yeso-aislante
                                     sum(sum(c_madera*rho_madera*dx*dy(2).*(Tmatriz((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1)-TmatrizPrev((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1))/dt))+... %elementos internos madera
                                     sum(sum((c_madera*rho_madera+c_aislante*rho_aislante)/2*dy(2)*dx.*(Tmatriz((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2])-TmatrizPrev((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2]))/dt))+... %elementos interfaz madera-aislante
                                     sum(sum(c_aislante*rho_aislante*dx*dy(2).*(Tmatriz((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),[2:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength-1])-TmatrizPrev((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),[2:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength-1]))/dt))+... %elementos internos y laterales aislante
                                     sum(sum((c_madera*rho_madera*dy(2)+c_metal*rho_metal*dy(3))/2*dx.*(Tmatriz(nelInHeight(1)+nelInHeight(2)+2,nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1)-TmatrizPrev(nelInHeight(1)+nelInHeight(2)+2,nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1))/dt))+... %elementos interfaz madera-metal
                                     sum(sum((2*c_metal*rho_metal*dy(3)+c_madera*rho_madera*dy(2)+rho_aislante*c_aislante*dy(2))/4*dx.*(Tmatriz(nelInHeight(1)+nelInHeight(2)+2,[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2])-TmatrizPrev(nelInHeight(1)+nelInHeight(2)+2,[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2]))/dt))+... %elementos interfaz metal-madera-aislante
                                     sum(sum((c_aislante*rho_aislante*dy(2)+c_metal*rho_metal*dy(3))/2*dx.*(Tmatriz(nelInHeight(1)+nelInHeight(2)+2,[2:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength-1])-TmatrizPrev(nelInHeight(1)+nelInHeight(2)+2,[2:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength-1]))/dt))+... %elementos interfaz aislante-metal
                                     sum(sum(c_metal*rho_metal*dx*dy(3).*(Tmatriz(nelInHeight(1)+nelInHeight(2)+3:end-1,2:end-1)-TmatrizPrev(nelInHeight(1)+nelInHeight(2)+3:end-1,2:end-1))/dt)); %elementos internos y laterales metal

                QAL(iTime) = sum(sum(c_yeso*rho_yeso*dx*dy(1).*(Tmatriz(2:nelInHeight(1),:)-TmatrizPrev(2:nelInHeight(1),:))/dt))+... %elementos internos y laterales yeso
                                     sum(sum((c_yeso*rho_yeso*dy(1)+c_madera*rho_madera*dy(2))/2*dx.*(Tmatriz(nelInHeight(1)+1,nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1)-TmatrizPrev(nelInHeight(1)+1,nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1))/dt))+... %elementos interfaz yeso-madera
                                     sum(sum((2*c_yeso*rho_yeso*dy(1)+c_madera*rho_madera*dy(2)+rho_aislante*c_aislante*dy(2))/4*dx.*(Tmatriz(nelInHeight(1)+1,[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2])-TmatrizPrev(nelInHeight(1)+1,[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2]))/dt))+... %elementos interfaz yeso-madera-aislante
                                     sum(sum((c_yeso*rho_yeso*dy(1)+c_aislante*rho_aislante*dy(2))/2*dx.*(Tmatriz(nelInHeight(1)+1,[1:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength])-TmatrizPrev(nelInHeight(1)+1,[1:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength]))/dt))+... %elementos interfaz yeso-aislante
                                     sum(sum(c_madera*rho_madera*dx*dy(2).*(Tmatriz((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1)-TmatrizPrev((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1))/dt))+... %elementos internos madera
                                     sum(sum((c_madera*rho_madera+c_aislante*rho_aislante)/2*dy(2)*dx.*(Tmatriz((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2])-TmatrizPrev((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2]))/dt))+... %elementos interfaz madera-aislante
                                     sum(sum(c_aislante*rho_aislante*dx*dy(2).*(Tmatriz((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),[1:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength])-TmatrizPrev((nelInHeight(1)+2):(nelInHeight(1)+nelInHeight(2)+1),[1:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength]))/dt))+... %elementos internos y laterales aislante
                                     sum(sum((c_madera*rho_madera*dy(2)+c_metal*rho_metal*dy(3))/2*dx.*(Tmatriz(nelInHeight(1)+nelInHeight(2)+2,nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1)-TmatrizPrev(nelInHeight(1)+nelInHeight(2)+2,nelInLength(1)+2:nelInLength(1)+nelInLength(2)+1))/dt))+... %elementos interfaz madera-metal
                                     sum(sum((2*c_metal*rho_metal*dy(3)+c_madera*rho_madera*dy(2)+rho_aislante*c_aislante*dy(2))/4*dx.*(Tmatriz(nelInHeight(1)+nelInHeight(2)+2,[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2])-TmatrizPrev(nelInHeight(1)+nelInHeight(2)+2,[nelInLength(1)+1, nelInLength(1)+nelInLength(2)+2]))/dt))+... %elementos interfaz metal-madera-aislante
                                     sum(sum((c_aislante*rho_aislante*dy(2)+c_metal*rho_metal*dy(3))/2*dx.*(Tmatriz(nelInHeight(1)+nelInHeight(2)+2,[1:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength])-TmatrizPrev(nelInHeight(1)+nelInHeight(2)+2,[1:nelInLength(1), nelInLength(1)+nelInLength(2)+3:totNelInLength]))/dt))+... %elementos interfaz aislante-metal
                                     sum(sum(c_metal*rho_metal*dx*dy(3).*(Tmatriz(nelInHeight(1)+nelInHeight(2)+3:end-1,:)-TmatrizPrev(nelInHeight(1)+nelInHeight(2)+3:end-1,:))/dt)); %elementos internos y laterales metal


                TmatrizPrev=Tmatriz;                    

            end
            QTot_norteMat = [QTot_norteMat;{QTot_norte_2(3*length(QTot_norte_2)/4:end)}];
            QTot_surMat = [QTot_surMat;{QTot_sur_2(3*length(QTot_sur_2)/4:end)}];
            todos_QTot_norteMat = [todos_QTot_norteMat;{QTot_norte_2}];
            todos_QTot_surMat = [todos_QTot_surMat;{QTot_sur_2}];
            todos_QAlmMat = [todos_QAlmMat;{QAlmacenado}];

            

            % Plots rápidos
            % figure
            % plot(1:length(Q_norte),Q_norte,1:length(Q_sur),Q_sur,1:length(Q_este),Q_este,1:length(Q_oeste),Q_oeste)
            % legend('norte','sur','este','oeste');
            % title('Flujo de calor al final del día 4');

%             figure
%             plot(QFL,'r'),hold on,plot(QAL,'m'),legend('flujos N+S','Almacenado salvo N+S')
%             title('Flujos vs almacenado considerando solo flujos N y S y malla sin bordes N y S')
% 
%             figure
%             plot(1:length(QTot_norte_viejo),QTot_norte_viejo,1:length(QTot_sur_viejo),QTot_sur_viejo,1:length(QTot_este_viejo),QTot_este_viejo,1:length(QTot_oeste_viejo),QTot_oeste_viejo,1:length(QAlmacenado),QAlmacenadoLite)
%             legend('norte','sur','este','oeste','almacenado');
%             title('Calor total por unidad de espesor hasta el día 4 VIEJO con ks en malla reducida [W/m]');
% 
%             figure,plot(QTot_norte_viejo+QTot_sur_viejo+QTot_este_viejo+QTot_oeste_viejo); hold on; plot(QAlmacenadoLite);
%             legend('Flujos','AlmacenadoLite')
%             title('Flujos vs almacenado VIEJO con ks en malla reducida [W/m]')
% 
%             figure
%             plot(1:length(QTot_norte_nuevo),QTot_norte_nuevo,1:length(QTot_sur_nuevo),QTot_sur_nuevo,1:length(QTot_este_nuevo),QTot_este_nuevo,1:length(QTot_oeste_nuevo),QTot_oeste_nuevo,1:length(QAlmacenado),QAlmacenado)
%             legend('norte','sur','este','oeste','almacenado');
%             title('Calor total por unidad de espesor hasta el día 4 NUEVO 1 con h''s [W/m]');
% 
%             figure,plot(QTot_norte_nuevo+QTot_sur_nuevo+QTot_este_nuevo+QTot_oeste_nuevo); hold on; plot(QAlmacenado);
%             legend('Flujos','Almacenado')
%             title('Flujos vs almacenado NUEVO 1 con h''s [W/m]')
% 
%             figure
%             plot(1:length(QTot_norte_2),QTot_norte_2,1:length(QTot_sur_2),QTot_sur_2,1:length(QTot_este_2),QTot_este_2,1:length(QTot_oeste_2),QTot_oeste_2,1:length(QAlmacenado),QAlmacenado)
%             legend('norte','sur','este','oeste','almacenado');
%             title('Calor total por unidad de espesor hasta el día 4 NUEVO 2 con ks y Tsup [W/m]');
% 
%             figure,plot(QTot_norte_2+QTot_sur_2+QTot_este_2+QTot_oeste_2); hold on; plot(QAlmacenado);
%             legend('Flujos','Almacenado')
%             title('Flujos vs almacenado NUEVO 2 con ks y Tsup [W/m]')

            %plot(24*3600*diasEstabilizacion/dt*[1 1],[min([QAlmacenado(:);QTot_norte_2(:)]) max([QAlmacenado(:);QTot_norte_2(:)])],'k--');

            Qrefrigeracion=-min(QTot_sur_2(24*3600*diasEstabilizacion/dt:end));
            Qcalefaccion=max(QTot_sur_2(24*3600*diasEstabilizacion/dt:end));
            QPromedio=mean(abs(QTot_sur_2(24*3600*diasEstabilizacion/dt:end)));

            QpromedioVec = [QpromedioVec QPromedio];
            QcalefaccionVec = [QcalefaccionVec Qcalefaccion];
            QrefrigeracionVec = [QrefrigeracionVec Qrefrigeracion];
            
            %Prints varios sobre los resultados de potencia
            fprintf('POR PANEL DE 0.4M X PROFUNDIDAD UNITARIA:\n');
            fprintf('caso: %.0f, nel: %.0f, mes: %.0f, Tin: %.1f\n',i_caso,nel,nroMes,Tin-273);
            if Qrefrigeracion>0
                fprintf('Máxima potencia de refrigeración requerida: %.2fW/m\n',Qrefrigeracion);
            end
            if Qcalefaccion>0
                fprintf('Máxima potencia de calefacción requerida: %.2fW/m\n',Qcalefaccion);
            end
            if Qrefrigeracion>0 && Qcalefaccion<0
                fprintf('Potencia promedio de refrigeración: %.2fW/m\n',QPromedio);
            elseif Qrefrigeracion<0 && Qcalefaccion>0
                fprintf('Potencia promedio de calefacción: %.2fW/m\n',QPromedio);
            else
                fprintf('Potencia promedio de calefacción+refrigeración: %.2fW/m\n',QPromedio);
            end
            clear QTot_norte_2 QTot_sur_2
        end
    end
end
toc