% clc; clear all; close all
% normVec = @(a) sqrt(sum(a.^2,2));
% rng(1);
% %% Environment and boxes initialization
% environment2; % Environment definition
% initParticles; % Finding the number of boxes/particles
% 
% stateF_Pos = @(X,U,ts) X + ts*U(1)*[cos(U(2)), sin(U(2))];
% 
% w = cell(N,1);
% w{1}=1/NParticles*ones(NParticles,1);
% x_med=zeros(N,2); % prealocating for performance


 %% PF convencional
for k = 1:N    
    Like = 1;
    for m = 1:size(S,1)
        Like = Like.*pe{m}(particles{k}(:,1),particles{k}(:,2),k);
    end

    w{k} = w{k}.*Like;
    w{k} = w{k}/sum(w{k});
    
    [Inew]=rsmp(w{k});

%     particles_x1=particles(Inew,1);
%     particles_x2=particles(Inew,2);
%     particles = [particles_x1,particles_x2];
    particles{k} = particles{k}(Inew,:);
    
    w{k+1}=1/NParticles*ones(NParticles,1);
    
    x_med(k,:)=mean(particles{k});
    
%     U = bsxfun(@times,2*(rand(NParticles,2)-0.5),[sigma_v,sigma_theta]);
%     U = bsxfun(@plus,U,[v(k),theta(k)]);
    U = [v_measure(k),theta_measure(k)];
    for i = 1:length(particles{k})
        particles{k+1}(i,:) = stateF_Pos(particles{k}(i,:),U,ts);
    end
    
    
    disp(k)
    
end

%% Plots
% 
% figure (1); 
% %subplot(2,1,1); 
% hold on
% plot (x(:,1),x(:,2),'k','LineWidth',3)
% plot (x_med(:,1),x_med(:,2),'r','LineWidth',2)
% % plot (x_med_box(:,1),x_med_box(:,2),'b','LineWidth',2)
% scatter(S(:,1),S(:,2),'mx','linewidth',7)
% % plotBoxGrid(Boxes,'g','none',1)
% % plotDistance(x,x_med,'b');
% legend ('real','COnventional Particle filtering','Box particle filtering','Location','northwest')
