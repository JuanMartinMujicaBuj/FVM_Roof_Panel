L = 16; % m, largo del techo

T_aire = 20; % °C
v_aire = 9.216666667; % m/s

% Propiedades tomadas a 20°C
rho_aire = 1.128; % kg/m3
k_aire = 0.0258; % W/mK
cp_aire = 1013; % J/kgK
mu_aire = 18.6815e-6; % Ns/m2
nu_aire = 16.65e-6; % m2/s
Pr = 0.71;

% Parámetros adimensionales
Re_aire = v_aire*L/nu_aire;
Nu_aire1 = 0.664*Re_aire^(1/2)*Pr^(1/3); % ec 4.38 Kreith
Nu_aire2 = 0.036*Re_aire^0.8*Pr^(1/3); % ec 4.82 Kreith

% Cálculo de h
h_aire1 = Nu_aire1*k_aire/L; % (Re fuera de rango)
h_aire2 = Nu_aire2*k_aire/L; % (Re > 5e5, OK)
h_aire3 = 0.93*Re_aire^(-1/2)*cp_aire*v_aire*rho_aire/(Pr^(2/3)); % ec 7.18 (Re fuera de rango)

hout = h_aire2;

clear cp_aire h_aire1 h_aire2 h_aire3 k_aire L mu_aire nu_aire Nu_aire1 Nu_aire2 Pr Re_aire rho_aire T_aire v_aire