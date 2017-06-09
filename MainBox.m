clc; clear all; close all
normVec = @(a) sqrt(sum(a.^2,2));
rng(1);

%% Defining system conditions
% robot state function
stateF = @(X,U,ts) X + ts*U(1)*[cos(U(2)) , sin(U(2))];

% environment definition (measures, probability functions, etc)
environment2;

%% Box particle filtering
NP = 256;
initBoxes;

% init position
[i,j] = findIndexes(Interval(x(1,1),x(1,2)),Boxes);
i = i-2:i+2; j = j-2:j+2;
w_boxes_0 = zeros(size(Boxes)); w_boxes_0(i,j) = 1; w_boxes_0 = w_boxes_0/sum(sum(w_boxes_0));

[w_boxes_box,x_med_box] = BoxPFilter2D(N,Boxes,ts,stateF,U,pe,true,w_boxes_0);

%% Plots

figure (1); 
    plot (x(:,1),x(:,2),'k','LineWidth',3)
    hold on
    plot (x_med_box(:,1),x_med_box(:,2),'r','LineWidth',2)
    scatter(S(:,1),S(:,2),'mx','linewidth',7)
    plotBoxGrid(Boxes,'g','none',1)
    plotDistance(x,x_med_box,'b');
    legend ('real','Box particle model 1','Location','northwest')
