clc; clear all; close all
normVec = @(a) sqrt(sum(a.^2,2));
rng(1);

%% Defining system conditions
% robot state function
stateF = @(X,U,ts) X + ts*U(1)*[cos(U(2)) , sin(U(2))];

% environment definition (measures, probability functions, etc)
environment3;

%% Particle filtering
NP = 256;
initParticles; % Finding the number of boxes/particles

[w,x_med] = ConvPFilter2D(N,particles,ts,stateF,[v_measure,theta_measure],pe,true);
%% Plots

figure (1); 
%subplot(2,1,1); 
hold on
plot (x(:,1),x(:,2),'k','LineWidth',3)
plot (x_med(:,1),x_med(:,2),'r','LineWidth',2)
% plot (x_med_box(:,1),x_med_box(:,2),'b','LineWidth',2)
scatter(S(:,1),S(:,2),'mx','linewidth',7)
% plotBoxGrid(Boxes,'g','none',1)
plotDistance(x,x_med,'b');
axis([-5 15 -5 15])
legend ('real','COnventional Particle filtering','Box particle filtering','Location','northwest')
