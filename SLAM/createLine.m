function line = createLine(p1,p2,dl)
    a = p2-p1; a = sqrt(a(2)^2 + a(1)^2);
    N = ceil(a/dl);
    line = [linspace(p1(1),p2(1),N)',linspace(p1(2),p2(2),N)'];
end