%*********************************************************************** 
%									 
%	-- Measurement update for 2D box particle filtering.
%   
%
%	- Usage = 
%		[w_boxes_new,x_med_k_new,NORM] = measurementUpdate_fixed(w_boxes,Boxes,pe)
%
%	- inputs =
%		- w_boxes - DOUBLE ARRAY, a priori probability distribution
%		- Boxes - CELL ARRAY, defines all boxes
%       - pe - CELL ARRAY of LAMBDA FUNCTIONS, multiples distribution
%       functions for each measurement
%
%	- outputs = 	
%		- w_boxes_new - DOUBLE ARRAY, a posteriori probability distribution
%       - x_med_k_new - DOUBLE ARRAY, a posteriori position estimation
%       - NORM - DOUBLE, normalizing constant
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
% 	Code version:	1.1
%	- 1.1:  name changed from measurementUpdate to measurementUpdate_fixed
%
%	last edited in:	13/09/2017 						 
%									 
%***********************************************************************
    function  [w_boxes_new,x_med_k_new,NORM] = measurementUpdate_fixed(w_boxes,Boxes,pe)
        % get dimensions of boxes
        N = numel(Boxes);
        x_med_k = zeros(1,2);
        
        test = w_boxes > 1/(N*50);
        [I,J]=find(test);
        
        for k=1:length(I),
            % Evaluate measurements (i.e., create weights) using the pdf for the normal distribution
            i = I(k); j = J(k);
            
            bds = getBounds(Boxes{i,j});
            Like = 1;
            for m=1:length(pe)
                % error pdf to be integrated
                Like = Like*100*quad2d(pe{m},bds(1,1),bds(2,1),bds(1,2),bds(2,2)); % integration of pdf
            end

            w_boxes(i,j)=w_boxes(i,j)*Like;
            x_med_k=x_med_k+w_boxes(i,j).*Boxes{i,j}.mid();
        end

        % Normalisation
        NORM = sum(sum(w_boxes));
        x_med_k_new=x_med_k;
        w_boxes_new=w_boxes.*test; % small boxes go to zero
        if(NORM == 0), 
            warning('Normalizing constant = 0')
        else
            x_med_k_new=x_med_k/NORM;
            w_boxes_new=w_boxes_new/NORM;
        end
    end
