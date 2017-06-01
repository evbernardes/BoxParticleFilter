function NewBox = findClosestCorner(Corners,Box)
    CornersMid = cellfun(@mid,Corners,'UniformOutput',false);
    
    test = cell(2,2);
    test(:) = {Box.mid};
    test = cellfun(@norm,cellfun(@minus,CornersMid,test,'UniformOutput',false));
    [~,I] = min(test(:)); [i, j] = ind2sub(size(test),I);
    
    NewBox = Box;
    if(NewBox(1).isempty)
        NewBox(1) = Corners{i,j}(1);
    elseif(NewBox(2).isempty)
        NewBox(2) = Corners{i,j}(2);
    end
    
end