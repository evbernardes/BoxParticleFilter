%*********************************************************************** 
%									 
%	-- Initialise particles for the conventional particle filter
%
%	- Usage = 
%		Boxes = initParticles(x_min,x_max,NP)
%
%	- inputs =
%		- x_min - DOUBLE ARRAY, lower bound in each dimension
%		- x_max - DOUBLE ARRAY, upper bound in each dimension
%		- NP - INTEGER, number of particles
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
%		-- none --
%									 
%	-> Created by Evandro Bernardes	 								 
%		- at IRI (Barcelona, Catalonia, Spain)							 								 
%									 
% 	Code version:	1.0
%
%	last edited in:	17/09/2017 						 
%									 
%***********************************************************************
function particles = initParticles(x_min,x_max,NP)
	SizeParticles = ceil([sqrt(NP) sqrt(NP)]); 
	NP = prod(SizeParticles);

	particles_x1 = x_min(1)+rand(NP,1)*(x_max(1)-x_min(1));
	particles_x2 = x_min(2)+rand(NP,1)*(x_max(2)-x_min(2));
	particles = [particles_x1,particles_x2]';
end