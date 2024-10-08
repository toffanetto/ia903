dqMatrix = [];

% Make sure to have the simulation scene mooc_exercise.ttt running in V-REP!

% simulation setup, will add the matlab paths
connection = simulation_setup();

% the robot we want to interact with
robotNb = 0;

% open the connection
connection = simulation_openConnection(connection, robotNb);

% start simulation if not already started
simulation_start(connection);

vrep=connection.vrep;

% initialize connection
% do a function simulation_getDt to do the following
dt= simulation_getDt(connection)

% now enable stepped simulation mode:
simulation_setStepped(connection,true);

    % given are the functions
    %   r_BF_inB(alpha,beta,gamma) and
    %   J_BF_inB(alpha,beta,gamma)
    % for the foot positon respectively Jacobian
    
    r_BF_inB = @(alpha,beta,gamma)[...
        - sin(beta + gamma) - sin(beta);...
        sin(alpha)*(cos(beta + gamma) + cos(beta) + 1) + 1;...
        -cos(alpha)*(cos(beta + gamma) + cos(beta) + 1)];
    
    J_BF_inB = @(alpha,beta,gamma)[...
        0,             - cos(beta + gamma) - cos(beta),            -cos(beta + gamma);...
        cos(alpha)*(cos(beta + gamma) + cos(beta) + 1), -sin(alpha)*(sin(beta + gamma) + sin(beta)), -sin(beta + gamma)*sin(alpha);...
        sin(alpha)*(cos(beta + gamma) + cos(beta) + 1),  cos(alpha)*(sin(beta + gamma) + sin(beta)),  sin(beta + gamma)*cos(alpha)];
    
    % write an algorithm for the inverse differntial kinematics problem to
    % find the generalized velocities dq to follow a circle in the body xz plane
    % around the start point rCenter with a radius of r=0.5 and a
    % frequeny of 1Hz. The start configuration is q =  pi/180*([0,-60,120])'
    q0 = pi/180*([0,-60,120])';
    %q0 = pi/180*([0,-80,140])';
    
    updatePos(vrep,connection.clientID,q0)
   % pause(1.0)

    dq0 = zeros(3,1);
    rCenter = r_BF_inB(q0(1),q0(2),q0(3));
    radius = 0.5;
    f = 0.25;
    rGoal = @(t) rCenter + radius*[sin(2*pi*f*t),0,cos(2*pi*f*t)]';
    drGoal = @(t) 2*pi*f*radius*[cos(2*pi*f*t),0,-sin(2*pi*f*t)]';
    
    % define here the time resolution
    deltaT = dt;%0.01;
    timeArr = 0:deltaT:1/f;
    
    % q, r, and rGoal are stored for every point in time in the following arrays
    qArr = zeros(3,length(timeArr));
    rArr = zeros(3,length(timeArr));
    rGoalArr = zeros(3,length(timeArr));
    
    q = q0;
    dq = dq0;
    
    kp = 10;
    
    for i=1:length(timeArr)
        t = timeArr(i);
        % data logging, don't change this!
        q = q+deltaT*dq;
        qArr(:,i) = q;
        rArr(:,i) = r_BF_inB(q(1),q(2),q(3));
        rGoalArr(:,i) = rGoal(t);
        
        % controller:
        % step 1: create a simple p controller to determine the desired foot
        % point velocity
        v = kp*(rGoalArr(:,i) - rArr(:,i));
        % step 2: perform inverse differential kinematics to calculate the
        % gneralized velocities
        dq = inv(J_BF_inB(q(1),q(2),q(3)))*v;
        
        updateVels(vrep,connection.clientID,dq,q)

    end


% now disable stepped simulation mode:
simulation_setStepped(connection,false);

% stop the simulation
simulation_stop(connection);

% close the connection
simulation_closeConnection(connection);

%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: D:\Drive Unicamp\00_Mestrado\Disciplinas\IA903 - Introdução à Robótica Móvel\Atividade1 - PATCHED\RoboticLeg\ex04ex05\code\coppelia_graph.csv
%
% Auto-generated by MATLAB on 14-Sep-2024 15:36:51

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 4);

% Specify range and delimiter
opts.DataLines = [3, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Times", "DataMeters", "Data0Meters", "Data1Meters"];
opts.VariableTypes = ["double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
coppeliagraph = readtable("D:\Drive Unicamp\00_Mestrado\Disciplinas\IA903 - Introdução à Robótica Móvel\Atividade1 - PATCHED\RoboticLeg\ex04ex05\code\coppelia_graph.csv", opts);

%% Convert to output type
coppeliagraph = table2array(coppeliagraph);

%% Clear temporary variables
clear opts

%% Plot

close all

n = linspace(coppeliagraph(1244,1),coppeliagraph(end-1,1),401);

figure(1)
plot(n,rArr(1,:),'Linewidth',2)
hold on
plot(n,rArr(2,:),'Linewidth',2)
plot(n,rArr(3,:),'Linewidth',2)
plot(coppeliagraph(1244:end-1,1),coppeliagraph(1244:end-1,2),'--','Linewidth',2)
plot(coppeliagraph(1244:end-1,1),coppeliagraph(1244:end-1,3),'--','Linewidth',2)
plot(coppeliagraph(1244:end-1,1),coppeliagraph(1244:end-1,4),'--','Linewidth',2)
axis([0.09 4.2 -3 1.1])
xlabel('Time [s]')
ylabel('Position [m]')
title('Comparison between position real vs calculated')
grid on
legend('x_C(1)','y_C(2)','z_C(3)','x_R(1)','y_R(2)','z_R(3)','Location','northeastoutside')
hold off

n = length(coppeliagraph(1244:end-1,3));
m = length(rArr(1,:));

x = interp1(linspace(1,n,m)',rArr(1,:),(1:n)');
y = interp1(linspace(1,n,m)',rArr(2,:),(1:n)');
z = interp1(linspace(1,n,m)',rArr(3,:),(1:n)');

figure(1)
plot3(x,y,z,coppeliagraph(1244:end-1,2),coppeliagraph(1244:end-1,3),coppeliagraph(1244:end-1,4),'--','Linewidth',2)
hold on
xlabel('x')
ylabel('y')
zlabel('z')
title('Comparison between position real vs calculated')
grid on
legend('Calculated','Real')
hold off

% exportgraphics(gca,'effector_position.png','Resolution',300)