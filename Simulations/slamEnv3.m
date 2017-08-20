%%
normVec = @(a) sqrt(sum(a.^2,2));
ts = 0.15; % sampling frequency

th = 0.15;

x1 = (1:ts:7.5)'; x1 = [x1,1.5*ones(size(x1))];
th1 = zeros(length(x1),1);
th2 = (0:-th:-3*pi/2)';
x2 = repmat(x1(end,:),[length(th2),1]);

x3 = (x2(end,2):ts:7.5)'; x3 = [x2(end,1)*ones(size(x3)),x3];
th3 = th2(end)*ones(length(x3),1);
th4 = (th2(end):-th:-3*pi)';
x4 = repmat(x3(end,:),[length(th4),1]);

x5 = (x4(end,1):-ts:1)'; x5 = [x5,x4(end,2)*ones(size(x5))];
th5 = th4(end)*ones(length(x5),1);


x = [x1;x2;x3;x4;x5];

dx = diff(x); dx = [dx(1,:);dx];
N = length(x);
v = normVec(dx)/ts; 
theta = [th1;th2;th3;th4;th5];
% theta = atan2(dx(:,2),dx(:,1));


% noise
dtheta = 30*pi/180;
% sigma=0.7; sigma_v = 0.02; sigma_theta = 0.1;

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

dl = 2.0;
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