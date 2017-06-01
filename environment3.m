normVec = @(a) sqrt(sum(a.^2,2));

%% path 2
ts = 0.15; 
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
sigma=5; sigma_v = 0.02; sigma_theta = 0.002;
% accuracy_x = [1, 1]; % box dimensions



%% Theta: Definition of measure and error distribution

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
measure_Func = @(x,y,s) atan2(y - s(2),x - s(1));

% cell array with function for each landmark
pe = cell(NS,1);
for m = 1:NS
        pe{m} = @(x,y,k) normpdf(measure_Func(x,y,S(m,:)) - theta(k),theta_distance_measure(k,m),sqrt(sigma));
end

% State Function inputs
U = cell(N,1);
for k = 1:N
    U{k} = [Interval(v_measure(k)).inflate(sigma_v),Interval(theta_measure(k)).inflate(sigma_theta)];
end



     

