%% path 2
dt = 0.15;
th = 0:dt:pi;
xb0 = 5*[cos(th)',sin(th)']; xb0 = xb0 + 5;
xb0d = diff(xb0); xb0d = [xb0d(1,:);xb0d];
N = length(xb0);
heading = atan2(xb0d(:,2),xb0d(:,1));
accuracy_x = [1, 1];

% Landmarks
S =     [5 5];
%         6 7;
%         1 3];
NS = size(S,1); % number of landmarks

% noise
sigma=0.005; sigmav = 0.1; sigmatheta = 0.1; sigmaomega = 0.1;
ts = dt;

theta_real = zeros(N,NS);
for i = 1:NS
    x_s = bsxfun(@minus,xb0,S(i,:));
    
%     alfa = dot(xb0d',x_s')' ./(normVec(xb0d).*normVec(x_s));
    theta_real(:,i) = atan2(x_s(:,2),x_s(:,1)) - heading;
%     theta_real(:,i) = acos(alfa);
end


%% Theta: Definition of measure and error distribution

theta_measure = theta_real + randn(size(theta_real))*sqrt(sigma); % Measured distance
theta_measure_Func = @(x,y,s) atan2(y - s(2),x + s(1)) ;
% theta_measure_Func = @(x,y,s) acos((x*s(1) + y*s(2))./((sqrt(x.^2 + y.^2)).*(sqrt(s(1).^2 + s(2).^2))));
pe = cell(NS,1);
for m = 1:NS
        pe{m} = @(x,y,head,k) normpdf(theta_measure_Func(x,y,S(m,:)) - head,theta_measure(k,m),sqrt(sigma));
end

%% Vel: Definition of measure and error distribution
vel = normVec(xb0d/ts);
vel_measure = vel + randn(size(vel));
% vel_measure_Func = @(x,y) sqrt((x-s(1)).^2 + (y-s(2)).^2);

pe_vel = @(v,k) normpdf(v,vel_measure(k),sqrt(sigmav));

%% Omega: Definition of measure and error distribution
omega = atan2(xb0(:,2),xb0(:,1));
omega_measure = omega + randn(size(omega));
% vel_measure_Func = @(x,y) sqrt((x-s(1)).^2 + (y-s(2)).^2);

pe_omega = @(omg,k) normpdf(omg,omega_measure(k),sqrt(sigmaomega));


     

