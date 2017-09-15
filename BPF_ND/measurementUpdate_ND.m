%*********************************************************************** 
%									 
%	-- Measurement update for 2D box particle filtering.
%   
%
%	- Usage = 
%		[w_boxes_new,x_med_k_new,NORM] = measurementUpdate(w_boxes,Boxes,pe)
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
% 	Code version:	1.0
%
%	last edited in:	30/05/2017 						 
%									 
%***********************************************************************
    function  [w_boxes_new,x_med_k_new,NORM] = measurementUpdate_ND(w_boxes,Boxes,pe,integralInfo)
        % get dimensions of boxes
        N = numel(Boxes);
        x_med_k = zeros(1,length(Boxes{1}));
        
        %test = w_boxes > 1/(N*50);
% 		test = w_boxes >= mean(w_boxes);
 		test = w_boxes ~= 0;
		%[a,b] = sort(w_boxes);
        [I]=find(test);
        
        for k=1:length(I),
            % Evaluate measurements (i.e., create weights) using the pdf for the normal distribution
            i = I(k);
            
            bds = getBounds(Boxes{i});
            Like = 1;
            for m=1:length(pe)
                % error pdf to be integrated
				if(integralInfo{m,1} == 1)
					xm = integralInfo{m,2};
					Like = Like*100*quad(pe{m},bds(1,xm),bds(2,xm)); % integration of pdf
				elseif(integralInfo{m,1} == 2)
					xm = integralInfo{m,2}(1);
					ym = integralInfo{m,2}(2);
					Like = Like*100*quad2d(pe{m},bds(1,xm),bds(2,xm),bds(1,ym),bds(2,ym)); % integration of pdf
				end
            end

            w_boxes(i)=w_boxes(i)*Like;
            x_med_k=x_med_k+w_boxes(i).*Boxes{i}.mid();
        end
		
		[a,b] = sort(w_boxes);
		%w_boxes = w_boxes(w_boxes > mean(w_boxes));
        % Normalisation
        NORM = sum(sum(w_boxes));
        x_med_k_new=x_med_k;
        %w_boxes_new=w_boxes.*test; % small boxes go to zero
		w_boxes_new=w_boxes;
		w_boxes_new(b(1:end-100)) = 0;
        if(NORM == 0), 
            warning('Normalizing constant = 0')
        else
            x_med_k_new=x_med_k/NORM;
            w_boxes_new=w_boxes_new/NORM;
        end
    end