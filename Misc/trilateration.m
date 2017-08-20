function pos = trilateration(dist,p)
%     p = [p1;p2;p3];
    a = @(m,n) p(m,1) - p(n,1);
    b = @(m,n) p(m,2) - p(n,2);
    c = @(m,n) ((dist(n)^2 - p(n,1)^2 - p(n,2)^2) - (dist(m)^2 - p(m,1)^2 - p(m,2)^2))/2;
    
    K = (2:length(p))';
    A = arrayfun(@(x) a(x,1),K);
    B = arrayfun(@(x) b(x,1),K);
    C = arrayfun(@(x) c(x,1),K);
    AB = [A B];
    
    pos = ((AB' * AB) \ AB')*C;
%     pos = AB \ C;
    pos = pos';
end