normVec = @(a) sqrt(sum(a.^2,2));

%% Path definition
% Circle of radius 5 centered at (5,5)

ts = 0.15; % sampling frequency

th = 0:ts:2*pi;
% real state values
x = 5*[cos(th)',sin(th)']; x = x + 5;
dx = diff(x); dx = [dx(1,:);dx];
N = length(x);
v = normVec(dx)/ts; 
theta = atan2(dx(:,2),dx(:,1));

% Landmarks
S =     [5 5];
NS = size(S,1); % number of landmarks

% noise
sigma=0.1; sigma_v = 0.02; sigma_theta = 0.02;

%% Measure y1 (angle difference from x3 to landmark)

% angle distance (data to be measured)
v_measure = v + 2*(rand(size(v))-0.5)*sigma_v; 
theta_measure = theta + 2*(rand(size(theta))-0.5)*sigma_theta;

theta_distance_real = zeros(N,NS);
for i = 1:NS
    x_s = bsxfun(@minus,x,S(i,:));
    theta_distance_real(:,i) = atan2(x_s(:,2),x_s(:,1)) - theta;
end
theta_distance_measure = theta_distance_real + randn(size(theta_distance_real))*sqrt(sigma); % Measured distance

% measure function (angle distance between the heading and the landmark at
% each state
f = @(x,y,s,k) atan2(y - s(2),x - s(1)) - theta(k);

% cell array with function for each landmark
pe = cell(NS,1);
for m = 1:NS
        pe{m} = @(x,y,k) normpdf(f(x,y,S(m,:),k),theta_distance_measure(k,m),sqrt(sigma));
end

%% State Function inputs (measures y2 and y3)
U = cell(N,1);
for k = 1:N
    U{k} = [Interval(v_measure(k)).inflate(sigma_v),Interval(theta_measure(k)).inflate(sigma_theta)];
end



     

