%%
ts = 0.15; % sampling frequency

th = 0:ts:4*pi;
% real state values
x = 1.5*[cos(th)',sin(th)']; %x = x + 5;

dx = diff(x); dx = [dx(1,:);dx];
N = length(x);
v = normVec(dx)/ts; 
theta = atan2(dx(:,2),dx(:,1));


% noise
dtheta = 40*pi/180;
sigma=0.7; sigma_v = 2; sigma_theta = 0.5;
v_measure = v + 2*(rand(size(v))-0.5)*sigma_v; 
theta_measure = theta + 2*(rand(size(theta))-0.5)*sigma_theta;

%% Room definition
A = 3;
% p1 = [-A,-A];
% p2 = [A,-A];
% p3 = [A,A];
% p4 = [-A,A];
corners = [-A, -A;
            A, -A;
            A,  A;
           -A,  A];
dl = 1.5;
room = createWall(dl,corners);
ax = [-5 5 -5 5];

%% State Function inputs (measures y2 and y3)
U = cell(N,1);
for k = 1:N
    U{k} = [Interval(v_measure(k)).inflate(sigma_v),Interval(theta_measure(k)).inflate(sigma_theta)];
end

%% landmark sensor
measureFunc = @(x,y,s) sqrt((x-s(1)).^2 + (y-s(2)).^2);
pdf = @(x,y,s,m) normpdf(measureFunc(x,y,s),m,sqrt(sigma));