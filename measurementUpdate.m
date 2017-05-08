    %% Measurement update
    % For each box, check distance to landmarks
    function  [w_boxes_new,x_med_k_new,NORM] = measurementUpdate(w_boxes,x_med_k,Boxes,pe)
        %tic
        % get dimensions of boxes
        N = numel(Boxes);
        
        test = w_boxes > 1/(N*100);
        [I,J]=find(test);
        
        for k=1:length(I),
            % Evaluate measurements (i.e., create weights) using the pdf for the normal distribution
%             x_ini = Boxes{I(k),J(k)}(1).lb; x_end = Boxes{I(k),J(k)}(1).ub; % integral limits
%             y_ini = Boxes{I(k),J(k)}.y.lb; y_end = Boxes{I(k),J(k)}.y.ub;
            bds = getBounds(Boxes{I(k),J(k)});
            Like = 1;
            for m=1:length(pe)
                % error pdf to be integrated
                Like = Like*100*quad2d(pe{m},bds(1,1),bds(2,1),bds(1,2),bds(2,2)); % integration of pdf
            end

            w_boxes(I(k),J(k))=w_boxes(I(k),J(k))*Like;
            x_med_k=x_med_k+w_boxes(I(k),J(k)).*Boxes{I(k),J(k)}.mid();
        end

        % Normalisation
        NORM = sum(sum(w_boxes));
        x_med_k_new=x_med_k;
        w_boxes_new=w_boxes;%.*test; % small boxes go to zero
        if(NORM == 0), 
            warning('Normalization constant = 0')
        else
            x_med_k_new=x_med_k/NORM;
            w_boxes_new=w_boxes/NORM;
        end
    end