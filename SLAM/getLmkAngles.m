function angles = getLmkAngles(p,theta,lmks)
    N = length(lmks);
    angles = zeros(N,1);
    for i = 1:N
        angles(i) = atan2(lmks(i,2) - p(2),lmks(i,1) - p(1)) - theta;
    end
    
    
end