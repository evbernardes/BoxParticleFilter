function plotBoxGrid(Boxes,EdgeColor,FillColor,LineWidth)
    if nargin == 2
        LineWidth = 1;
    end
    [i_max,j_max] = size(Boxes);
    check = ishold;
    hold on;
    for i = 1:i_max
        for j = 1:j_max
            plot(Boxes{i,j},EdgeColor,FillColor,LineWidth);
        end
    end
    if(~check)
        hold off;
    end
    X0 = Boxes{1,1}.low; X1 = Boxes{end,end}.high;
%     axis([X0(1) X1(1) X0(2) X1(2)])
end