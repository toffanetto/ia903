function [f, F_x, F_u] = transitionFunction(x,u, l)
% [f, F_x, F_u] = transitionFunction(x,u,l) predicts the state x at time t given
% the state at time t-1 and the input u at time t. F_x denotes the Jacobian
% of the state transition function with respect to the state evaluated at
% the state and input provided. F_u denotes the Jacobian of the state
% transition function with respect to the input evaluated at the state and
% input provided.
% State and input are defined according to "Introduction to Autonomous Mobile Robots", pp. 337

%STARTRM

f = x +  [(u(1) + u(2))/2*cos(x(3) + ((u(2)-u(1))/(2*l))); ...
      (u(1) + u(2))/2*sin(x(3) + ((u(2)-u(1))/(2*l))); ...
      (u(2) - u(1))/l ];

F_x = [1, 0, -(u(1) + u(2))/2*sin(x(3)+(u(2)-u(1))/(2*l)); ...
       0, 1, (u(1) + u(2))/2*cos(x(3)+(u(2)-u(1))/(2*l)); ...
       0, 0, 1];

F_u = [(cos(x(3) + (u(2)-u(1))/(2*l))/2 + (u(1) + u(2))/(2*2*l)*sin(x(3) + (u(2)-u(1))/(2*l))), ...
       (cos(x(3) + (u(2)-u(1))/(2*l))/2 - (u(1) + u(2))/(2*2*l)*sin(x(3) + (u(2)-u(1))/(2*l))); ...
       (sin(x(3) + (u(2)-u(1))/(2*l))/2 - (u(1) + u(2))/(2*2*l)*cos(x(3) + (u(2)-u(1))/(2*l))), ...
       (sin(x(3) + (u(2)-u(1))/(2*l))/2 + (u(1) + u(2))/(2*2*l)*cos(x(3) + (u(2)-u(1))/(2*l))); ...
       -1/l, 1/l];    


%ENDRM
