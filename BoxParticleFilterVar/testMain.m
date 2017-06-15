clc; clear all; close all
normVec = @(a) sqrt(sum(a.^2,2));
rng(1);

%% Defining system conditions
% robot state function
stateFunction = @(X,U,ts) X + ts*U(1)*[cos(U(2)) , sin(U(2))];

% environment definition (measures, probability functions, etc)
environment3;

%% Box particle filtering
% NP = 256;
% initBoxes;
% 
% % init position
% [i,j] = findIndexes(Interval(x(1,1),x(1,2)),Boxes);
% i = i-2:i+2; j = j-2:j+2;
% w_boxes_0 = zeros(size(Boxes)); w_boxes_0(i,j) = 1; w_boxes_0 = w_boxes_0/sum(sum(w_boxes_0));

in = x(1,:); accuracy = [0.5,0.5];
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
    
    %%
figure(1)
% plotBoxGrid(Boxes,'r','none',1); hold on
for i = 2:length(Boxes)
clf(figure(1))
% plotBoxGrid(ABoxes{i},'g','none',1)
plotBoxGrid(Boxes{i}(w_boxes{i} ~= 0),'g','none',1)

axis([-5 15 -5 15])
pause(0.2)
end