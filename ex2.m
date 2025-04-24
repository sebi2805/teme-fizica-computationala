% ex2.m
% ===============
G   = 6.674e-11;       % m^3/(kg·s^2)
Ms  = 1.989e30;        % kg
r0  = 1.496e11;        % m
v0  = sqrt(G*Ms/r0);   % m/s
y0  = [r0; 0; 0; v0];   % [x; y; vx; vy]

tspan = [0, 3.154e7];  % o perioadă ~1 an

% apel corect:
[t, sol] = ode45(@twoBody, tspan, y0);

x = sol(:,1);  y = sol(:,2);
plot(x, y), axis equal
xlabel('x [m]'), ylabel('y [m]')
title('Orbita Pământ–Soare')

% ===============
function dydt = twoBody(~, y)
    % --- y(1)=x, y(2)=y, y(3)=vx, y(4)=vy ---
    x   = y(1);
    y_p = y(2);
    vx  = y(3);
    vy  = y(4);

    r   = sqrt(x^2 + y_p^2);
    % acceleraţii gravitaţionale
    ax = -6.674e-11 * 1.989e30 * x / r^3;
    ay = -6.674e-11 * 1.989e30 * y_p / r^3;

    dydt = [vx; vy; ax; ay];
end
