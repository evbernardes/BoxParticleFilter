function res = cosInterval(x)
    if(x.width >= 2*pi)
        res = Interval([-1,1]);
    else
        if(x.ub > pi)
            n = floor(x.ub/pi);
            x = x-n*pi;
        elseif(x.lb < pi)
            n = floor(abs(x.ub/pi));
            x = x+n*pi;
        end

        L = cos([x.lb,x.ub]);
        if(x.contains(0))
            L = [L,1];
        end
        L = ((-1)^n)*L;
        res = Interval([min(L),max(L)]);
    end
      
        
%     obj = Interval([wrapToPi(obj.lb),wrapToPi(obj.ub)]);
%         if(obj.contains(3*pi/2))
%             lb = -1;
%         else
%             lb = min([sin(obj.lb),sin(obj.ub)]);
%         end
%         
%         if(obj.contains(pi/2))
%             ub = 1;
%         else
%             ub = max([sin(obj.lb),sin(obj.ub)]);
%         end
%         
%         res = Interval([lb,ub]);
    

end