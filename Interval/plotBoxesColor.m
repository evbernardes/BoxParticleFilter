%*********************************************************************** 
%									 
%	-- Plot box grid using a colormap to show weight distribution
%
%	- Usage = 
%		plotBoxesColor(Boxes,w,norm,EdgeColor,LineWidth,cmap)
%
%	- inputs =
%		- Boxes - CELL ARRAY, box grid
%		- w - ARRAY, weight distribution
%       - norm - DOUBLE, max weight value for scale 
%   [OPTIONAL, DEFAULT = max(max(w))]
%		- EdgeColor - STRING or COLOR TRIPLET [OPTIONAL, DEFAULT = 'none']
%       - LineWidth - DOUBLE, [OPTIONAL, DEFAULT = 1]
%       - cmap - 3xN ARRAY, colormap with triplets [OPTIONAL, DEF = 'jet']
%					
%
%   OBS.: norm variable must be set for correct scaling if multiple weight
%   distribution are being plotted in sequence. Otherwise, the colorbar
%   legend will change at each different plot.
%
%   To calculate the norm value before this function is being called for
%   multiple iterations of a cell array W = {w(1),...w(n)}, the following
%   code can be used:
%     norm = max(cellfun(@(x) max(max(x)),W));
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
function plotBoxesColor(Boxes,w,norm,EdgeColor,LineWidth,cmap)
    
    switch(nargin)
        case 2
            norm = max(max(w));
            LineWidth = 1;
            EdgeColor = 'none';
            cmap = jet(100);
        case 3
            LineWidth = 1;
            EdgeColor = 'none';
            cmap = jet(100);
        case 4
            LineWidth = 1;
            cmap = jet(100);
        case 5
            cmap = jet(100);
    end
    
    check = ishold;
    hold on;
    w = w/norm;
    MN = size(Boxes);
    if(size(w) ~= MN)
        error('Array sizes must be equal')
    end

%     w = w/max(max(w));
    [i,j] = find(w); n = length(cmap);
    for k = 1:length(i)
       hold on;
       c = cmap(ceil(n*w(i(k),j(k))),:);
       plot(Boxes{i(k),j(k)},EdgeColor,c,LineWidth)
    end
    colorbar
    caxis([0 norm]);
    if(~check)
        hold off;
    end
end