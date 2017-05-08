clc; clear all; close all
normVec = @(a) sqrt(sum(a.^2,2));

%% Environment and boxes initialization
environment1; % Environment definition
initBoxes; % Finding the number of boxes/particles

sigmav = 0.05; ts = 0.5; sigmatheta = 0.001;
f = @(X,U,ts) X(1:2) + ts*U(1);
f2 = @(X,U,ts) X + ts*U(1)*[cos(U(2)) , sin(U(2))];

w_boxes = cell(N,1);
w_boxes2 = cell(N,1);
w_boxes{1}=1/Nboxes*ones(boxes);
w_boxes2{1}=1/Nboxes*ones(boxes);
x_med=zeros(L,2); % prealocating for performance
x_med2=zeros(L,2); % prealocating for performance
%% Main loop
% tic;
m1 = 0; m2 = 0; m3 = 0; m4 = 0;
% here the box particle filtering algorithm is implemented
for k=1:L,
    %% Measurement update
    % create cell array with pdf of error for each landmark
    pe = cell(NS,1); % preallocating for performancei
    for m = 1:NS
        pe{m} = @(x,y) 1/(sqrt(2*pi*R))*exp(-(sqrt((x-S(m,1)).^2 + (y-S(m,2)).^2)-v_measured(k,m)).^2/(2*R));
%         pe{m} = @(x,y) 1/(sqrt(2*pi*R))*exp(-(sqrt((x-S(m,1)).^2 + (y-S(m,2)).^2)-v_dist(k,m)).^2/(2*R));
    end
    
    % measurement update: use landmarks to calculate weights
    tic;
    [w_boxes{k},x_med(k,:)] = measurementUpdate(w_boxes{k},x_med(k,:),Boxes,pe);
    m1 = m1 + toc; tic;
    [w_boxes2{k},x_med2(k,:)] = measurementUpdate(w_boxes2{k},x_med2(k,:),Boxes,pe);
    m2 = m2 + toc;
    
    %% State update Resampling
    % New boxes affected by neighbouring old boxes
    
    % Find new input U
    if(k == 1)
        V = Interval(0).inflate(sigmav);
        Theta = Interval([0,2*pi]);
        x_aux = x_med(k,:);
    else
        X = (xb0(k,:) - xb0(k-1,:));
        Theta = Interval(atan2(X(2),X(1))).inflate(sigmatheta);
        V = Interval(normVec(X/ts)).inflate(sigmav);
        
        x_aux = xb0(k-1,:) + V.mid*[cos(Theta.mid),sin(Theta.mid)];
    end
    %V = Interval(0).inflate(sigmav);
    U = [V,Theta];  
    
    % Use input to calculate stateUpdate
    tic;
    w_boxes{k+1} = stateUpdate(w_boxes{k},Boxes,f,U,ts);
    m3 = m3 + toc; tic;    
    w_boxes2{k+1} = stateUpdate(w_boxes2{k},Boxes,f2,U,ts);
    m4 = m4 + toc;
%     w_boxes{k+1} = resamp(w_boxes{k});

    disp(k);
    [m1 m2 m3 m4]
    
end
% toc
%% Plots

% % distance error plots
% figure (2); 
% subplot(3,1,1); hold on; plot (v_dist(:,1),'b'); plot (v_measured(:,1),'r')
% title('Error between measured and real distances')
% subplot(3,1,2); hold on; plot (v_dist(:,2),'b'); plot (v_measured(:,2),'r')
% subplot(3,1,3); hold on; plot (v_dist(:,3),'b'); plot (v_measured(:,3),'r')
% 
% figure (51); hold on
% plot (xb0(:,1),xb0(:,2),'g*','linewidth',7)
% plot (x_med(:,1),x_med(:,2),'b+','linewidth',7)
% %plot (x1_med(k),x2_med(k),'b+','linewidth',7)
% contour(centre_x1,centre_x2,w_boxes')
% axis ([x_min(1) x_max(1) x_min(2) x_max(2)]); hold off
% legend ('Real point','Estimated BPF'); title ('Box particle filtering')

figure (500); 
%subplot(2,1,1); 
hold on
plot (xb0(:,1),xb0(:,2),'k','LineWidth',3)
plot (x_med(:,1),x_med(:,2),'r','LineWidth',2)
plot (x_med2(:,1),x_med2(:,2),'b','LineWidth',2)
scatter(S(:,1),S(:,2),'mx','linewidth',7)
plotBoxGrid(Boxes,'g',1)
legend ('real','Box particle model 1','Box particle model 2','Location','northwest')

% approximation errors plot
%figure (501); hold on
% subplot(2,1,2)
% plot (normVec(x_med - xb0),'b')     % box particle filtering
% legend ('Box particle')
% title ('Approximation Errors')