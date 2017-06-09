%*********************************************************************** 
%									 
%	-- 2D conventional particle filtering. 
%
%
%	- Usage = 
%		[w,x_med] = ConvPFilter2D(N,particles,ts,stateFunction,stateInput,pe,varargin)
%
%	- inputs =
%		- N - INT, number of boxes (can be slightly different if the number
%		doesn't have an integer square root).
%		- particles - CELL ARRAY, defines all particles in each step
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
%		-- none --
%									 
%	-> Created by Evandro Bernardes	 								 
%		- at IRI (Barcelona, Catalonia, Spain)							 								 
%									 
% 	Code version:	1
%
%	last edited in:	09/06/2017 						 
%									 
%***********************************************************************
function [w,x_med] = ConvPFilter2D(N,particles,ts,stateFunction,stateInput,pe,varargin)

    w = cell(N,1);
    x_med=zeros(N,2);
    
    switch(nargin)
        case 7
            show = varargin{1};
            w{1}=1/length(particles{1})*ones(length(particles{1}),1);
        case 8
            show = varargin{1};
            w{1} = varargin{2};
        otherwise
            show = false;
            w{1}=1/length(particles{1})*ones(length(particles{1}),2);
    end

    for k = 1:N
        if(show)
            disp(k)
        end
        
        Like = 1;
        for m = 1:size(pe,1)
            Like = Like.*pe{m}(particles{k}(:,1),particles{k}(:,2),k);
        end

        w{k} = w{k}.*Like;
        w{k} = w{k}/sum(w{k});

        [Inew]=rsmp(w{k});
        particles{k} = particles{k}(Inew,:);

        w{k+1}=1/length(particles{1})*ones(length(particles{1}),1);

        x_med(k,:)=mean(particles{k});

        for i = 1:length(particles{k})
            particles{k+1}(i,:) = stateFunction(particles{k}(i,:),stateInput(k,:),ts);
        end
    end
    
end