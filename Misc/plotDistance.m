%*********************************************************************** 
%									 
%	-- For x1 and x2 of the same length N, plot a line showing the 
%	distances from x1(k) to x2(k) from k = 1,2,...,N
%
%	- Usage = 
%		plotDistance(x1,x2,EdgeColor,LineWidth)
%
%	- inputs =
%		- x1 - first vector
%		- x1 - second vector
%		- EdgeColor - STRING or COLOR TRIPLET
%       - LineWidth - DOUBLE, [OPTIONAL, DEFAULT = 1]
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
%	last edited in:	13/09/2017 						 
%									 
%***********************************************************************
function plotDistance(x1,x2,EdgeColor,LineWidth)
    if nargin == 3
        LineWidth = 1;
    end
    
    check = ishold;
    
    for k = 1:length(x1)
        if k==2; hold on; end
        xt = [x1(k,1),x2(k,1)];
        yt = [x1(k,2),x2(k,2)];
        switch nargin 
            case 2
                plot(xt,yt);
            case 3
                plot(xt,yt,EdgeColor);
            case 4
                plot(xt,yt,EdgeColor,'LineWidth',LineWidth);
        end
    end
    if(~check)
        hold off;
    end
end
