function plotDistance(x1,x2,EdgeColor,LineWidth)
    if nargin == 3
        LineWidth = 1;
    end
    
    check = ishold;
    
    for k = 1:length(x1)
        if k==2; hold on; end
        xt = [x1(k,1),x2(k,1)];
        yt = [x1(k,2),x2(k,2)];
        switch nargin 
            case 2
                plot(xt,yt);
            case 3
                plot(xt,yt,EdgeColor);
            case 4
                plot(xt,yt,EdgeColor,'LineWidth',LineWidth);
        end
    end
    if(~check)
        hold off;
    end
end