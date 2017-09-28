clc; clear all; close all; normVec = @(a) sqrt(sum(a.^2,2)); % Nx1 norm of a Nx2 vector
%*********************************************************************** 
%									 
%	-- SIMULATION MAIN FILE
%
%	-- Usage = 
%	1) choose between really random simulation (shuffle) or same simulation
%	always (choose a number as seed for the rng function)

rng('shuffle');

%	2) choose the variance values and the simulation environment to be run
%	(the environments are defined inside the "Simulations" directory:

sigma=0.5; sigma_v = 2.5; sigma_theta = 1;
environment2;
NP = 64; % number of particles for the conventional filter 
accuracy = [1,1]; % boxes' dimensions
%	
%	last edited in:	07/09/2017 						 
%									 
%***********************************************************************

% robot state function
sFunction = @(X,U,ts) X + ts*U(1)*[cos(U(2)) , sin(U(2))];

%% ***********************************************************************
% - conventional particle filter
% 
% -> "particles" is a cell array containing all the particles in each step
% -> "particles{k}" is an array containing all particles after step "k"
%************************************************************************
bound = max(max(abs(dx)));
r = (rand(1,3000)-0.5)*(bound);
Q = 3*cov(r)*eye(2); % by function "pf.m" to move particles randomnly

xpf = zeros(2,N);
particles{1} = initParticles(-accuracy,+accuracy,NP);

tic;
for k = 1:N
	f = @(x) sFunction(x',stateInput(k,:),ts);
	[xpf(:,k), particles{k+1} ] = pf(f,particles{k},@(x) h(x,k),measure(k,:)',Q,sigma*eye(NS)); % Este pf supone una distribucion gausiana (no afitada) de las partículas
end
time_conv = toc;
x_conv = xpf';

%% ***********************************************************************
% Box particle filtering (variable)
% ************************************************************************

%Boxes_0 = initBoxesArray(x_min,x_max,accuracy);
Boxes_0 = initBoxesArray(-accuracy,accuracy,accuracy);
w_0 = ones(size(Boxes_0)); w_0 = w_0/sum(sum(w_0));

tic;
[Boxes,w_box_var,x_box_var] = BPF2D(Boxes_0,w_0,ts,sFunction,U,pe);
time_med_box_var = toc;

%% ***********************************************************************
% Plots
% ************************************************************************

close all;

%***************************************************************
% PLOT of estimation with conventional particle filter
%***************************************************************
figure;
    plot (x(:,1),x(:,2),'k','LineWidth',3); hold on
	plot (x_conv(:,1),x_conv(:,2),'r','LineWidth',3);
	plot (x_box_var(:,1),x_box_var(:,2),'b','LineWidth',3);
    scatter(S(:,1),S(:,2),'mx','linewidth',7); hold off
    legend ('Real path','Conventional particle filtering','Variable array Box particle filter','Location','northwest');

%***************************************************************
% PLOT of estimation with variable array box particle filter
%***************************************************************
figure;
    plot (x(:,1),x(:,2),'k','LineWidth',3); hold on
    plot (x_box_var(:,1),x_box_var(:,2),'b','LineWidth',2)
    scatter(S(:,1),S(:,2),'mx','linewidth',7)
    for k =2:length(Boxes)
        plotBoxes(Boxes{k},'k','none',0.1)
    end

    legend ('Real path','Variable grid box particle filter','Location','northwest');

%***************************************************************
% PLOT of estimation errors
%***************************************************************
figure;
err_part = normVec(x - x_conv);
err_box_med_var = normVec(x - x_box_var);    
plot (err_part,'r','LineWidth',2); hold on
plot (err_box_med_var,'b','LineWidth',2);
ylabel('error');
xlabel('step');
legend ('Conventional particle filter','Variable grid box filter','Location','northwest')

%***************************************************************
% PLOT of mean error
%***************************************************************
figure
err = {err_part,err_box_med_var};
MSE = sqrt(cellfun(@(x) mean(x.^2),err));

c = {'Conventional','Variable box array'};
p = bar(MSE);
set(gca,'xticklabel', c);

L = get(gca,'YLim');
ylabel('mean error');

%***************************************************************
% PLOT of computation time
%***************************************************************
figure
c = {'Conventional','Variable box array'};
p = bar([time_conv; time_med_box_var]);
set(gca,'xticklabel', c);
set(gca,'YTick',sort([time_conv; time_med_box_var])');
ylabel('time (s)');