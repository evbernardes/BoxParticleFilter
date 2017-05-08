function [i,j] = findClosestCorner(Corners,Box)
    CornersMid = cellfun(@mid,Corners,'UniformOutput',false);
    
    test = cell(2,2);
    test(:) = {Box.mid};
    test = cellfun(@norm,cellfun(@minus,CornersMid,test,'UniformOutput',false));
    [~,I] = min(test(:)); [i, j] = ind2sub(size(test),I);
    
end