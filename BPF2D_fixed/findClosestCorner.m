%*********************************************************************** 
%									 
%	-- Find closest corner. Each dimension of the Box that passes the
%	limits defined by the Corners will be given the same value as the
%	closest corner.
%
%
%	- Usage = 
%		NewBox = findClosestCorner(Corners,Box)
%
%	- inputs =
%		- Corners, CELL ARRAY, corner boxes
%		- Box - INTERVAL VECTOR, Box whose closest corner must be found
%
%	- outputs = 	
%       - NewBox - INTERVAL VECTOR, Box with corners within limits
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
function NewBox = findClosestCorner(Corners,Box)
    CornersMid = cellfun(@mid,Corners,'UniformOutput',false);
    
    test = cell(2,2);
    test(:) = {Box.mid};
    test = cellfun(@norm,cellfun(@minus,CornersMid,test,'UniformOutput',false));
    [~,I] = min(test(:)); [i, j] = ind2sub(size(test),I);
    
    NewBox = Box;
    if(NewBox(1).isempty)
        NewBox(1) = Corners{i,j}(1);
    elseif(NewBox(2).isempty)
        NewBox(2) = Corners{i,j}(2);
    end
    
end
