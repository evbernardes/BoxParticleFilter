clc; clear all; close all
normVec = @(a) sqrt(sum(a.^2,2));
rng(1);

%% Defining system conditions
% robot state function
stateFunction = @(X,U,ts) X + ts*U(1)*[cos(U(2)) , sin(U(2))];

% environment definition (measures, probability functions, etc)
environment3;

%% Box particle filtering
in = x(1,:); accuracy = [1,1];
lb = in - 2*accuracy; ub = in + 2*accuracy;
Boxes = cell(N,1); Boxes{1} = initBoxVar(lb,ub,accuracy);

w_boxes = cell(N,1); 
w_boxes{1} = ones(size(Boxes{1})); w_boxes{1} = w_boxes{1}/sum(sum(w_boxes{1}));
x_med = zeros(N,2);

%% Main loop
% here the box particle filtering algorithm is implemented
pek = cell(size(pe));
for k=1:N,
%     if(show)
        disp(k)
%     end
    %% Measurement update
    for m = 1:length(pek)
        pek{m} = @(x,y) pe{m}(x,y,k);
    end
    
    % measurement update
    [w_boxes{k},x_med(k,:)] = measurementUpdate(w_boxes{k},Boxes{k},pek);
    
    %% State update Resampling
    % Use input to calculate stateUpdate;
    [w_boxes{k+1},Boxes{k+1}] = stateUpdateVar(w_boxes{k},Boxes{k},accuracy,stateFunction,U{k},ts);
end

%% Plots

figure (1); 
hold on
    plot (x(:,1),x(:,2),'k','LineWidth',3)
    hold on
    plot (x_med(:,1),x_med(:,2),'r','LineWidth',2)
    scatter(S(:,1),S(:,2),'mx','linewidth',7)
%     plotBoxGrid(Boxes,'g','none',1)
    plotDistance(x,x_med,'b');
    legend ('real','Box particle model 1','Location','northwest')
    
for i = 1:length(Boxes)
plotBoxGrid(Boxes{i}(w_boxes{i} ~= 0),'g','none',1)
end

%%
figure(2)
norm = max(cellfun(@(x) max(max(x)),w_boxes));
for i = 1:length(Boxes)
    clf(figure(2)); 
    plot (x(:,1),x(:,2),'k','LineWidth',3); hold on
    axis([-5 15 -5 30]);
	plotBoxesColor(Boxes{i},w_boxes{i},norm);
    pause(0.2);
end
