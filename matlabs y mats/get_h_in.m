function h_in = get_h_in(T_in,Ts)

largo = 16; % m, largo del techo
L = largo/4; % área/perímetro

% Propiedades del aire a 30
rho_aire = 1.128; % kg/m3
k_aire = 0.0258; % W/mK
cp_aire = 1013; % J/kgK
mu_aire = 18.6815e-6; % Ns/m2
nu_aire = 16.65e-6; % m2/s
Pr = 0.71;
gbeta = 1.185e8; % 1/Km3

%Números adimensionales
Gr = gbeta*abs(Ts-T_in)*L^3;
Ra = Pr*Gr;
if Ts <= T_in % inferior fría
    if Ra>=1e7
        Nu = 0.15*Ra^(1/3);
    elseif Ra<1e7
        Nu = 0.54*Ra^(1/4);
    else fprintf('No hay correlación disponible\n');
        Nu = [];
    end
elseif Ts > T_in % inferior caliente
    Nu = 0.27*Ra^(1/4);
end

% Cálculo de h_in
h_in = Nu*k_aire/L;
end