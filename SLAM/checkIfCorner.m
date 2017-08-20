function check = checkIfCorner(p,corners)
    check = false;
    for i = 1:length(corners) 
        if(p(2) == corners(i,2) && p(1) == corners(i,1))
            check = true;
            break;
        end
    end
end