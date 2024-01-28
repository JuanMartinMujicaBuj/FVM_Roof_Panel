%Propiedades pertinentes de los materiales
%Madera
k_madera=(0.15+0.17+0.21)/3; %promedio de maderas Kreith
alfa_madera=1e-5*(0.011+0.012+0.012)/3; %tabla UBA
rho_madera= 590; %tabla UBA
c_madera=(2390+2720)/2; %Kreith

%Yeso
k_yeso=0.814; %tabla UBA
alfa_yeso=0.814/(1800*837.36); %tabla UBA
rho_yeso= 1800; %tabla UBA
c_yeso=837.36; %presentación Gonzalo Becerro

%Metal
k_metal=81.1; %Kreith hierro
alfa_metal=22.8*1e-6; %Kreith hierro
rho_metal=7870; %Kreith hierro
c_metal=452; %Kreith hierro
emisividad_metal=0.24; %Kreith hierro pulido brillante
absorbancia_metal=emisividad_metal;

%Aislante
k_aislante=0.035; %Kreith fibra de vidrio
alfa_aislante= 0.035/(220*795); %Kreith fibra de vidrio y Erica.es
rho_aislante=220; %Kreith fibra de vidrio
c_aislante=795; %Erica.es

%k (W/mK): conductividad térmica
%alfa (m^2/s): difusividad térmica
%rho (kg/m^3): densidad
%c (J/kgK): calor específico