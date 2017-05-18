clc; clear all; close all
normVec = @(a) sqrt(sum(a.^2,2));

%% Environment and boxes initialization
environment3; % Environment definition
initBoxes; % Finding the number of boxes/particles

f = @(X,U,ts) X(1:2) + ts*U;

stateF_Pos = @(X,U,ts) X + ts*U(1)*[cos(U(2)) , sin(U(2))];
stateF_Vel = @(v,U,ts) v + ts*U;

w_boxes = cell(N,1);
w_boxes{1}=1/Nboxes*ones(boxes);
x_med=zeros(N,2); % prealocating for performance
x_med(1,:) = xb0(1,:);

% v_w_boxes = cell(N,1);
% v_w_boxes{1} = 1/length(V_Boxes)*ones(size(V_Boxes));
% v_med = zeros(N,1);
% v_med(1) = 0;
% 
% omega_w_boxes = cell(N,1);
% omega_w_boxes{1} = 1/length(OMEGA_Boxes)*ones(size(OMEGA_Boxes));
% omega_med = zeros(N,1);
% omega_med(1) = 0;
%% Main loop
% here the box particle filtering algorithm is implemented
pek = cell(NS,1);
for k=2:N,
    
    % Find new input U
    if(k == 2)
        v = 0; omega = 0;
    else
        dx = (x_med(k,:) - x_med(k-1,:));
        v = norm(dx)/ts;
        omega = atan2(dx(2),dx(1));
    end
    U = [Interval(v).inflate(sigmav),Interval(omega).inflate(sigmaomega)];
    
    %% Measurement update
    for m = 1:NS
        pek{m} = @(x,y) pe{m}(x,y,omega,k);
    end  
        
    % measurement update
%     w_boxes{k} = stateUpdate(w_boxes{k-1},Boxes,stateF_Pos,U,ts);
    [w_boxes{k},x_med(k,:)] = measurementUpdate(w_boxes{k-1},x_med(k,:),Boxes,pek);
%     [v_w_boxes{k},v_med(k+1)] = measurementUpdate1D(v_w_boxes{k},v_med(k),V_Boxes,{@(v) pe_vel(v,k)});
%     [omega_w_boxes{k},omega_med(k+1)] = measurementUpdate1D(omega_w_boxes{k},omega_med(k),OMEGA_Boxes,{@(omg) pe_omega(omg,k)});
    
    %% State update Resampling
    % New boxes affected by neighbouring old boxes
    
    % Use input to calculate stateUpdate;
    w_boxes{k+1} = stateUpdate(w_boxes{k},Boxes,stateF_Pos,U,ts);
%     v_w_boxes{k+1} = stateUpdate1D(v_w_boxes{k},V_Boxes,stateF_Vel,U(1),ts);
%     omega_w_boxes{k+1} = stateUpdate1D(omega_w_boxes{k},OMEGA_Boxes,stateF_Vel,U(2),ts);
%     w_boxes{k+1} = resamp(w_boxes{k});

    disp(k);
    
    figure(1)
    hold on
    scatter(k,omega)
end

%% Plots

figure (500); 
%subplot(2,1,1); 
hold on
plot (xb0(:,1),xb0(:,2),'k','LineWidth',3)
plot (x_med(:,1),x_med(:,2),'r','LineWidth',2)
% plot (x_med2(:,1),x_med2(:,2),'b','LineWidth',2)
% plot (x_med3(:,1),x_med3(:,2),'LineWidth',2)
scatter(S(:,1),S(:,2),'mx','linewidth',7)
plotBoxGrid(Boxes,'g',1)
legend ('real','Box particle model 1','Location','northwest')

% approximation errors plot
%figure (501); hold on
% subplot(2,1,2)
% plot (normVec(x_med - xb0),'b')     % box particle filtering
% legend ('Box particle')
% title ('Approximation Errors')