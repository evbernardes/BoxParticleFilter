%*********************************************************************** 
%									 
%	-- 2D box particle filtering. 
%
%	- Usage = 
%		[w_boxes,x_med] = BPF2D(N,Boxes,ts,stateFunction,stateInput,pe,show,w_boxes0)
%
%	- inputs =
%		- N - INT, number of boxes (can be slightly different if the number
%		doesn't have an integer square root).
%		- Boxes - CELL ARRAY, defines all boxes
%       - ts - DOUBLE, sampling time
%       - stateFunction - LAMBDA FUNCTION, state evolution
%       - stateInput - CELL ARRAY, state function input
%       - pe - CELL ARRAY, landmark distribution functions in (x,y) and time
%       - [OPTIONAL] show - BOOL, if true, show the number of each time
%       step (default = false).
%       - [OPTIONAL] w_boxes0 - DOUBLE ARRAY, probability distribution at
%       initial time (default = ).
%
%	- outputs = 	
%       - w_boxes - CELL ARRAY, probability distribution at each step
%       - x_med - DOUBLE ARRAY, estimation using w_boxes
%									 
%	-> MATLAB version used:	
%		- 9.0.0.341360 (R2016a) 64-bit	
%				 
% 	-> Special toolboxes used: 
%		-- none	--
%
% 	-> Other dependencies: 
%		- Interval.m
%		- measurementUpdate.m
%		- stateUpdate.m
%									 
%	-> Created by Evandro Bernardes	 								 
%		- at IRI (Barcelona, Catalonia, Spain)							 								 
%									 
% 	Code version:	1.2
%   - 1.1: optional variables processing corrected
%	- 1.2: name changed from BoxPFiltar2DVar to BPF2D
%
%	last edited in:	13/09/2017 						 
%									 
%***********************************************************************
function [Boxes,W,x_med] = BPF2D(Boxes_0,w_0,ts,sFunction,sInput,pe)
   
    N = length(sInput);
    x_med = zeros(N,2);
    accuracy = Boxes_0{1,1}.width;
    
    Boxes = cell(N+1,1); Boxes{1} = Boxes_0;
    W = cell(N+1,1); W{1} = w_0;

    %% Main loop
    % here the box particle filtering algorithm is implemented
    pek = cell(size(pe));
    for k=1:N,
    %     if(show)
%             disp(k)
    %     end
        %% Measurement update
        for m = 1:length(pek)
            pek{m} = @(x,y) pe{m}(x,y,k);
        end

        % measurement update
        [W{k},x_med(k,:)] = measurementUpdate(W{k},Boxes{k},pek);

        %% State update Resampling
        % Use input to calculate stateUpdate;
        [W{k+1},Boxes{k+1}] = stateUpdate(W{k},Boxes{k},accuracy,sFunction,sInput{k},ts);
    end
end
