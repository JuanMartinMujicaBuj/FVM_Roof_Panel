% Para pedir el caso deseado
% Es necesario pasarle a la función datos de geometría (h,b), condiciones de
% borde (mes, Tin y curvaTipo), e información sobre la malla (nelInLength y
% nelInHeight). 

% Plots
plotT=0; % 0: sin plots, 1: sólo el último día, 2: último día más días de estabilización
dispDifTemp=0; % imprimir o no el mensaje de máxima diferencia de temperatura en cara superior
diasEstabilizacion=3;

% Geometría
h = [0.01, 0.08, 0.001]; % [m]                  -- altura (espesor) de las capas del techo: [yeso, madera+aislante, metal]
b = [0.18 0.04, 0.18]; % [m]                    -- largo de las capas del techo: [aislante, madera, aislante]


% Propiedades
propiedades_materiales; %carga propiedades de interés de los materiales del techo
sigma=5.67e-8; % [w/m2K4]
get_h_out; %calcula el valor de h_out para convección forzada (por presencia de viento) sobre la superficie externa del techo

% Condiciones de borde
% nroMes=[1 7]; %1: enero, 2: febrero y así. Para elegir las curvas de temperatura exterior y radiación adecuadas.
%               % el mes 13 es un promedio de todos los meses (para el caso promedio). 
% Tin = 15+273; %[15:30]+273; % [K]                   -- temperatura interior

% Discretización
curvaTipo = 'curvaTipoAvg';
nelInLength = 2*[9 2 9]+[4 0 4]; %       -- cantidad de elementos en la longitud (coord. x), para aislante izq, madera y aislante der. 
% *nota: para no agregar más áreas con distinta ecuación, se impone un nro
% de elementos tal que dx en la izquierda sea igual que en la derecha.
nelInHeight = [2 10 1]; %                -- cantidad de elementos en la altura (coord. y), para yeso, madera+aislante, y metal
nInterfacesInLength = 2; %               -- cantidad de interfaces en la longitud
nInterfacesInHeight = 2; %               -- cantidad de interfaces en la altura

% Curvas de radiación y tempratura
[curvaRad,curvaTemp] = get_curva_rad_y_temp(curvaTipo,dt); % temperatura exterior y radiación solar a lo largo de las 24hs del día, para cada mes

% Discretización bis
totNelInLength = sum(nelInLength)+nInterfacesInLength;
totNelInHeight = sum(nelInHeight)+nInterfacesInHeight;
nel = totNelInLength*totNelInHeight; %-- cantidad de elementos
dx([1 3]) = b([1 3])./(nelInLength([1 3])+0.5); % [m]            -- paso espacial en x
dx(2) = b(2)/(nelInLength(2)+1);
dx=dx(1); %Porque dx(1), dx(2), dx(3) son iguales
dy([1 3]) = h([1 3])./(nelInHeight([1 3])+0.5); % [m]            -- paso espacial en y
dy(2) = h(2)/(nelInHeight(2)+1);

% Definición de centros y centros ampliados
x_centros = [dx/2:dx(1):b(1),...
             (b(1)+dx(1)):dx(1):(b(1)+b(2)),...
             (b(1)+b(2)+dx(1)):dx(1):(b(1)+b(2)+b(3))]; %[m]  -- coordenada en x de los centros de los elementos
y_centros = [dy(1)/2:dy(1):h(1),...
             (h(1)+dy(2)):dy(2):(h(1)+h(2)),...
             (h(1)+h(2)+dy(3)):dy(3):(h(1)+h(2)+h(3))]; %[m]  -- coordenada en y de los centros de los elementos
x_centrosA = [0 x_centros sum(b)];
y_centrosA = [0 y_centros sum(h)];
         
% Meshgrid, plot de puntos centrales de un elemento y divisiones de capas
[X,Y]=meshgrid(x_centros,y_centros);
[XA,YA]=meshgrid(x_centrosA,y_centrosA);
% b=b*1000; h=h*1000; X=X*1000; Y=Y*1000;
% figure
% patch([0 b(1)+b(2)+b(3) b(1)+b(2)+b(3) 0],[0 0 h(1) h(1)],[0.9 0.9 0.9],'FaceAlpha',0.8);
% patch([0 b(1) b(1) 0],[h(1) h(1) h(1)+h(2) h(1)+h(2)],[0.5 0.5 0.8],'FaceAlpha',0.8);
% patch([b(1) b(1)+b(2) b(1)+b(2) b(1)],[h(1) h(1) h(1)+h(2) h(1)+h(2)],[0.8 0.3 0.1],'FaceAlpha',0.8);
% patch([b(1)+b(2) b(1)+b(2)+b(3) b(1)+b(2)+b(3) b(1)+b(2)],[h(1) h(1) h(1)+h(2) h(1)+h(2)],[0.5 0.5 0.8],'FaceAlpha',0.8);
% patch([0 b(1)+b(2)+b(3) b(1)+b(2)+b(3) 0],[h(1)+h(2) h(1)+h(2) h(1)+h(2)+h(3) h(1)+h(2)+h(3)],[0.5 0.5 0.5],'FaceAlpha',0.8);
% hold on
% plot(X,Y,'kx')
% % title('Malla a utilizar - panel de techo','interpreter','latex');
% xlabel('x [mm]','interpreter','latex'); 
% ylabel('y [mm]','interpreter','latex'); 
% ax=gca;
% axis([0 400 0 91]);
% set(gca,'XTick',[ax.XLim(1) ax.XLim(2)],'YTick',[ax.YLim(1) ax.YLim(2)],'XColor',[0 0 0],'YColor',[0 0 0]);
% ax.TickLabelInterpreter='latex';
% daspect([1 1 1]); hold on;

