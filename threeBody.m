function dXdt = threeBody(X, G, m1, m2, m3)
% X = [ x1, y1,  x2, y2,  x3, y3,  vx1, vy1,  vx2, vy2,  vx3, vy3 ]

    % Desfacem vectorul X
    x1 = X(1);  y1 = X(2);
    x2 = X(3);  y2 = X(4);
    x3 = X(5);  y3 = X(6);

    vx1 = X(7);  vy1 = X(8);
    vx2 = X(9);  vy2 = X(10);
    vx3 = X(11); vy3 = X(12);

    % Vectorii de pozitie
    r1 = [x1; y1];
    r2 = [x2; y2];
    r3 = [x3; y3];

    % -------------------
    % Fortele asupra corpului 1
    % -------------------
    R12  = r2 - r1;  dist12 = norm(R12);
    F12  = G*m1*m2 / dist12^2 * (R12 / dist12);  % forta 1 <- 2

    R13  = r3 - r1;  dist13 = norm(R13);
    F13  = G*m1*m3 / dist13^2 * (R13 / dist13);  % forta 1 <- 3

    F1   = F12 + F13;          % rezultanta pe corpul 1
    a1   = F1 / m1;            % accelerația corpului 1

    % -------------------
    % Fortele asupra corpului 2
    % -------------------
    R21  = r1 - r2;  dist21 = norm(R21);
    F21  = G*m2*m1 / dist21^2 * (R21 / dist21);  % forta 2 <- 1

    R23  = r3 - r2;  dist23 = norm(R23);
    F23  = G*m2*m3 / dist23^2 * (R23 / dist23);  % forta 2 <- 3

    F2   = F21 + F23;
    a2   = F2 / m2;

    % -------------------
    % Fortele asupra corpului 3
    % -------------------
    R31  = r1 - r3;  dist31 = norm(R31);
    F31  = G*m3*m1 / dist31^2 * (R31 / dist31);  % forta 3 <- 1

    R32  = r2 - r3;  dist32 = norm(R32);
    F32  = G*m3*m2 / dist32^2 * (R32 / dist32);  % forta 3 <- 2

    F3   = F31 + F32;
    a3   = F3 / m3;

    % -------------------
    % Formăm derivata dX/dt
    % -------------------
    % dX/dt = [ vx1, vy1,  vx2, vy2,  vx3, vy3,  ax1, ay1,  ax2, ay2,  ax3, ay3 ]
    dXdt = [ vx1; vy1; vx2; vy2; vx3; vy3; a1(1); a1(2); a2(1); a2(2); a3(1); a3(2) ];
end
