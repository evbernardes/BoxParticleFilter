function wall = createWall(dl,corners,close)
    if nargin == 2
        close = true;
    end

    N = length(corners);
    wall = [];
    for i = 1:N-1
        line = createLine(corners(i,:),corners(i+1,:),dl);
        wall = [wall(1:end-1,:);line];
    end
    
    if(close)
        line = createLine(corners(N,:),corners(1,:),dl);
        wall = [wall;line];
    end
end
    