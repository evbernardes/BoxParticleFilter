%% Resampling
% New boxes affected by neighbouring old boxes
function boxes_new = resamp(boxes)
    [i_max,j_max]=size(boxes);
    boxes_new=zeros(size(boxes));
    
    for i=1:i_max,
        for j=1:j_max,
            % select indexes to be affected by box at the center
            i_idx = max(i-1,1):min(i+1,i_max); j_idx = max(j-1,1):min(j+1,j_max);

            % number of neighbouring boxes to be affected
            %n = length([i_idx,j_idx]);
            n = length(i_idx)*length(j_idx);

            boxes_new(i_idx,j_idx)=boxes_new(i_idx,j_idx)+(1/n)*boxes(i,j);
        end
    end
end