%*********************************************************************** 
%									 
%	-- State Update for 2D box particle filtering. Variable fixed size 
%   boxes.
%   Uses state function, state input and sampling time on each box inside 
%   cell array "Boxes" to evolve their respective weights.
%
%	- Usage = 
%		[w_new,Boxes_new] = stateUpdate(w,Boxes,accuracy,sFunction,sInput,ts)
%
%	- inputs =
%		- w - DOUBLE ARRAY, probability distribution
%		- Boxes - CELL ARRAY, defines all boxes
%       - accuracy - DOUBLE ARRAY, defines box width in both dimensions
%       - sFunction - LAMBDA FUNCTION, state evolution
%       - sInput - INTERVAL VECTOR, state function inputs
%       - ts - DOUBLE, sampling time
%
%	- outputs = 	
%       - w_new  - DOUBLE ARRAY, new probability distribution
%       (normalized)
%       - Boxes_new - CELL ARRAY, defines all new boxes
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
% 	Code version:	1.0
%	- 1.2: name changed from stateUpdateVar to stateUpdate
%
%	last edited in:	13/09/2017 						 
%									 
%***********************************************************************
function [w_new,Boxes_new] = stateUpdate(w,Boxes,accuracy,sFunction,sInput,ts)
    
    % find all boxes with non-zero weight
    [i,j] = find(w);
    if(isempty(i))
        error('Weight distribution is all zero')
    end
    
    % apply state function to all non-zero weight boxes
    BigBoxes = cell(length(i),1);
    lb = zeros(length(i),2); ub = zeros(length(i),2);
    for k=1:length(i)
        BigBoxes{k} = sFunction(Boxes{i(k),j(k)},sInput,ts);
        lb(k,:) = BigBoxes{k}.low; ub(k,:) = BigBoxes{k}.high;
    end
    
    % new boxes array and weight array
    lb = min(lb); ub = max(ub);
    Boxes_new = initBoxesArray(lb,ub,accuracy);
    w_new=zeros(size(Boxes_new));
    
    % loop for all non-zero boxes
    for k=1:length(i),
        
        % find intersection area between state function output with each 
        [i_idx,j_idx] = findIndexes(BigBoxes{k},Boxes_new);
        A = zeros(length(i_idx),length(j_idx));
        for n = 1:length(i_idx)
            for m = 1:length(j_idx)
                A(n,m) = vol(quickBoxAnd(Boxes_new{i_idx(n),j_idx(m)},BigBoxes{k}));
            end
        end
        
        w_new(i_idx,j_idx)=w_new(i_idx,j_idx)+A.*w(i(k),j(k));
            
    end
end
