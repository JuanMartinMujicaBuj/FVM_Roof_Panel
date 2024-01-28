% Para pedir el caso deseado
% Es necesario pasarle a la función datos de geometría (h,b), condiciones de
% borde (mes, Tin y curvaTipo), e información sobre la malla (nelInLength y
% nelInHeight). 

% Plots
plotT=2; % 0: sin plots, 1: sólo el último día, 2: último día más días de estabilización
dispDifTemp=1; % imprimir o no el mensaje de máxima diferencia de temperatura en cara superior
diasEstabilizacion=100;

% Geometría
h = [0.01, 0.08, 0.001]; % [m]                  -- altura (espesor) de las capas del techo: [yeso, madera+aislante, metal]
b = [0.18 0.04, 0.18]; % [m]                    -- largo de las capas del techo: [aislante, madera, aislante]


% Propiedades
% propiedades_materiales; %carga propiedades de interés de los materiales del techo
sigma=5.67e-8; % [w/m2K4]

% Condiciones de borde
% nroMes=[1 7]; %1: enero, 2: febrero y así. Para elegir las curvas de temperatura exterior y radiación adecuadas.
%               % el mes 13 es un promedio de todos los meses (para el caso promedio). 
% Tin = 15+273; %[15:30]+273; % [K]                   -- temperatura interior

% Discretización
nelInLength = 2*[9 2 9]+[4 0 4]; %       -- cantidad de elementos en la longitud (coord. x), para aislante izq, madera y aislante der. 
% *nota: para no agregar más áreas con distinta ecuación, se impone un nro
% de elementos tal que dx en la izquierda sea igual que en la derecha.
nelInHeight = [2 10 1]; %                -- cantidad de elementos en la altura (coord. y), para yeso, madera+aislante, y metal
nInterfacesInLength = 2; %               -- cantidad de interfaces en la longitud
nInterfacesInHeight = 2; %               -- cantidad de interfaces en la altura
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