% propiedades unitarias
% k_yeso=1;%0.1; %[w/mK]
% k_metal=1;%43;
% k_madera=1;%0.1;
% k_aislante=1;%0.01;
% qrad=absorbancia_metal*700; % [w/m2]
% rho_yeso=1e6;rho_metal=1e6;rho_madera=1e6;rho_aislante=1e6;
% c_yeso=1;c_metal=1;c_madera=1;c_aislante=1;
% absorbancia_metal=1; emisividad_metal=1;





% casos que fuimos corriendo


% ----- SENSIBILIDAD DE MALLA -----
% nroMes = [1 7];
% coefNelInLength = [1 1 2 2 3 3 4 5 6 7]'; % 10 casos
% coefNelInHeight = [2 5 1
%                5 10 1
%                2 10 1;
%                5 12 2;
%                4 14 2;
%                8 24 4;
%                10 30 4;
%                10 40 4
%                12 44 4
%                12 48 5];
% 
% nelInLength = coefNelInLength(i_caso)*[9 2 9]+[4 0 4]; %       -- cantidad de elementos en la longitud (coord. x), para aislante izq, madera y aislante der. 
% %*nota: para no agregar más áreas con distinta ecuación, se impone un nro
% %de elementos tal que dx en la izquierda sea igual que en la derecha.
% nelInHeight = coefNelInHeight(i_caso,:); %            -- cantidad de elementos en la altura (coord. y), para yeso, madera+aislante, y metal


% ----- VARIACION DE ESPESORES -----
% Caso variación metal
% hs_metal = [0.0001:0.0001:0.002]; % 20 casos
% dif_h_metal = h_orig(3)-hs_metal(i_caso);
% h = [0.01+dif_h_metal/9, 0.08+dif_h_metal*8/9, hs_metal(i_caso)]; % así me aseguro de que la altura total siempre sea 0.091
% % y los espesores de yeso y maderaislante aumentan/disminuyen según su proporción original (1 a 8)
% b = b_orig;
% nelInLength = 2*[9 2 9]+[4 0 4]; 
% nelInHeight = [2 10 1]; 
% nInterfacesInLength = 2; 
% nInterfacesInHeight = 2; 

% Caso variación yeso
% hs_yeso = [0.005:0.001:0.02]; % 16 casos
% dif_h_yeso = h_orig(1)-hs_yeso(i_caso);
% h = [hs_yeso(i_caso), 0.08+dif_h_yeso*80/81, 0.001+dif_h_yeso/81]; % así me aseguro de que la altura total siempre sea 0.091
% % y los espesores de yeso y maderaislante aumentan/disminuyen según su proporción original (1 a 8)
% b = b_orig;
% nelInLength = 2*[9 2 9]+[4 0 4]; 
% nelInHeight = [2 10 1]; 
% nInterfacesInLength = 2; 
% nInterfacesInHeight = 2; 

% Caso variación madera-aislante
% dx_orig = 0.008;
% bs_madera = [0.008:0.008*2:0.2]; % 13 casos (hasta que bmadera = baislante)
% bs_aislante = (0.4-bs_madera)/2;
% h = h_orig;
% b = [bs_aislante(i_caso) bs_madera(i_caso) bs_aislante(i_caso)];
% nelInLength_casos = [24 0 24;
%                      23 2 23;
%                      22 4 22;
%                      21 6 21;
%                      20 8 20;
%                      19 10 19;
%                      18 12 18;
%                      17 14 17;
%                      16 16 16;
%                      15 18 15;
%                      14 20 14;
%                      13 22 13;
%                      12 24 12];
% nelInLength = nelInLength_casos(i_caso,:);
% nelInHeight = [2 10 1]; %            -- cantidad de elementos en la altura (coord. y), para yeso, madera+aislante, y metal
% nInterfacesInLength = 2; %      -- cantidad de interfaces en la longitud
% nInterfacesInHeight = 2; %      -- cantidad de interfaces en la altura


% ----- VARIACION DE NUBOSIDADES -----
% curvasTipo = {'curvaTipo1','curvaTipo2','curvaTipo3','curvaTipo4',...
%               'curvaTipo5','curvaTipo6','curvaTipo7','curvaTipoAvg'}; % 8 casos
% curvaTipo = curvasTipo{i_caso};

