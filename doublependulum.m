classdef doublependulum
    properties
        g;
        L1;
        L2;
        m1;
        m2;
        dt;
    end

    methods
        %obj function created here
        function obj = doublependulum(g,L1,L2,m1,m2,dt)
            %cursor validated the values
            %i dont think i will
            obj.g = g;
            obj.L1 = L1;
            obj.L2 = L2;
            obj.m1 = m1;
            obj.m2 = m2;
            obj.dt = dt;
        end
    


        %this class will be called when creating a new pendulum
        %like pendu = doublependulum(g,L1,....)
        
        
        
        %now need derivative of prev params
        %to get velo and accel
        function dY = calculatederivatives(obj, ~, Y)
            theta1 = Y(1);
            omega1 = Y(2);
            theta2 = Y(3);
            omega2 = Y(4);
            
            m1 = obj.m1;
            m2 = obj.m2;
            L1 = obj.L1;
            L2 = obj.L2;
            g = obj.g;

            delta = theta2 - theta1;
            den1 = (m1 + m2) * L1 - m2 * L1 * cos(delta)^2;
            den2 = (L2/L1) * den1;

            % Angular accelerations (from double pendulum equations)
            alpha1 = (m2 * L1 * omega1^2 * sin(delta) * cos(delta) + ...
                     m2 * g * sin(theta2) * cos(delta) + ...
                     m2 * L2 * omega2^2 * sin(delta) - ...
                     (m1 + m2) * g * sin(theta1)) / den1;

            alpha2 = (-m2 * L2 * omega2^2 * sin(delta) * cos(delta) + ...
                     (m1 + m2) * (g * sin(theta1) * cos(delta) - ...
                     L1 * omega1^2 * sin(delta) - ...
                     g * sin(theta2))) / den2;

            dY = [omega1; alpha1; omega2; alpha2];
        end



        %implement RK4 now:
        function Y_next = rk4step(obj,t,Y)
            h = obj.dt; %eda time step

            k1 = obj.calculatederivatives(t,Y);
            k2 = obj.calculatederivatives(t+h/2, Y+h*k1/2);
            k3 = obj.calculatederivatives(t+h/2, Y+h*k2/2);
            k4 = obj.calculatederivatives(t+h, Y+h*k3);

            Y_next = Y + (h/6) * (k1+2*k2 + 2*k3+k4);
        end


        %function to simulate 2 double pendulums:
        function [time, Y1, Y2] = simulatecomparison(obj,tstart,tend,IC1,IC2)
            time = tstart: obj.dt: tend;
            n = length(time);
            
            %initializing storage array
            Y1 = zeros(n,4);
            Y2 = zeros(n,4);

            %initial cond in first row
            Y1(1,:) = IC1';
            Y2(1,:) = IC2';
            

            %storing value for every RK4 iteration
            for i = 1:n-1
                Y1(i+1,:) = obj.rk4step(time(i), Y1(i,:)')';
                Y2(i+1,:) = obj.rk4step(time(i), Y2(i,:)')';

            end
        end

        %function to simulate a single double pendulum:
        function [time, Y] = simulate(obj, tstart, tend, IC)
            time = tstart: obj.dt: tend;
            n = length(time);
            Y = zeros(n,4);
            Y(1,:) = IC';
            for i = 1:n-1
                Y(i+1,:) = obj.rk4step(time(i), Y(i,:)')';
            end
        end
    end
end
