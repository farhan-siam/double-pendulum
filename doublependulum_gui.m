function doublependulum_gui()
    % Create the main figure
    hFig = figure('Name', 'Double Pendulum Simulator (2 Pendulums)', 'NumberTitle', 'off', 'Position', [100 100 1200 600]);
    
    % Default values for both pendulums
    defaults1 = struct('theta1', 1.57, 'theta2', 1.57, 'omega1', 0, 'omega2', 2, ...
        'm1', 1, 'm2', 1, 'l1', 1, 'l2', 1);
    defaults2 = struct('theta1', 1.57, 'theta2', 1.56, 'omega1', 0, 'omega2', 2, ...
        'm1', 1, 'm2', 1, 'l1', 1, 'l2', 1);
    g_default = 9.81;
    T_default = 10;
    dt = 0.01; % fixed time step
    
    % UI controls for initial conditions (Pendulum 1)
    uicontrol('Style', 'text', 'Position', [20 380 120 20], 'String', 'Pendulum 1', 'FontWeight', 'bold');
    uicontrol('Style', 'text', 'Position', [20 350 80 20], 'String', 'Theta 1 (rad)');
    hTheta1_1 = uicontrol('Style', 'edit', 'Position', [110 350 60 25], 'String', num2str(defaults1.theta1));
    uicontrol('Style', 'text', 'Position', [20 320 80 20], 'String', 'Theta 2 (rad)');
    hTheta2_1 = uicontrol('Style', 'edit', 'Position', [110 320 60 25], 'String', num2str(defaults1.theta2));
    uicontrol('Style', 'text', 'Position', [20 290 80 20], 'String', 'Omega 1 (rad/s)');
    hOmega1_1 = uicontrol('Style', 'edit', 'Position', [110 290 60 25], 'String', num2str(defaults1.omega1));
    uicontrol('Style', 'text', 'Position', [20 260 80 20], 'String', 'Omega 2 (rad/s)');
    hOmega2_1 = uicontrol('Style', 'edit', 'Position', [110 260 60 25], 'String', num2str(defaults1.omega2));
    uicontrol('Style', 'text', 'Position', [20 230 80 20], 'String', 'Mass 1 (kg)');
    hM1_1 = uicontrol('Style', 'edit', 'Position', [110 230 60 25], 'String', num2str(defaults1.m1));
    uicontrol('Style', 'text', 'Position', [20 200 80 20], 'String', 'Mass 2 (kg)');
    hM2_1 = uicontrol('Style', 'edit', 'Position', [110 200 60 25], 'String', num2str(defaults1.m2));
    uicontrol('Style', 'text', 'Position', [20 170 80 20], 'String', 'Length 1 (m)');
    hL1_1 = uicontrol('Style', 'edit', 'Position', [110 170 60 25], 'String', num2str(defaults1.l1));
    uicontrol('Style', 'text', 'Position', [20 140 80 20], 'String', 'Length 2 (m)');
    hL2_1 = uicontrol('Style', 'edit', 'Position', [110 140 60 25], 'String', num2str(defaults1.l2));
    
    % UI controls for initial conditions (Pendulum 2)
    uicontrol('Style', 'text', 'Position', [200 380 120 20], 'String', 'Pendulum 2', 'FontWeight', 'bold');
    uicontrol('Style', 'text', 'Position', [200 350 80 20], 'String', 'Theta 1 (rad)');
    hTheta1_2 = uicontrol('Style', 'edit', 'Position', [290 350 60 25], 'String', num2str(defaults2.theta1));
    uicontrol('Style', 'text', 'Position', [200 320 80 20], 'String', 'Theta 2 (rad)');
    hTheta2_2 = uicontrol('Style', 'edit', 'Position', [290 320 60 25], 'String', num2str(defaults2.theta2));
    uicontrol('Style', 'text', 'Position', [200 290 80 20], 'String', 'Omega 1 (rad/s)');
    hOmega1_2 = uicontrol('Style', 'edit', 'Position', [290 290 60 25], 'String', num2str(defaults2.omega1));
    uicontrol('Style', 'text', 'Position', [200 260 80 20], 'String', 'Omega 2 (rad/s)');
    hOmega2_2 = uicontrol('Style', 'edit', 'Position', [290 260 60 25], 'String', num2str(defaults2.omega2));
    uicontrol('Style', 'text', 'Position', [200 230 80 20], 'String', 'Mass 1 (kg)');
    hM1_2 = uicontrol('Style', 'edit', 'Position', [290 230 60 25], 'String', num2str(defaults2.m1));
    uicontrol('Style', 'text', 'Position', [200 200 80 20], 'String', 'Mass 2 (kg)');
    hM2_2 = uicontrol('Style', 'edit', 'Position', [290 200 60 25], 'String', num2str(defaults2.m2));
    uicontrol('Style', 'text', 'Position', [200 170 80 20], 'String', 'Length 1 (m)');
    hL1_2 = uicontrol('Style', 'edit', 'Position', [290 170 60 25], 'String', num2str(defaults2.l1));
    uicontrol('Style', 'text', 'Position', [200 140 80 20], 'String', 'Length 2 (m)');
    hL2_2 = uicontrol('Style', 'edit', 'Position', [290 140 60 25], 'String', num2str(defaults2.l2));
    
    % Gravity and time (shared)
    uicontrol('Style', 'text', 'Position', [20 100 80 20], 'String', 'Gravity (m/s^2)');
    hG = uicontrol('Style', 'edit', 'Position', [110 100 60 25], 'String', num2str(g_default));
    uicontrol('Style', 'text', 'Position', [20 70 80 20], 'String', 'Time (s)');
    hT = uicontrol('Style', 'edit', 'Position', [110 70 60 25], 'String', num2str(T_default));
    
    % Checkboxes for pendulums
    uicontrol('Style', 'text', 'Position', [400 400 180 20], 'String', 'Show Pendulums:', 'FontWeight', 'bold');
    hShowPend1 = uicontrol('Style', 'checkbox', 'Position', [400 370 160 25], 'String', 'Show Pendulum 1', 'Value', 1);
    hShowPend2 = uicontrol('Style', 'checkbox', 'Position', [400 340 160 25], 'String', 'Show Pendulum 2', 'Value', 1);
    % Checkbox for trace
    hShowTrace = uicontrol('Style', 'checkbox', 'Position', [400 310 160 25], 'String', 'Show Trace', 'Value', 1);
    
    % Axes for visualization (bigger)
    hAxes = axes('Parent', hFig, 'Units', 'pixels', 'Position', [600 60 550 500]);
    
    % Start button
    uicontrol('Style', 'pushbutton', 'String', 'Start Simulation', 'Position', [40 10 120 30], ...
        'Callback', @(~,~) startSimulation());
    
    % Stop button and stop flag using setappdata/getappdata
    setappdata(hFig, 'stopFlag', false);
    setappdata(hFig, 'pauseFlag', false);
    setappdata(hFig, 'currentFrame', 1);
    setappdata(hFig, 'speedFactor', 1);
    hStopBtn = uicontrol('Style', 'pushbutton', 'String', 'Stop Simulation', 'Position', [180 10 120 30], ...
        'Callback', @(~,~) setappdata(hFig, 'stopFlag', true));

    % Pause/Continue button
    hPauseBtn = uicontrol('Style', 'pushbutton', 'String', 'Pause', 'Position', [320 10 120 30], ...
        'Callback', @(src,~) togglePause(src));

    % 2x Speed button
    hSpeedBtn = uicontrol('Style', 'pushbutton', 'String', '2x Speed', 'Position', [460 10 120 30], ...
        'Callback', @(src,~) toggleSpeed(src));

    function togglePause(src)
        isPaused = getappdata(hFig, 'pauseFlag');
        if ~isPaused
            setappdata(hFig, 'pauseFlag', true);
            set(src, 'String', 'Continue');
        else
            setappdata(hFig, 'pauseFlag', false);
            set(src, 'String', 'Pause');
        end
    end

    function toggleSpeed(src)
        speed = getappdata(hFig, 'speedFactor');
        if speed == 1
            setappdata(hFig, 'speedFactor', 2);
            set(src, 'String', '1x Speed');
        else
            setappdata(hFig, 'speedFactor', 1);
            set(src, 'String', '2x Speed');
        end
    end
    
    function startSimulation()
        setappdata(hFig, 'stopFlag', false); % Reset stop flag at start
        setappdata(hFig, 'pauseFlag', false); % Reset pause flag at start
        set(hPauseBtn, 'String', 'Pause'); % Reset button label
        setappdata(hFig, 'currentFrame', 1); % Reset frame index
        setappdata(hFig, 'speedFactor', 1); % Reset speed to 1x
        set(hSpeedBtn, 'String', '2x Speed'); % Reset speed button label
        % Get user input for pendulum 1
        theta1_1 = str2double(get(hTheta1_1, 'String'));
        theta2_1 = str2double(get(hTheta2_1, 'String'));
        omega1_1 = str2double(get(hOmega1_1, 'String'));
        omega2_1 = str2double(get(hOmega2_1, 'String'));
        m1_1 = str2double(get(hM1_1, 'String'));
        m2_1 = str2double(get(hM2_1, 'String'));
        l1_1 = str2double(get(hL1_1, 'String'));
        l2_1 = str2double(get(hL2_1, 'String'));
        
        % Get user input for pendulum 2
        theta1_2 = str2double(get(hTheta1_2, 'String'));
        theta2_2 = str2double(get(hTheta2_2, 'String'));
        omega1_2 = str2double(get(hOmega1_2, 'String'));
        omega2_2 = str2double(get(hOmega2_2, 'String'));
        m1_2 = str2double(get(hM1_2, 'String'));
        m2_2 = str2double(get(hM2_2, 'String'));
        l1_2 = str2double(get(hL1_2, 'String'));
        l2_2 = str2double(get(hL2_2, 'String'));
        
        % Shared gravity and time
        g = str2double(get(hG, 'String'));
        T = str2double(get(hT, 'String'));
        t0 = 0;
        tf = T;
        
        % Initial conditions and params for both
        IC1 = [theta1_1; omega1_1; theta2_1; omega2_1];
        IC2 = [theta1_2; omega1_2; theta2_2; omega2_2];
        
        % Use individual lengths for each pendulum
        L1_1 = l1_1;
        L2_1 = l2_1;
        L1_2 = l1_2;
        L2_2 = l2_2;
        
        % Pendulum visibility options
        showPends = [get(hShowPend1,'Value'), get(hShowPend2,'Value')];
        % Trace visibility option
        showTrace = get(hShowTrace,'Value');
        % [Pendulum 1, Pendulum 2]
        
        % Create pendulum objects and simulate each separately
        pendulum1 = doublependulum(g, L1_1, L2_1, m1_1, m2_1, dt);
        pendulum2 = doublependulum(g, L1_2, L2_2, m1_2, m2_2, dt);
        [time, Y1] = pendulum1.simulate(t0, tf, IC1);
        [~, Y2] = pendulum2.simulate(t0, tf, IC2);
        
        % Visualize both, pass stopFlag and pauseFlag by handle, and currentFrame
        cla(hAxes);
        visualize(time, Y1, Y2, L1_1, L2_1, L1_2, L2_2, showPends, hAxes, showTrace, @() getappdata(hFig, 'stopFlag'), @() getappdata(hFig, 'pauseFlag'), @(val) setappdata(hFig, 'currentFrame', val), @() getappdata(hFig, 'currentFrame'), @() getappdata(hFig, 'speedFactor'));
    end
end 