% Parameters
g = 9.81;                % gravitational acceleration (m/s^2)
dt = 0.01;               % time step
t_end = 5;               % simulation duration
e = 0.9;                 % coefficient of restitution (energy loss)
% Table/Window boundaries
xmin = 0; xmax = 2;
ymin = 0; ymax = 1;

% Initial conditions: [x, y, vx, vy]
state = [1, 0.5, 1, 2];

figure;
hold on;
axis([xmin xmax ymin ymax]);
h = plot(state(1), state(2), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');

for t = 0:dt:t_end
    % Update velocities due to gravity
    state(4) = state(4) - g * dt; % vy affected by gravity

    % Update positions
    state(1) = state(1) + state(3) * dt;
    state(2) = state(2) + state(4) * dt;

    % Check for collision with floor and ceiling (y-boundaries)
    if state(2) <= ymin
        state(2) = ymin; % reposition ball
        state(4) = -state(4) * e;
    elseif state(2) >= ymax
        state(2) = ymax;
        state(4) = -state(4) * e;
    end

    % Check for collision with left and right walls (x-boundaries)
    if state(1) <= xmin
        state(1) = xmin;
        state(3) = -state(3) * e;
    elseif state(1) >= xmax
        state(1) = xmax;
        state(3) = -state(3) * e;
    end

    % Update plot
    set(h, 'XData', state(1), 'YData', state(2));
    drawnow;
end

