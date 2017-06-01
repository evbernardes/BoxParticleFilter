clc; clear all; close all
normVec = @(a) sqrt(sum(a.^2,2));
rng(1);

%% Environment and boxes initialization
environment3; % Environment definition

f = @(X,U,ts) X(1:2) + ts*U;
stateF_Pos = @(X,U,ts) X + ts*U(1)*[cos(U(2)) , sin(U(2))];

NP = 2*512;

% Box particle filtering
initBoxes;
w_boxes = cell(N,1);
w_boxes{1}=1/Nboxes*ones(boxes);
x_med_box=zeros(N,2); % prealocating for performance

% Conventional particle filtering
initParticles;
w = cell(N,1);
w{1}=1/NParticles*ones(NParticles,1);
x_med=zeros(N,2); % prealocating for performance

MainBox;
MainPFConventional;

%% Plots

figure (2); 
%subplot(2,1,1); 
hold on
plot (x(:,1),x(:,2),'k','LineWidth',3)
plot (x_med(:,1),x_med(:,2),'r','LineWidth',2)
plot (x_med_box(:,1),x_med_box(:,2),'b','LineWidth',2)
scatter(S(:,1),S(:,2),'mx','linewidth',7)
plotBoxGrid(Boxes,'g','none',1)
% plotDistance(x,x_med,'b');
legend ('real','COnventional Particle filtering','Box particle filtering','Location','northwest')


errorBox = normVec(x_med_box - x);
errorConv = normVec(x_med - x);
figure (3);
hold on
plot (errorConv,'k','LineWidth',1)
plot (errorBox,'r','LineWidth',1)
legend('Error conventional','Error box')

