%*********************************************************************** 
%									 
%	-- Initialise Box cell array
%
%	- Usage = 
%		Boxes = initBoxesArray(lb,ub,accuracy)
%
%	- inputs =
%		- lb - DOUBLE ARRAY, lower bound in each dimension
%		- ub - DOUBLE ARRAY, upper bound in each dimension
%		- accuracy - DOUBLE ARRAY, accuracy in each dimension
%
%	- outputs = 	
%       - Boxes - CELL ARRAY, defines all new boxes
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
%		- findIndexesVar.m
%									 
%	-> Created by Evandro Bernardes	 								 
%		- at IRI (Barcelona, Catalonia, Spain)							 								 
%									 
% 	Code version:	1.1
%	- 1.1: name changed from initBoxVar to initBoxesArray
%
%	last edited in:	13/09/2017 						 
%									 
%***********************************************************************
function Boxes = initBoxesArray(lb,ub,accuracy)

    lb = floor(lb./accuracy).*accuracy;
    ub = ceil(ub./accuracy).*accuracy;
    MN = ceil((ub-lb)./accuracy);
    
    pos_x1 = lb(1) + (0:MN(1))*accuracy(1);
    pos_x2 = lb(2) + (0:MN(2))*accuracy(2);
    
    Boxes = cell(MN);
    for i=1:MN(1)
        for j=1:MN(2)
           Boxes{i,j} = Interval(pos_x1(i:i+1),pos_x2(j:j+1));
        end
    end
end
