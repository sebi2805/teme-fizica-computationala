% twoBodyRK.m
% Simulare orbita Pământ–Soare cu ode45 (Runge–Kutta adaptiv)
clear; close all; clc;

%% 1. Constante fizice
G    = 6.674e-11;       % [m^3/kg/s^2]
m1   = 1.989e30;        % Masa Soarelui [kg]
m2   = 5.972e24;        % Masa Pământului [kg]
tMax = 3600*24*365*20;     % Durata simulării: 1 an [s]

%% 2. Condiții inițiale
% Soarele fix în origine
x1_0 = 0;  y1_0 = 0;
vx1_0 = 0; vy1_0 = 0;

% Pământ la 1 AU, v ≈ 29.78 km/s perpendicular
x2_0 = 1.496e11;  y2_0 = 0;
vx2_0 = 0;        vy2_0 = 29780;  % [m/s]

% Vector stare: [x1 y1  x2 y2  vx1 vy1  vx2 vy2]
X0 = [x1_0, y1_0,  x2_0, y2_0,  vx1_0, vy1_0,  vx2_0, vy2_0];

%% 3. Setări ODE
opts = odeset('RelTol',1e-12,'AbsTol',1e-14);

%% 4. Integrăm
[tSol, XSol] = ode45(@(t,X) twoBody(t,X,G,m1,m2), [0 tMax], X0, opts);

%% 5. Extragem și afișăm traiectoriile
x1 = XSol(:,1);  y1 = XSol(:,2);
x2 = XSol(:,3);  y2 = XSol(:,4);

figure;
hold on; grid on; axis equal;
plot(x1, y1, 'y-', 'LineWidth', 2);    % Soare
plot(x2, y2, 'b-', 'LineWidth', 2);    % Pământ
xlabel('x [m]'); ylabel('y [m]');
title('Orbita Pământ–Soare (1 an)');
legend('Soare','Pământ');

%% 6. Export JSON
allX = [x1; x2];
allY = [y1; y2];
minX = min(allX); maxX = max(allX);
minY = min(allY); maxY = max(allY);

% Scalăm pe [0,10] pentru vizualizare externă
x1n = (x1 - minX)/(maxX-minX)*10;
y1n = (y1 - minY)/(maxY-minY)*10;
x2n = (x2 - minX)/(maxX-minX)*10;
y2n = (y2 - minY)/(maxY-minY)*10;

data = struct();
data.time_unit       = 's';
data.position_unit   = 'scaled 0–10';
data.time            = tSol;
data.sun_positions   = [x1n, y1n];
data.earth_positions = [x2n, y2n];

jsonText = jsonencode(data);
fid = fopen('twoBodyData.json','w');
if fid==-1, error('Nu pot crea twoBodyData.json'); end
fprintf(fid, '%s', jsonText);
fclose(fid);
fprintf('Export fișier: twoBodyData.json\n');

%% --- Funcție auxiliară ---
function dXdt = twoBody(~, X, G, m1, m2)
    % X = [x1 y1  x2 y2  vx1 vy1  vx2 vy2]
    x1 = X(1); y1 = X(2);
    x2 = X(3); y2 = X(4);
    vx1 = X(5); vy1 = X(6);
    vx2 = X(7); vy2 = X(8);

    dx  = x2 - x1;
    dy  = y2 - y1;
    r3  = (dx^2 + dy^2)^(3/2);

    % Accelerări gravitaționale
    a1x =  G*m2 * dx / r3;
    a1y =  G*m2 * dy / r3;
    a2x = -G*m1 * dx / r3;
    a2y = -G*m1 * dy / r3;

    dXdt = [vx1; vy1; vx2; vy2; a1x; a1y; a2x; a2y];
end

