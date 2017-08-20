% function check = checkLmks(delta,angles,corners)
    % find first
    
% end
dtheta;

idxs = zeros(length(room),1);
% find first
[idxfirst] = find(abs(angles - dtheta) < 0.2);
temp = 1000*ones(size(room)); temp(idxfirst,:) = room(idxfirst,:); 
[~,idxfirst] = min(normVec(bsxfun(@minus,temp,x(k,:))));
idxs(idxfirst) = 1;

% find last
[idxlast] = find(abs(angles + dtheta) < 0.2);
temp = 1000*ones(size(room)); temp(idxlast,:) = room(idxlast,:); 
[~,idxlast] = min(normVec(bsxfun(@minus,temp,x(k,:))));
idxs(idxlast) = 1;

%% direction
if(angles(idxfirst + 1) < dtheta)
    dir = 1;
else
    dir = -1;
end
% idx = idxmin;
%% until corner
isCorner = false;
i = idxfirst;
while(~isCorner)
    isCorner = checkIfCorner(room(i,:),corners);
    idxs(i) = 1;
    i = i+dir;
end

%% jump
[idx] = find(abs(angles - angles(i-1)) < 0.1);
[~,idx] = min(normVec(bsxfun(@minus,room(idx,:),x(k,:))));
idxs(idx) = 1;


    

