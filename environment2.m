%% path 2
dt = 0.05;
v=0:dt:1;
v=[v ones(size(v))];
N=length(v);
phi=0:dt:pi;
dt=0.1;
xb0=zeros(N,2);
for k=2:N,
   U=[v(k-1)*cos(phi(k-1)),v(k-1)*sin(phi(k-1))]; 
   xb0(k,:)=xb0(k-1,:)+U;
end
L = length(xb0);

accuracy_x = [1, 1];

% Landmarks
% S =     [0 0;
%          1.5 4;
%          2 1];
S =     [6 4;
         8 15;
         12 20];
NS = length(S); % number of landmarks

R=0.05; % Defines the noise
v_dist = abs(bsxfun(@minus,xb0(:,1) + 1i*xb0(:,2),S(:,1)' + 1i*S(:,2)'));
v_measured = v_dist + randn(size(v_dist))*sqrt(R); % Measured distance

     

