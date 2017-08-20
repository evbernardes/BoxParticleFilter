%%
normVec = @(a) sqrt(sum(a.^2,2));
ts = 0.15; % sampling frequency

th = -pi/2:ts:pi/2;

x = 3*[cos(th)',sin(th)']; x = x+4.5;
x1 = (1:ts:x(1,1))'; x1 = [x1,x(1,2)*ones(size(x1))];
x2 = (x(end,1):-ts:1)'; x2 = [x2,x(end,2)*ones(size(x2))];
x = [x1;x;x2];
x = [x;x(end:-1:1,:)];
x = [x;x;x;x];
dx = diff(x); dx = [dx(1,:);dx];
N = length(x);
v = normVec(dx)/ts; 
theta = atan2(dx(:,2),dx(:,1));


% noise
dtheta = 50*pi/180;
% sigma=0.5; sigma_v = 0.02; sigma_theta = 0.02;
sigma=0.7; sigma_v = 0.1; sigma_theta = 0.01;
v_measure = v + 2*(rand(size(v))-0.5)*sigma_v; 
theta_measure = theta + 2*(rand(size(theta))-0.5)*sigma_theta;

%% Room definition
A = 3;
% p1 = [0,    0   ];
% p2 = [3*A,  0   ];
% p3 = [3*A,  3*A ];
% p4 = [0,3*  A   ];
% p5 = [0,2*  A   ];
% p6 = [2*A,  2*A ];
% p7 = [2*A,  A   ];
% p8 = [0,    A   ];
corners = [   0,    0;
            3*A,    0;
            3*A,  3*A;
              0,  3*A;
              0,  2*A;
            2*A,  2*A;
            2*A,    A;
              0,    A];

dl = 1.5;
room = createWall(dl,corners); hold on
ax = [-2 3*A+2 -2 3*A+2];

%% State Function inputs (measures y2 and y3)
U = cell(N,1);
for k = 1:N
    U{k} = [Interval(v_measure(k)).inflate(sigma_v),Interval(theta_measure(k)).inflate(sigma_theta)];
end

%% landmark sensor
measureFunc = @(x,y,s) sqrt((x-s(1)).^2 + (y-s(2)).^2);
pdf = @(x,y,s,m) normpdf(measureFunc(x,y,s),m,sqrt(sigma));