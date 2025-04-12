function dXdt = twoBody(t, X, G, m1, m2)
    % X = [x1, y1, x2, y2, vx1, vy1, vx2, vy2]
    % Extragem pozițiile
    x1 = X(1); y1 = X(2);
    x2 = X(3); y2 = X(4);
    % Extragem vitezele
    vx1 = X(5); vy1 = X(6);
    vx2 = X(7); vy2 = X(8);

    % Construim vectorii de poziție pentru calcul
    r1 = [x1; y1];
    r2 = [x2; y2];
    R = r2 - r1;
    dist = norm(R);  % distanța dintre cele două obiecte

    % Forța gravitațională
    F = G * m1 * m2 / dist^2;

    % Accelerațiile
    a1 =  F/m1 * (R / dist);
    a2 = -F/m2 * (R / dist);

    % dX/dt = [vx1, vy1, vx2, vy2, ax1, ay1, ax2, ay2]
    dXdt = [vx1; vy1; vx2; vy2; a1(1); a1(2); a2(1); a2(2)];
end

