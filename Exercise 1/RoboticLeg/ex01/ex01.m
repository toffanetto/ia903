clc; clear all;

syms alpha beta gamma real

% write down the rotation matrices using the symbolic parameters alpha, beta, gamma

% Rotation arround 1_e_x
R_B1 = [1 0          0; ...
        0 cos(alpha) -sin(alpha); ...
        0 sin(alpha) cos(alpha) ;];
    
% Rotation arround 2_e_y
R_12 = [cos(beta)  0 sin(beta); ...
        0          1 0; ...
        -sin(beta) 0 cos(beta);];
    
% Rotation arround 3_e_y
R_23 = [cos(gamma)  0 sin(gamma); ...
        0          1 0; ...
        -sin(gamma) 0 cos(gamma);];

% answers
valid

