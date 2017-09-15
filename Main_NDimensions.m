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

sigma=0.5; sigma_v = 2.5; sigma_theta = 0.2;
environment2_ND;
NP = 64; % number of particles for the conventional filter 
accuracy = [2.5,2.5,2,pi/4]; % boxes' dimensions
integralInfo = {2,1:2,
				2,1:2,
				2,1:2,
				1,3,
				1,4};
%	
%	last edited in:	07/09/2017 						 
%									 
%***********************************************************************

% robot state function
%sFunction = @(X,U,ts) X + ts*U(1)*[cos(U(2)) , sin(U(2))];
%sFunction = @(X,U,ts) [X(1:2) + ts*U(1)*[cos(U(2)) , sin(U(2))],(X(3) + ts*U(1)),(X(4) + ts*U(2))];
sFunction = @(X,U,ts) [X(1:2) + ts*(X(3) + ts*U(1))*[cos((X(4) + ts*U(2))) , sin((X(4) + ts*U(2)))],(X(3) + ts*U(1)),(X(4) + ts*U(2))];


%% ***********************************************************************
% - conventional particle filter
% 
% -> "particles" is a cell array containing all the particles in each step
% -> "particles{k}" is an array containing all particles after step "k"
%************************************************************************
bound = max(max(abs(dx)));
x_min = min(x) - 5*bound;
x_max = max(x) + 5*bound;

% initParticles; % Finding the number of boxes/particles
% 
% r = (rand(1,3000)-0.5)*(bound);
% Q = 3*cov(r)*eye(2); % by function "pf.m" to move particles randomnly
% 
% xpf = zeros(2,N);
% particles{1} = particles{1}';
% 
% tic;
% for k = 1:N
% 	f = @(x) sFunction(x',stateInput(k,:),ts);
% 	[xpf(:,k), particles{k+1} ] = pf(f,particles{k},@(x) h(x,k),measure(k,:)',Q,sigma*eye(NS)); % Este pf supone una distribucion gausiana (no afitada) de las partículas
% end
% time_conv = toc;
% x_conv = xpf';

%% ***********************************************************************
% Box particle filtering (variable)
% ************************************************************************

%Boxes_0 = initBoxesArray_ND([x_min 0 0],[x_max 4 2*pi],accuracy);
x0 = [x(1,:) v(1) theta(1)];
%Boxes_0 = {Interval([x0-accuracy/2;x0+accuracy/2])};
Boxes_0 = initBoxesArray_ND(x0-2*accuracy,x0+2*accuracy,accuracy);

w_0 = ones(size(Boxes_0)); w_0 = w_0/sum(sum(w_0));

tic;
%[Boxes,w_box_var,x_box_var] = BPF(Boxes_0,w_0,ts,sFunction,stateInput,pe);
%% ***********************************************************************
	%N = length(sInput);
    x_med = zeros(N,length(Boxes_0{1}));
    accuracy = Boxes_0{1}.width;
    
    Boxes = cell(N+1,1); Boxes{1} = Boxes_0;
    W = cell(N+1,1); W{1} = w_0;

    %% Main loop
    % here the box particle filtering algorithm is implemented
    pek = cell(size(pe));
    for k=1:N,
    %     if(show)
%             disp(k)
    %     end
		k
        %% Measurement update
        for m = 1:3
            pek{m} = @(x,y) pe{m}(x,y,k);
		end
		pek{4} = @(v) pe{4}(v,k);
		pek{5} = @(theta) pe{5}(theta,k);

        % measurement update
		backup = W{k};
        [W{k},x_med(k,:)] = measurementUpdate_ND(W{k},Boxes{k},pek,integralInfo);
		if(isempty(W{k}))
			W{k} = backup;
		end

        %% State update Resampling
        % Use input to calculate stateUpdate;
        [W{k+1},Boxes{k+1}] = stateUpdate_ND(W{k},Boxes{k},accuracy,sFunction,stateInput(k,:),ts);
	end
	

%% ***********************************************************************

time_med_box_var = toc;

%% ***********************************************************************
% Plots
% ************************************************************************

close all;

%***************************************************************
% PLOT of estimation with conventional particle filter
%***************************************************************
% figure;
%     plot (x(:,1),x(:,2),'k','LineWidth',3); hold on
% 	plot (x_conv(:,1),x_conv(:,2),'r','LineWidth',3);
% 	plot (x_box_var(:,1),x_box_var(:,2),'b','LineWidth',3);
%     scatter(S(:,1),S(:,2),'mx','linewidth',7); hold off
%     legend ('Real path','Conventional particle filtering','Variable array Box particle filter','Location','northwest');

%***************************************************************
% PLOT of estimation with variable array box particle filter
%***************************************************************
x_box_var = x_med;
figure;
    plot (x(:,1),x(:,2),'k','LineWidth',3); hold on
    plot (x_box_var(:,1),x_box_var(:,2),'b','LineWidth',2)
    scatter(S(:,1),S(:,2),'mx','linewidth',7)
%     for k =2:length(Boxes)
%         plotBoxes(Boxes{k},'k','none',0.1)
%     end

    legend ('Real path','Variable grid box particle filter','Location','northwest');

