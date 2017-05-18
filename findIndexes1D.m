function [i_idx] = findIndexes1D(BigBox,Boxes)
    persistent I;
    if(isempty(I))
        I = cellfun(@(x) x(1).mid, Boxes(:,1));
    end
    
    low = BigBox.low; high = BigBox.high;
    
    [~,i_min] = min(abs(I - low));
    [~,i_max] = min(abs(I - high));

    if(sum(abs(I - high(1)) == min(abs(I - high(1)))) == 2)
        i_max = i_max + 1;
    end
    
    i_idx = i_min:i_max;
end