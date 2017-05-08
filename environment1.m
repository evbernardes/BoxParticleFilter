%% robot path 1
N=10;
phi = 0:pi/N/2:pi/2; % angle points in the curve section
x1=[0:1/N:1-1/N, 1+sin(phi), 2*ones(1,3*N)];  % component 1
x2=[ ones(1,N) 2-cos(phi), 2+1/N:1/N:5];    % component 2
xb0 = [x1',x2']; %evs
L = length(xb0);
accuracy_x = [0.3, 0.3];

% Landmarks
S =     [0 0;
         1.5 4;
         2 1];
NS = length(S); % number of landmarks

R=0.05; % Defines the noise
v_dist = abs(bsxfun(@minus,xb0(:,1) + 1i*xb0(:,2),S(:,1)' + 1i*S(:,2)'));
v_measured = v_dist + randn(size(v_dist))*sqrt(R); % Measured distance

     

