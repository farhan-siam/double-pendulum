function visualize(time,Y1,Y2,L1_1,L2_1,L1_2,L2_2,showPends,hAxes,showTrace,stopFlag,pauseFlag,setFrame,getFrame,speedFactor)
    % showPends: [Pendulum 1, Pendulum 2]
    if nargin < 8
        showPends = [1 1];
    end
    if nargin < 10
        showTrace = true;
    end
    if nargin < 11
        stopFlag = [];
    end
    if nargin < 12
        pauseFlag = [];
    end
    if nargin < 13
        setFrame = [];
    end
    if nargin < 14
        getFrame = [];
    end
    if nargin < 15
        speedFactor = [];
    end
    use_gui_axes = (nargin >= 9) && ~isempty(hAxes) && ishandle(hAxes);
    if ~use_gui_axes
        hFig = figure('position',[100,100,800,600]);
        hAxes = gca;
    end
    N = length(time);
    skip = 1; % plot every frame for smooth animation
    % Precompute all positions for traces
    x1_trace_1 = L1_1*sin(Y1(:,1));
    y1_trace_1 = -L1_1*cos(Y1(:,1));
    x2_trace_1 = x1_trace_1 + L2_1*sin(Y1(:,3));
    y2_trace_1 = y1_trace_1 + -L2_1*cos(Y1(:,3));
    x1_trace_2 = L1_2*sin(Y2(:,1));
    y1_trace_2 = -L1_2*cos(Y2(:,1));
    x2_trace_2 = x1_trace_2 + L2_2*sin(Y2(:,3));
    y2_trace_2 = y1_trace_2 + -L2_2*cos(Y2(:,3));
    % Initial positions for all bobs and arms
    theta1_1 = Y1(1,1); theta2_1 = Y1(1,3);
    x1_1 = L1_1*sin(theta1_1); x2_1 = x1_1 + L2_1*sin(theta2_1);
    y1_1 = -L1_1*cos(theta1_1); y2_1 = y1_1 + -L2_1*cos(theta2_1);
    theta1_2 = Y2(1,1); theta2_2 = Y2(1,3);
    x1_2 = L1_2*sin(theta1_2); x2_2 = x1_2 + L2_2*sin(theta2_2);
    y1_2 = -L1_2*cos(theta1_2); y2_2 = y1_2 + -L2_2*cos(theta2_2);
    % Clear and set up axes
    cla(hAxes);
    hold(hAxes, 'on');
    axis(hAxes, 'equal');
    axis(hAxes, [-3, 3, -3, 3]);
    grid(hAxes, 'on');
    % Create trace plot objects (empty at first)
    if showPends(1)
        hTrace1 = plot(hAxes, nan, nan, 'b-', 'LineWidth', 1.5);
    else
        hTrace1 = plot(hAxes, nan, nan, 'b-');
    end
    if showPends(2)
        hTrace2 = plot(hAxes, nan, nan, 'r-', 'LineWidth', 1.5);
    else
        hTrace2 = plot(hAxes, nan, nan, 'r-');
    end
    % Add legend for the two pendulums
    legendEntries = {};
    legendHandles = [];
    if showPends(1)
        legendEntries{end+1} = 'Pendulum 1';
        legendHandles(end+1) = hTrace1;
    end
    if showPends(2)
        legendEntries{end+1} = 'Pendulum 2';
        legendHandles(end+1) = hTrace2;
    end
    if ~isempty(legendEntries)
        legend(hAxes, legendHandles, legendEntries, 'Location', 'northeast');
    end
    % Create plot objects (lines and bobs)
    % Pendulum 1
    if showPends(1)
        hArm1_1 = plot(hAxes, [0 x1_1], [0 y1_1], 'b-', 'LineWidth', 2);
        hArm2_1 = plot(hAxes, [x1_1 x2_1], [y1_1 y2_1], 'b-', 'LineWidth', 2);
        hBob1_1 = plot(hAxes, x1_1, y1_1, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
        hBob2_1 = plot(hAxes, x2_1, y2_1, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
    else
        hArm1_1 = plot(hAxes, nan, nan, 'b-');
        hArm2_1 = plot(hAxes, nan, nan, 'b-');
        hBob1_1 = plot(hAxes, nan, nan, 'bo');
        hBob2_1 = plot(hAxes, nan, nan, 'bo');
    end
    % Pendulum 2
    if showPends(2)
        hArm1_2 = plot(hAxes, [0 x1_2], [0 y1_2], 'r--', 'LineWidth', 2);
        hArm2_2 = plot(hAxes, [x1_2 x2_2], [y1_2 y2_2], 'r--', 'LineWidth', 2);
        hBob1_2 = plot(hAxes, x1_2, y1_2, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
        hBob2_2 = plot(hAxes, x2_2, y2_2, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
    else
        hArm1_2 = plot(hAxes, nan, nan, 'r--');
        hArm2_2 = plot(hAxes, nan, nan, 'r--');
        hBob1_2 = plot(hAxes, nan, nan, 'ro');
        hBob2_2 = plot(hAxes, nan, nan, 'ro');
    end
    hold(hAxes, 'off');
    % Animation loop with pause/resume support
    if ~isempty(getFrame)
        i = getFrame();
        if isempty(i) || i < 1 || i > N
            i = 1;
        end
    else
        i = 1;
    end
    while i <= N
        if ~isempty(stopFlag) && stopFlag()
            break;
        end
        if ~isempty(setFrame)
            setFrame(i);
        end
        % Pause logic
        while ~isempty(pauseFlag) && pauseFlag()
            drawnow;
            if ~isempty(stopFlag) && stopFlag()
                return;
            end
            pause(0.01);
        end
        theta1_1 = Y1(i,1); theta2_1 = Y1(i,3);
        x1_1 = L1_1*sin(theta1_1); x2_1 = x1_1 + L2_1*sin(theta2_1);
        y1_1 = -L1_1*cos(theta1_1); y2_1 = y1_1 + -L2_1*cos(theta2_1);
        theta1_2 = Y2(i,1); theta2_2 = Y2(i,3);
        x1_2 = L1_2*sin(theta1_2); x2_2 = x1_2 + L2_2*sin(theta2_2);
        y1_2 = -L1_2*cos(theta1_2); y2_2 = y1_2 + -L2_2*cos(theta2_2);
        % Update traces
        if showTrace && showPends(1)
            set(hTrace1, 'XData', x2_trace_1(1:i), 'YData', y2_trace_1(1:i));
        else
            set(hTrace1, 'XData', nan, 'YData', nan);
        end
        if showTrace && showPends(2)
            set(hTrace2, 'XData', x2_trace_2(1:i), 'YData', y2_trace_2(1:i));
        else
            set(hTrace2, 'XData', nan, 'YData', nan);
        end
        % Update plot data
        if showPends(1)
            set(hArm1_1, 'XData', [0 x1_1], 'YData', [0 y1_1]);
            set(hArm2_1, 'XData', [x1_1 x2_1], 'YData', [y1_1 y2_1]);
            set(hBob1_1, 'XData', x1_1, 'YData', y1_1);
            set(hBob2_1, 'XData', x2_1, 'YData', y2_1);
        end
        if showPends(2)
            set(hArm1_2, 'XData', [0 x1_2], 'YData', [0 y1_2]);
            set(hArm2_2, 'XData', [x1_2 x2_2], 'YData', [y1_2 y2_2]);
            set(hBob1_2, 'XData', x1_2, 'YData', y1_2);
            set(hBob2_2, 'XData', x2_2, 'YData', y2_2);
        end
        title(hAxes, sprintf('Time: %.2f s', time(i)));
        drawnow limitrate;
        p = 0.01;
        if ~isempty(speedFactor)
            s = speedFactor();
            if s > 0
                p = p / s;
            end
        end
        pause(p);
        i = i + skip;
    end
end