%% path 2
ts = 0.5;
dt = 0.05;
v=0:dt:1;
v=[v ones(size(v))];
N=length(v);
phi=0:dt:pi;
dt=0.1;
x=zeros(N,2);
for k=2:N,
   U=[v(k-1)*cos(phi(k-1)),v(k-1)*sin(phi(k-1))]; 
   x(k,:)=x(k-1,:)+U;
end
L = length(x);
dx = diff(x); dx = [dx(1,:); dx];
v = normVec(dx)/ts; 
theta = atan2(dx(:,2),dx(:,1));

accuracy_x = [1, 1];

% Landmarks
% S =     [0 0;
%          1.5 4;
%          2 1];
S =     [6 4;
         8 15;
         12 20];
NS = size(S,1); % number of landmarks

%% Define noise and measurement
sigma=1; sigma_v = 0.02; sigma_theta = 0.002;

% angle distance (data to be measured)
v_measure = v + 2*(rand(size(v))-0.5)*sigma_v; 
theta_measure = theta + 2*(rand(size(theta))-0.5)*sigma_theta;

v_dist = abs(bsxfun(@minus,x(:,1) + 1i*x(:,2),S(:,1)' + 1i*S(:,2)'));
measureFunc = @(x,y,s) sqrt((x-s(1)).^2 + (y-s(2)).^2);
measure = v_dist + randn(size(v_dist))*sqrt(sigma); % Measured distance

% Define array with all measurement error functions
pe = cell(NS,1);
for m = 1:NS
        pe{m} = @(x,y,k) normpdf(measureFunc(x,y,S(m,:)),measure(k,m),sqrt(sigma));
end


     

