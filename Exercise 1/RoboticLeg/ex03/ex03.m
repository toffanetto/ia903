clc; clear all;

syms alpha beta gamma real

q = [alpha;beta;gamma];

r_BF_inB = [...
    - sin(beta + gamma) - sin(beta);...
  sin(alpha)*(cos(beta + gamma) + cos(beta) + 1) + 1;...
  -cos(alpha)*(cos(beta + gamma) + cos(beta) + 1)]


% determine the foot point Jacobian J_BF_inB=d(r_BF_inB)/dq
dr_dalpha = [0; ...
             cos(alpha)*(cos(beta + gamma) + cos(beta) + 1); ...
             sin(alpha)*(cos(beta + gamma) + cos(beta) + 1)];

dr_dbeta = [-cos(beta + gamma) + cos(beta); ...
            sin(alpha)*(-sin(beta + gamma) -sin(beta)); ...
            cos(alpha)*(+sin(beta + gamma) +sin(beta))];
        
dr_dgamma = [-cos(beta + gamma); ...
             -sin(alpha)*sin(beta + gamma); ...
             cos(alpha)*sin(beta + gamma)];
        
J_BF_inB = [dr_dalpha dr_dbeta dr_dgamma] 


% what generalized velocity dq do you have to apply in a configuration q = [0;60�;-120�]
% to lift the foot in vertical direction with v = [0;0;-1m/s];
v = [0; 0; -1]
qi = [0; 60*(pi/180); -120*(pi/180)];

% Determine the numerical value of the foot point jacobian for initial joint angles qi

alpha = qi(1);
beta = qi(2);
gamma = qi(3);

dr_dalpha = [0; ...
             cos(alpha)*(cos(beta + gamma) + cos(beta) + 1); ...
             sin(alpha)*(cos(beta + gamma) + cos(beta) + 1)];

dr_dbeta = [-cos(beta + gamma) - cos(beta); ...
            sin(alpha)*(-sin(beta + gamma) -sin(beta)); ...
            cos(alpha)*(sin(beta + gamma) +sin(beta))];
        
dr_dgamma = [-cos(beta + gamma); ...
             -sin(alpha)*sin(beta + gamma); ...
             cos(alpha)*sin(beta + gamma)];
        
JBF = [dr_dalpha dr_dbeta dr_dgamma] 
    
% Determine the numerical value for dq
dq = inv(JBF)*v

valid
