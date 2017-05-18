    %% Measurement update
    % For each box, check distance to landmarks
    function  [w_boxes_new,x_med_k_new,NORM] = measurementUpdate1D(w_boxes,x_med_k,Boxes,pe)
        %tic
        % get dimensions of boxes
        N = numel(Boxes);
        
        test = w_boxes > 1/(N*100);
        I=find(test);
%         K = find(test);
        x_med_k_new = x_med_k*0;
        
        for i=1:length(I),
            % Evaluate measurements (i.e., create weights) using the pdf for the normal distribution
            
            bds = getBounds(Boxes{i});
            Like = 1;
            for m=1:length(pe)
                % error pdf to be integrated
                Like = Like*100*integral(pe{m},bds(1),bds(2)); % integration of pdf
            end

            w_boxes(i)=w_boxes(i)*Like;
            x_med_k_new=x_med_k_new+w_boxes(i).*Boxes{i}.mid();
        end

        % Normalisation
        NORM = sum(sum(w_boxes));
%         x_med_k_new=x_med_k;
        w_boxes_new=w_boxes.*test; % small boxes go to zero
        if(NORM == 0), 
            warning('Normalization constant = 0')
        else
            x_med_k_new=x_med_k_new/NORM;
            w_boxes_new=w_boxes/NORM;
        end
    end