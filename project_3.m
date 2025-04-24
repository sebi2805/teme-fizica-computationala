clear; close all; clc;

% ------------------------------
% 1. Definim parametrii
% ------------------------------
G    = 6.674e-11;           % Constanta gravitationala
m1   = 5.97e24;             % Ex: Pamant
m2   = 1.90e27;             % Ex: Jupiter (poate fi mai masiv)
m3   = 7.35e22;             % Ex: un satelit
dt   = 100;                 % pas de timp (s)
tMax = 3600*24*30;          % simulam ~30 de zile
nSteps = floor(tMax/dt);    % numar de pasi

% Conditii initiale (exemplu ipotetic):
% Format vector X:
% X = [ x1, y1, x2, y2, x3, y3, vx1, vy1, vx2, vy2, vx3, vy3 ]
X = [  0,       0, ...      % (x1, y1)
       8e11,    0, ...      % (x2, y2)
       5e10,    3e10, ...   % (x3, y3)
       0,       0, ...      % (vx1, vy1)
       0,       14000, ...  % (vx2, vy2)
      -9000,    5000  ];    % (vx3, vy3)

% Arrays pentru salvarea traiectoriilor
pos1 = zeros(nSteps, 2);
pos2 = zeros(nSteps, 2);
pos3 = zeros(nSteps, 2);

% ------------------------------
% 2. Funcția pentru derivată (dX/dt)
% ------------------------------
threeBodyFun = @(X) threeBody(X, G, m1, m2, m3);

% ------------------------------
% 3. Bucla de integrare (RK4)
% ------------------------------
for i = 1:nSteps
    % Salvăm pozițiile curente (doar pentru plot ulterior)
    pos1(i,:) = X(1:2);
    pos2(i,:) = X(3:4);
    pos3(i,:) = X(5:6);

    % k1
    k1 = threeBodyFun(X);

    % k2
    k2 = threeBodyFun(X + 0.5*dt*k1);

    % k3
    k3 = threeBodyFun(X + 0.5*dt*k2);

    % k4
    k4 = threeBodyFun(X + dt*k3);

    % Actualizăm X (pasul RK4)
    X = X + (dt/6)*(k1 + 2*k2 + 2*k3 + k4);
end

% ------------------------------
% 4. Plotăm traiectoriile
% ------------------------------
figure; hold on; grid on; axis equal;
plot(pos1(:,1), pos1(:,2), 'b', 'LineWidth', 2);
plot(pos2(:,1), pos2(:,2), 'r', 'LineWidth', 2);
plot(pos3(:,1), pos3(:,2), 'g', 'LineWidth', 2);

title('Traiectorii (3 corpuri, RK4 manual)');
xlabel('X [m]'); ylabel('Y [m]');
legend('Corp 1','Corp 2','Corp 3');


% ===================================================
% ============ Funcție auxiliară ====================
% ===================================================

