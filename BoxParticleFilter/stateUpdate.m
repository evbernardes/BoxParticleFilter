%*********************************************************************** 
%									 
%	-- State Update for 2D box particle filtering. Uses state function,
%	state input and sampling time on each box inside cell array "Boxes" to
%	evolve their respective weights.
%
%
%	- Usage = 
%		w_boxes_new = stateUpdate(w_boxes,Boxes,stateFunction,stateInput,ts)
%
%	- inputs =
%		- w_boxes - DOUBLE ARRAY, probability distribution
%		- Boxes - CELL ARRAY, defines all boxes
%       - stateFunction - LAMBDA FUNCTION, state evolution
%       - stateInput - INTERVAL VECTOR, state function inputs
%       - ts - DOUBLE, sampling time
%
%	- outputs = 	
%       - w_boxes_new  - DOUBLE ARRAY, new probability distribution
%       (normalized)
%									 
%	-> MATLAB version used:	
%		- 9.0.0.341360 (R2016a) 64-bit
%				 
% 	-> Special toolboxes used: 
%		-- none	--
%
% 	-> Other dependencies: 
%		- Interval.m
%		- findClosestCorner.m
%		- findIndexes.m
%									 
%	-> Created by Evandro Bernardes	 								 
%		- at IRI (Barcelona, Catalonia, Spain)							 								 
%									 
% 	Code version:	1.1
%   - 1.1: now only looping through non-zero values of weight array
%
%	last edited in:	15/06/2017 						 
%									 
%***********************************************************************
function w_boxes_new = stateUpdate(w_boxes,Boxes,stateFunction,stateInput,ts)
%     persistent T;
%     if(isempty(T))
%         T = zeros(9,1);
%     end
%     m1=T(1); m2=T(2); m3=T(3); m4=T(4); m5=T(5); m6=T(6); m7=T(7); m8=T(8);m9=T(9);

    Corners = Boxes([1,end],[1,end]);
    LB = Boxes{1,1}.low; UB = Boxes{end,end}.high;
    TotalBox = Interval([LB(1) UB(1)], [LB(2) UB(2)]);
    
    [i,j] = find(w_boxes);
    w_boxes_new=zeros(size(w_boxes));
    
    for k=1:length(i),
            
        % if contracted box is not inside the enclosed area, find the
        % nearest box
        BigBox = TotalBox&stateFunction(Boxes{i(k),j(k)},stateInput,ts);
        if(sum(BigBox.isempty) > 0)
            BigBox = findClosestCorner(Corners,BigBox);
        end
        
        % select indexes to be affected by box at the center
        [i_idx,j_idx] = findIndexes(BigBox,Boxes);
        
        tic;
        A = zeros(length(i_idx),length(j_idx));
        for n = 1:length(i_idx)
            for m = 1:length(j_idx)
                A(n,m) = vol(quickBoxAnd(Boxes{i_idx(n),j_idx(m)},BigBox));
            end
        end
        
        w_boxes_new(i_idx,j_idx)=w_boxes_new(i_idx,j_idx)+A.*w_boxes(i(k),j(k));
            
    end
%     T = [m1,m2,m3,m4,m5,m6,m7,m8,m9]; disp(T)
end