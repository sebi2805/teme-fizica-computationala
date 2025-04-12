% Script principal: twoBodyRK.m

% Curățăm spațiul de lucru și ferestrele
clear; close all; clc;

% Definim constantele
G = 6.674e-11;
m1 = 5.97e24;   % Masa corp1 (ex: Pământ)
m2 = 7.35e22;   % Masa corp2 (ex: un satelit)
tMax = 3600*24*5; % simulăm 5 zile

% Poziții și viteze inițiale
x1_0 = 0;    y1_0 = 0;
x2_0 = 7e6;  y2_0 = 0;

vx1_0 = 0;   vy1_0 = 0;
vx2_0 = 0;   vy2_0 = 1000;

% Vectorul de stare inițial: [x1,y1, x2,y2, vx1,vy1, vx2,vy2]
X0 = [x1_0, y1_0, x2_0, y2_0, vx1_0, vy1_0, vx2_0, vy2_0];

% Apelăm ODE45 (o metodă RK adaptivă)
[tSol, XSol] = ode45(@(t,X) twoBody(t,X,G,m1,m2), [0 tMax], X0);

% XSol are aceeași structură ca și X0, doar că e pe coloane
x1_sol = XSol(:,1); y1_sol = XSol(:,2);
x2_sol = XSol(:,3); y2_sol = XSol(:,4);

% Plotăm traiectoriile
figure; hold on; grid on; axis equal;
plot(x1_sol, y1_sol, 'b', 'LineWidth', 2);  % traiectorie corp1
plot(x2_sol, y2_sol, 'r', 'LineWidth', 2);  % traiectorie corp2
xlabel('x [m]');
ylabel('y [m]');
title('Simulare 2-corp (gravitație) cu ode45 (Runge-Kutta)');
legend('Corp 1','Corp 2');

