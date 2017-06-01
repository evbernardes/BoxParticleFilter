function [i_idx,j_idx] = findIndexes(BigBox,Boxes)
    persistent I; persistent J;
    if(isempty(I) || isempty(J))
        I = cellfun(@(x) x(1).mid, Boxes(:,1));
        J = cellfun(@(x) x(2).mid, Boxes(1,:));
    end
    
    low = BigBox.low; high = BigBox.high;
    
    [~,i_min] = min(abs(I - low(1)));
    [~,j_min] = min(abs(J - low(2)));
    
    [~,i_max] = min(abs(I - high(1)));
    [~,j_max] = min(abs(J - high(2)));

    if(sum(abs(I - high(1)) == min(abs(I - high(1)))) == 2)
        i_max = i_max + 1;
    end
    if(sum(abs(J - high(2)) == min(abs(J - high(2)))) == 2)
        j_max = j_max + 1;
    end
    
    i_idx = i_min:i_max;
    j_idx = j_min:j_max;
end