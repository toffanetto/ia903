function [ vu, omega ] = calculateControlOutput( robotPose, goalPose, parameters )
%CALCULATECONTROLOUTPUT This function computes the motor velocities for a differential driven robot

% current robot position and orientation
x = robotPose(1);
y = robotPose(2);
theta = robotPose(3);

% goal position and orientation
xg = goalPose(1);
yg = goalPose(2);
thetag = goalPose(3);

% compute control quantities
rho = sqrt((xg-x)^2+(yg-y)^2);  % pythagoras theorem, sqrt(dx^2 + dy^2)
lambda = atan2(yg-y, xg-x);     % angle of the vector pointing from the robot to the goal in the inertial frame
alpha = lambda - theta;         % angle of the vector pointing from the robot to the goal in the robot frame
alpha = normalizeAngle(alpha);

% the following paramerters should be used:
% Task 3:
% parameters.Kalpha, parameters.Kbeta, parameters.Krho: controller tuning parameters

vi = parameters.Krho*rho;
wi = parameters.Kalpha*alpha;

% Task 4:
% parameters.backwardAllowed: This boolean variable should switch the between the two controllers
% parameters.useConstantSpeed: Turn on constant speed option
% parameters.constantSpeed: The speed used when constant speed option is on

sv = 1;

if parameters.backwardAllowed
    if abs(alpha) > pi/2
        sv = -1;
        alpha = normalizeAngle(alpha + pi);
    end
end

v = parameters.Krho*rho;
w = parameters.Kalpha*alpha;

if parameters.useConstantSpeed
    if rho > parameters.dist_threshold*2
        w = w*(parameters.constantSpeed/v);
        v = parameters.constantSpeed*sv;
    else
        w = wi; 
        v = parameters.Krho*rho*sv;
    end
end

vu = v; % [m/s]
omega = w; % [rad/s]
end

