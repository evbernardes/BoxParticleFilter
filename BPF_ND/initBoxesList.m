%*********************************************************************** 
%									 
%	-- Initialise Box cell array
%
%	- Usage = 
%		Boxes = initBoxesList(lb,ub,accuracy)
%
%	- inputs =
%		- lb - DOUBLE ARRAY, lower bound in each dimension
%		- ub - DOUBLE ARRAY, upper bound in each dimension
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
% 	Code version:	1.2
%	- 1.1: name changed from initBoxVar to initBoxesArray
%	- 1.2: name changed from initBoxesArray to initBoxesList
%
%	last edited in:	27/09/2017 						 
%									 
%***********************************************************************
function Boxes = initBoxesList(lb,ub,accuracy)
	
    lb = floor(lb./accuracy).*accuracy;
    ub = ceil(ub./accuracy).*accuracy;
    
	N = length(lb);
	pos = cell(N,1);
	idx = cell(N,1);
	for i = 1:N
		pos{i} = lb(i):accuracy(i):ub(i);
		idx{i} = 1:length(pos{i})-1;
	end
    
	% find all possible combinations
	combs = cell(1,N); %// pre-define to generate comma-separated list
	[combs{end:-1:1}] = ndgrid(idx{end:-1:1}); %// the reverse order in these two
	%// comma-separated lists is needed to produce the rows of the result matrix in
	%// lexicographical order 
	combs = cat(N+1, combs{:}); %// concat the n n-dim arrays along dimension n+1
	combs = reshape(combs,[],N); %// reshape to obtain desired matrix
	
	% create box list
	NBoxes = length(combs);
	Boxes = cell(1,NBoxes);
	for i = 1:NBoxes
		Boxes{i} = Interval([combs(i,:);combs(i,:)+accuracy]);
	end
end
