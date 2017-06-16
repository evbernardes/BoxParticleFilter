%*********************************************************************** 
%									 
%	-- Plot all boxes in a box cell array
%
%	- Usage = 
%		plotBoxGrid(Boxes,EdgeColor,FillColor,LineWidth)
%
%	- inputs =
%		- Boxes - CELL ARRAY, box grid
%		- EdgeColor - STRING or COLOR TRIPLET
%		- FillColor - STRING or COLOR TRIPLET [OPTIONAL, DEFAULT = 'none']
%       - LineWidth - DOUBLE, [OPTIONAL, DEFAULT = 1]
%
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
%	last edited in:	16/06/2017 						 
%									 
%***********************************************************************
function plotBoxGrid(Boxes,EdgeColor,FillColor,LineWidth)
    if nargin == 2
        FillColor = 'none';
        LineWidth = 1;
    end
    if nargin == 3
        LineWidth = 1;
    end
    [i_max,j_max] = size(Boxes);
    check = ishold;
    hold on;
    for i = 1:i_max
        for j = 1:j_max
            plot(Boxes{i,j},EdgeColor,FillColor,LineWidth);
        end
    end
    if(~check)
        hold off;
    end
    X0 = Boxes{1,1}.low; X1 = Boxes{end,end}.high;
%     axis([X0(1) X1(1) X0(2) X1(2)])
end