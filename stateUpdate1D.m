%% Resampling
% New boxes affected by neighbouring old boxes
function [w_boxes_new] = stateUpdate1D(w_boxes,Boxes,stateFunction,stateInput,ts)

    Corners = Boxes([1,end]);
    LB = Boxes{1}.low; UB = Boxes{end}.high;
    TotalBox = Interval([LB(1) UB(1)]);
    
    [i_max]=size(w_boxes);
    w_boxes_new=zeros(size(w_boxes));
    
    BigBoxes = cell(size(Boxes));
    BigBoxesC = cell(size(Boxes));
    
    for i=1:i_max,
        BigBoxes{i} = stateFunction(Boxes{i},stateInput,ts);
        BigBoxesC{i} = TotalBox&BigBoxes{i};
            
        % if contracted box is not inside the enclosed area, find the
        % nearest box
        if(sum(BigBoxesC{i}.isempty) > 0)
            if(BigBoxes{i}.low < TotalBox.low)
                BigBoxesC{i} = Boxes{1};
            else
                BigBoxesC{i} = Boxes{end};
            end
        end
            
        % select indexes to be affected by box at the center
        i_idx = findIndexes1D(BigBoxesC{i},Boxes); %m2 = m2+toc;
        
        A = cell(length(i_idx),1);
        for n = 1:length(i_idx)
            A{n} = Boxes{i_idx(n)}&BigBoxesC{i};
        end
            
        A = cellfun(@vol,A)/vol(BigBoxesC{i}); % area of each intersection DIVIDED by total area
        w_boxes_new(i_idx)=w_boxes_new(i_idx)+A.*w_boxes(i);        
    end
end