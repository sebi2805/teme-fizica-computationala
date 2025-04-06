function testIteratii
    pkg load control;

    fig = figure('Name', 'H(s) = 2s/(2s^2 + 6s + 2)', ...
                 'Position', [100, 100, 600, 500]);
    myImg = imread('C:\Users\User\Desktop\university\FC\1.a.png');
    axesImg = axes('Parent', fig, 'Units', 'pixels', ...
                   'Position', [150, 350, 300, 120]);
    imshow(myImg, 'Parent', axesImg);

    uicontrol('Style', 'pushbutton', ...
              'Position', [220, 250, 150, 40], ...
              'String', 'Rulează 10 valori', ...
              'Callback', @ruleazaIteratii);

    H = tf([2 0], [2 6 2]);

    bodeFig = figure('Name', 'Bode Plot H(s)');
    bode(H); grid on; title('Bode Plot pentru H(s)');

    respFig = figure('Name', 'Răspunsuri H(s)', ...
                     'Position', [200, 100, 700, 500]);
    clf(respFig);

    combinedFig = figure('Name', 'Combined signals', ...
                         'Position', [950, 100, 700, 500]);

    function ruleazaIteratii(~, ~)
        minVal = 0;
        maxVal = 10;
        nPassi = 10;  % câte valori
        durata = 5;   % 5 secunde total

        for i = 1:nPassi
            VinCurent = minVal + (maxVal - minVal)*(i-1)/(nPassi-1);

            updateResponses(H, VinCurent, respFig);
            updateAllSignals(H, VinCurent, combinedFig);

            pause(durata / nPassi);
            drawnow;
        end
    end
end

function updateResponses(H, Vin, respFig)
    t = linspace(0, 50, 1000);

    [yStep, tStep] = step(Vin * H, t);
    [yImp, tImp]   = impulse(Vin * H, t);

    uRamp = Vin * t;
    yRamp = lsim(H, uRamp, t);

    uSine = Vin * sin(2*pi*1*t);
    ySine = lsim(H, uSine, t);

    figure(respFig);
    clf;

    subplot(2,2,1);
    plot(tStep, yStep); grid on;
    title(['Step (Vin = ', num2str(Vin, '%.2f'), ')']);
    xlabel('Timp (s)'); ylabel('Amplitudine');

    subplot(2,2,2);
    plot(tImp, yImp); grid on;
    title('Impulse');
    xlabel('Timp (s)'); ylabel('Amplitudine');

    subplot(2,2,3);
    plot(t, yRamp); grid on;
    title('Ramp');
    xlabel('Timp (s)'); ylabel('Amplitudine');

    subplot(2,2,4);
    plot(t, ySine); grid on;
    title('Sinus (1 Hz)');
    xlabel('Timp (s)'); ylabel('Amplitudine');
end

function updateAllSignals(H, Vin, combinedFig)
    t = linspace(0, 50, 1000);

    [yStep, tStep] = step(Vin * H, t);
    [yImp, tImp]   = impulse(Vin * H, t);

    uRamp = Vin * t;
    yRamp = lsim(H, uRamp, t);

    uSine = Vin * sin(2*pi*1*t);
    ySine = lsim(H, uSine, t);

    figure(combinedFig);
    clf;
    hold on;

    plot(tStep, yStep, 'DisplayName', ['Step, Vin=' num2str(Vin, '%.2f')]);
    plot(tImp,  yImp,  'DisplayName', ['Imp, Vin='  num2str(Vin, '%.2f')]);
    plot(t,     yRamp, 'DisplayName', ['Ramp, Vin=' num2str(Vin, '%.2f')]);
    plot(t,     ySine, 'DisplayName', ['Sin, Vin='  num2str(Vin, '%.2f')]);

    grid on;
    legend('Location', 'best');
    title('Combined signals');
    xlabel('Timp (s)');
    ylabel('Amplitudine');
end

