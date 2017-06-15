%*********************************************************************** 
%									 
%	-- Find the indexes of all boxes defined in the array Boxes which are
%	affected by BigBox.
%
%	- Usage = 
%		[i_idx,j_idx] = findIndexes(BigBox,Boxes)
%
%	- inputs =
%		- BigBox, INTERVAL VECTOR, box to be located
%		- Boxes - CELL ARRAY, box grid
%
%	- outputs = 	
%       - [i_idx,j_idx] - INTEGER ARRAYS, affected locations indexes
%									 
%	-> MATLAB version used:	
%		- 9.0.0.341360 (R2016a) 64-bit	
%				 
% 	-> Special toolboxes used: 
%		-- none	--
%
% 	-> Other dependencies: 
%		- Interval.m
%									 
%	-> Created by Evandro Bernardes	 								 
%		- at IRI (Barcelona, Catalonia, Spain)							 								 
%									 
% 	Code version:	1.0
%
%	last edited in:	01/06/2017 						 
%									 
%***********************************************************************
function [i_idx,j_idx] = findIndexesVar(BigBox,Boxes)

    I = cellfun(@(x) x(1).mid, Boxes(:,1));
	J = cellfun(@(x) x(2).mid, Boxes(1,:));

    low = BigBox.low; high = BigBox.high;
    
    [~,i_min] = min(abs(I - low(1)));
    [~,j_min] = min(abs(J - low(2)));
    
    [~,i_max] = min(abs(I - high(1)));
    [~,j_max] = min(abs(J - high(2)));

    if(sum(abs(I - high(1)) == min(abs(I - high(1)))) == 2)
        i_max = i_max + 1;
    end
    if(sum(abs(J - high(2)) == min(abs(J - high(2)))) == 2)
        j_max = j_max + 1;
    end
    
    i_idx = i_min:i_max;
    j_idx = j_min:j_max;
end