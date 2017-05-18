function [i_idx,j_idx,k_idx] = findIndexes2(BigBox,Boxes,grid_size)
    persistent I; persistent J;
    if(isempty(I) || isempty(J))
%         I = cellfun(@(x) x(1).mid, Boxes(:,1));
%         J = cellfun(@(x) x(2).mid, Boxes(1,:));
        
        I = Boxes((1:grid_size(1))*grid_size(2),1).mid';
        J = Boxes(1:grid_size(2),2).mid';
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
    
    N = length(i_idx)*length(j_idx);
    k_idx = zeros(N,1); n = 1;
    for i = i_idx
        for j = j_idx
            k_idx(n) = j + (i-1)*grid_size(2); n = n+1;
        end
    end        
end