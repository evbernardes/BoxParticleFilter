%% Defining system conditions
% robot state function
clear all; close all;
normVec = @(a) sqrt(sum(a.^2,2));
stateFunction = @(X,U,ts) X + ts*U(1)*[cos(U(2)) , sin(U(2))];

% environment definition (measures, probability functions, etc)
sigma=1; sigma_v = 2; sigma_theta = 0.2;
acc = [0.8,0.8];
slamEnv3;
norm = 0;

pr = true;
testNO = 12;
path = sprintf('pasta-de-simulacoes/sim%d/',testNO);
if(pr)
	mkdir(path);
end

%%
w_boxes   = cell(50,1); w_boxes{1} = 1;
x_pos = x(1,1) + [-2*acc(1),2*acc(1)]; 
y_pos = x(1,2) + [-2*acc(2),2*acc(2)];
Boxes = cell(50,1); Boxes{1} = {Interval(x_pos,y_pos)};

%%
measuredDistance = zeros(length(room),1);
%closemeasuredPoints = cell(N,1);
measuredPoints = zeros(length(room),2);
measures = zeros(length(room),1);
x_med = zeros(N,2);
x_med(1,:) = x(1,:);

if(pr)
	outputVideo = VideoWriter(fullfile(path,'shuttle_out.avi'));
	outputVideo.FrameRate = 5;
	open(outputVideo)
end
f = figure('units','normalized','outerposition',[0 0 1 1])
for k = 1:N
    
    angles = wrapToPi(getLmkAngles(x(k,:),theta(k),room));
    obsLmks = angles < dtheta & angles > -dtheta;
    angles = angles(obsLmks);
    
    
    %% test
%     dd = mean(diff(angles));
%     [idxfirst] = find(abs(angles - dtheta) < dd);
%     temp = 1000*ones(size(room)); temp(idxfirst,:) = room(idxfirst,:); 
%     [~,idxfirst] = min(normVec(bsxfun(@minus,temp,x(k,:))));
% %     idxs(idxfirst) = 1;
% 
%     % find last
%     [idxlast] = find(abs(angles + dtheta) < dd);
%     temp = 1000*ones(size(room)); temp(idxlast,:) = room(idxlast,:); 
%     [~,idxlast] = min(normVec(bsxfun(@minus,temp,x(k,:))));
% %     idxs(idxlast) = 1;
%     ii = [idxfirst, idxlast];
    %%
    
    m = sum(obsLmks);
    pek = cell(m,1);
    Lmks = find(obsLmks);
    dist = normVec(bsxfun(@minus,room(Lmks,:),x(k,:)));
    dist = dist + sigma*randn(size(dist));
%     dist = zeros(m,1);
    for i = 1:m
%         d = room(Lmks(i),:) - x(k,:);
%         dist(i) = sqrt(d(2)^2 + d(1)^2);
        pek{i} = @(x,y) pdf(x,y,room(Lmks(i),:),dist(i));
    end
    
    % measurement update
    [w_boxes{k},x_med(k,:)] = measurementUpdate(w_boxes{k},Boxes{k},pek);
    
    %% State update Resampling
    % Use input to calculate stateUpdate;
    [w_boxes{k+1},Boxes{k+1}] = stateUpdateVar(w_boxes{k},Boxes{k},acc,stateFunction,U{k},ts);
    
    %% Storing new map info
    measures(Lmks) = measures(Lmks)+1;
    oldPos = measuredPoints(Lmks,:);
    newPos = bsxfun(@plus,[dist,dist].*[cos(angles+theta_measure(k)),sin(angles+theta_measure(k))],x_med(k,:));
    
    n = measures(Lmks); n = [n,n];
    measuredPoints(Lmks,:) = (newPos + (n-1).*oldPos)./n;
%     measuredPoints(Lmks,:) = newPos;
    AllLmks = find(measuredPoints(:,1));
%     length(AllLmks)
    
% 


    subplot(1,3,1)
	h1a = draw_tank([x(k,:),theta(k)],'blue',0.1); hold on;
    h1b = draw_tank([x_med(k,:),theta_measure(k)],'r',0.1);
	h1c = scatter(measuredPoints(Lmks,1),measuredPoints(Lmks,2),'r','LineWidth',1);
    plot(room(:,1),room(:,2),'k');
    
    axis(ax);
	legend([h1a,h1b,h1c],{'Robot pos','Estimated robot pos','Detected landmarks'});
    hold off
    
    subplot(1,3,2)
    h2 = scatter(measuredPoints(AllLmks,1),measuredPoints(AllLmks,2),'r*'); hold on
    plot(room(:,1),room(:,2),'k'); 
	norm = max([norm,max(max(w_boxes{k}))]);
	
	title(sprintf('k = %d',k));
    plotBoxesColor(Boxes{k},w_boxes{k},max(max(w_boxes{k})),'none',1,jet); 
	axis(ax); 
	legend(h2,'Measured landmarks');
	hold off
    
    subplot(1,3,3)
    plot(measuredPoints(AllLmks,1),measuredPoints(AllLmks,2),'k');
	legend('Map');
    
    drawnow
%     pause(0.01);
if(pr)
	print([path sprintf('k_%d',k)],'-djpeg');
	print([path sprintf('k_%d',k)],'-dpng');
	writeVideo(outputVideo,imread([path sprintf('k_%d.jpg',k)]));
end 
    
end

if(pr)
close(outputVideo)
end

%%
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
fprintf(fileID,'\\item Boxes width = $[%f,%f]$\n',acc(1),acc(1));
%fprintf(fileID,'\\item Number of particles/boxes = $%d$\n',NP);
fprintf(fileID,'\\end{itemize}\n');
fclose(fileID);
end
%%
figure;
plot(room(:,1),room(:,2),'k'); hold on;
plot(measuredPoints(AllLmks,1),measuredPoints(AllLmks,2),'r');
plot(x(:,1),x(:,2),'b');
draw_tank([x_med(1,:),theta_measure(1)],'b',0.1);
scatter(measuredPoints(AllLmks,1),measuredPoints(AllLmks,2),'r');
axis(ax)
legend('Real room','Estimated map','Path')
if(pr)
    print([path sprintf('final_map',k)],'-djpeg');
	print([path sprintf('final_map',k)],'-dpng');
end

%%
figure
err_dead = normVec(room - measuredPoints);
	plot(err_dead)
if(pr)
	print([path sprintf('error',k)],'-djpeg');
	print([path sprintf('error',k)],'-dpng');
end

