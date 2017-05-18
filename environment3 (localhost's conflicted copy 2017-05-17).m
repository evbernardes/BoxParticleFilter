%% path 2
dt = 0.15;
th = 0:dt:2*pi;
xb0 = 5*[cos(th)',sin(th)']; xb0 = xb0 + 5;
N = length(xb0);

accuracy_x = [1, 1];

% Landmarks
S =     [5 5];
%         6 7];
NS = size(S,1); % number of landmarks

sigma=0.05; % Defines the noise
sigma = 0.001;
theta_real = zeros(N,NS);
for i = 1:NS
    dist = bsxfun(@minus,xb0,S(i,:));
    theta_real(:,i) = atan2(dist(:,2),dist(:,1));
end


%% Theta: Definition of measure and error distribution
theta_measure = theta_real + randn(size(theta_real))*sqrt(sigma); % Measured distance
theta_measure_Func = @(x,y,s) atan2(y - s(2),x + s(1));
pe = cell(NS,1);
for m = 1:NS
        pe{m} = @(x,y,k) normpdf(theta_measure_Func(x,y,S(m,:)),theta_measure(k,m),sqrt(sigma));
end

%% Vel: Definition of measure and error distribution
sigmav = 0.01;
vel = [0,0;diff(xb0)];
vel_measure = vel + randn(size(vel));
vel_measure_Func = @(x,y,s) atan2(y - s(2),x + s(1));

@(x,y,k) normpdf(vel_measure_Func(x,y),vel_measure(k),sqrt(sigma));


     

