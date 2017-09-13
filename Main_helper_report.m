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
NP = 64; % number of particles for the conventional filter and number of boxes for the fixed array BPF

%
%	3) if the images of the simulation are meant to be saved, set 
%	'pr = true' and give a test number. Everything will be saved in
%	./results/sim$testNO

pr = false;
testNO = 30;

%	
%	last edited in:	20/08/2017 						 
%									 
%***********************************************************************

% robot state function
sFunction = @(X,U,ts) X + ts*U(1)*[cos(U(2)) , sin(U(2))];
path = sprintf('./results/sim%d/',testNO);
%% conventional particle filter
initParticles; % Finding the number of boxes/particles
%x_part = zeros(size(x));
r = (rand(1,3000)-0.5)*(bound);
Q = 3*cov(r)*eye(2);

xpf = zeros(2,N);
% xp = particles{1}';
particles{1} = particles{1}';
% [w,x_conv] = ConvPFilter2D(N,particles,ts,sFunction,[v_measure,theta_measure],pe,false);
tic;

for k = 1:N
	f = @(x) sFunction(x',stateInput(k,:),ts);
	[xpf(:,k), particles{k+1} ] = pf(f,particles{k},@(x) h(x,k),measure(k,:)',Q,sigma*eye(NS)); % Este pf supone una distribucion gausiana (no afitada) de las partículas
% 	[xpf(:,k), xp ] = pf(f,xp,h,measure(k,:)',Q,sigma*eye(3)); % Este pf supone una distribucion gausiana (no afitada) de las partículas
end
x_conv = xpf';
time_conv = toc;

%% Box particle filtering
initBoxes;

% init position
%[i,j] = findIndexes(Interval(x(1,1),x(1,2)),Boxes);
%i = i-2:i+2; j = j-2:j+2;
%w_boxes_0 = zeros(size(Boxes)); w_boxes_0(i,j) = 1; w_boxes_0 = w_boxes_0/sum(sum(w_boxes_0));
w_boxes_0 = ones(size(Boxes)); w_boxes_0 = w_boxes_0/sum(sum(w_boxes_0));

tic;
[w_box,x_box] = BPF2D_fixed(N,Boxes,ts,sFunction,U,pe,false,w_boxes_0);
time_med_box = toc;

%% Box particle filtering variable
in = x(1,:); %accuracy = [0.5,0.5];
accuracy = accuracy_x;
% lb = in - 2*accuracy; ub = in + 2*accuracy;
% Boxes_0 = initBoxVar(lb,ub,accuracy);
% Boxes_0 = Boxes;
Boxes_0 = Boxes;
w_0 = ones(size(Boxes_0)); w_0 = w_0/sum(sum(w_0));

tic;
[BoxesVar,w_box_var,x_box_var] = BoxPFilterVar2D(Boxes_0,w_0,ts,sFunction,U,pe);
time_med_box_var = toc;
%% Dead reckoning
stateInput = [v_measure,theta_measure];
x_dead = zeros(size(x));
x_dead(1,:) = x(1,:);

for i = 2:length(x_dead)
   x_dead(i,:) = sFunction(x_dead(i-1,:),stateInput(i,:),ts);
end

%% Plots
close all;
if(pr)
	mkdir(path);
end
% dead reckoning
figure(1)
% subplot(1,2,1);
    plot (x(:,1),x(:,2),'k','LineWidth',3); hold on
	plot (x_dead(:,1),x_dead(:,2),'g','LineWidth',2)
    scatter(S(:,1),S(:,2),'mx','linewidth',7)
    axis([Boxes{1,1}(1).lb Boxes{end,end}(1).ub Boxes{1,1}(2).lb Boxes{end,end}(2).ub ]);
    legend ('Real path','Dead reckoning','Location','northwest');
if(pr)
    print([path 'dead'],'-djpeg');
    print([path 'dead'],'-dpng');
end
% conventional particle filter
figure (2);
    plot (x(:,1),x(:,2),'k','LineWidth',3); hold on
	plot (x_conv(:,1),x_conv(:,2),'r','LineWidth',3);
	plot (x_box(:,1),x_box(:,2),'c','LineWidth',3);
	plot (x_box_var(:,1),x_box_var(:,2),'b','LineWidth',3);
    scatter(S(:,1),S(:,2),'mx','linewidth',7); hold off
    axis([Boxes{1,1}(1).lb Boxes{end,end}(1).ub Boxes{1,1}(2).lb Boxes{end,end}(2).ub ]);
    legend ('Real path','Conventional particle filtering','Fixed Box Particle Filter','Variable array Box particle filter','Location','northwest');
	
if(pr)
    print([path 'conv'],'-djpeg');
    print([path 'conv'],'-dpng');
end

% variable array box
figure (3);
    plot (x(:,1),x(:,2),'k','LineWidth',3); hold on
    plot (x_box_var(:,1),x_box_var(:,2),'b','LineWidth',2)
    scatter(S(:,1),S(:,2),'mx','linewidth',7)
    for k =2:length(BoxesVar)
%         plotBoxGrid(BoxesVar{k}(w_box_var{k} > 0.01),'g','none',1)
        plotBoxGrid(BoxesVar{k},'k','none',0.1)
    end
    axis([Boxes{1,1}(1).lb Boxes{end,end}(1).ub Boxes{1,1}(2).lb Boxes{end,end}(2).ub ]);
    legend ('Real path','Variable grid box particle filter','Location','northwest');
%     title('Fixed-grid box particle filter estimation');

if(pr)
	print([path 'box_variable'],'-djpeg');
    print([path 'box_variable'],'-dpng');
end

% box fixed
figure (4);
    plot (x(:,1),x(:,2),'k','LineWidth',3); hold on
    plot (x_box(:,1),x_box(:,2),'c','LineWidth',2)
    scatter(S(:,1),S(:,2),'mx','linewidth',7)
	plotBoxGrid(Boxes,'k','none',0.1)
    axis([Boxes{1,1}(1).lb Boxes{end,end}(1).ub Boxes{1,1}(2).lb Boxes{end,end}(2).ub ]);
    legend ('Real path','Fixed grid box particle filter','Location','northwest');
	
if(pr)
    print([path 'box_fixed'],'-djpeg');
    print([path 'box_fixed'],'-dpng');
end

% error
figure(5);
    err_dead = normVec(x - x_dead);
    err_part = normVec(x - x_conv);
    err_med_box = normVec(x - x_box);
    err_box_med_var = normVec(x - x_box_var);
    
    
    hold on
    plot (err_dead,'g','LineWidth',2);
    plot (err_part,'r','LineWidth',2);
    plot (err_med_box,'c','LineWidth',2);
    plot (err_box_med_var,'b','LineWidth',2);
    
    ylabel('error');
    xlabel('step');
	legend ('Dead reckoning','Conventional particle filter','Fixed grid box filter','Variable grid box filter','Location','northwest')
%     legend ('Conventional particle filter','Fixed grid box filter','Variable grid box filter','Location','northeast')
%     axis([1 k 0 4]);

if(pr)
    print([path 'error'],'-djpeg');
    print([path 'error'],'-dpng');
end
% time
figure(6)
c = {'Conventional','Fixed box array','Variable box array'};
p = bar([time_conv; time_med_box; time_med_box_var]);
set(gca,'xticklabel', c);

% L = get(gca,'YLim');
% set(gca,'YTick',sort([time_conv; time_med_box; time_med_box_var])');
set(gca,'YTick',sort([time_conv; time_med_box])');
ylabel('time (s)');

if(pr)
print([path 'time'],'-djpeg');
print([path 'time'],'-dpng');
end

% info
if(pr)
fileID = fopen([path 'info.tex'],'w');
% fprintf(fileID,'%s \n',id);

fprintf(fileID,'\\begin{equation}\n');
fprintf(fileID,'\\label{test%d:variance}\n',testNO);
fprintf(fileID,'\\begin{cases}\n');
fprintf(fileID,'\\sigma^2 = %.3f\\\\ \n',sigma);
fprintf(fileID,'\\sigma_v^2 = %.3f\\\\ \n',sigma_v);
fprintf(fileID,'\\sigma_{\\theta}^2 = %.3f\\\\ \n',sigma_theta);
fprintf(fileID,'\\end{cases}\n');
fprintf(fileID,'\\end{equation}\n');
fclose(fileID);


fileID = fopen([path 'settings.tex'],'w');
fprintf(fileID,'\\begin{itemize}\n');
fprintf(fileID,'\\label{test%d:settings}\n',testNO);
fprintf(fileID,'\\item Boxes width = $[%f,%f]$\n',accuracy(1),accuracy(1));
fprintf(fileID,'\\item Number of particles/boxes = $%d$\n',NP);
fprintf(fileID,'\\end{itemize}\n');
fclose(fileID);
end

%
if(pr)
	save([path 'data']);
end

%
if(pr)
err = {err_part,err_med_box,err_box_med_var};
MSE = sqrt(cellfun(@(x) mean(x.^2),err));
figure
c = {'Conventional','Fixed box array','Variable box array'};
% c = NPS;
p = bar(MSE);
set(gca,'xticklabel', c);

L = get(gca,'YLim');
% set(gca,'YTick',sort(p));
% xlabel('number of boxes');
ylabel('mean error');

print([path 'meanerror'],'-djpeg');
print([path 'meanerror'],'-dpng');
end
