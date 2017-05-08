%   Interval Class
%
%   Implementation of basic Interval class for Interval Analysis
%
%   Interval([lb,ub]) creates the Interval [lb ... ub]
%
%   Interval(x) creates the Interval [x ... x] if length(x) = 1 and
%   [min(x) ... max(x)] if length(x) > 1;
%
%   Interval(x1, x2, ... , xn) will create an Interval vector using each
%   entry parameter. The entries can be viewed as it is done with a regular
%   vector: Ik = I(k).
%
%   All the arithmetic operators have been overloaded, and using the point
%   version of and arithmetic operation will give the same result as the
%   non point version (ex: * == .*)
%
%   To see more function implemented for the Interval class, please consult
%   the code file.
%
%   Created by Evandro Bernardes
%   Based on IAMOOC, the Interval Analysis course given by Luc Jaulin, 
%   following the link:
%   https://www.ensta-bretagne.fr/jaulin/iamooc.html
%
%   Version 1.0
%   4 May 2017
%
classdef Interval
    properties
        lb; ub;
    end
    methods
        %% Constructor
        function res = Interval(varargin)
            switch nargin
                case 1
                    res = res.init(varargin{1});
%                 case 2
%                     res = res.init([varargin{1},varargin{2}]);
                otherwise
                    res = Interval.empty(nargin,0);
                    for i=1:nargin
                        res(i) = Interval(varargin{i});
                    end 
            end
        end
        
        function obj = init(obj,boundaries)
            if(isempty(boundaries))
                obj.lb = []; obj.ub = [];
            elseif(length(boundaries) == 1)
                obj.lb = boundaries;
                obj.ub = obj.lb;
            else
                lb = boundaries(1); 
                ub = boundaries(2);
                if(ub>=lb)
                    obj.lb = lb;
                    obj.ub = ub;
                else
                    obj.lb = ub; obj.ub = lb;
                end
            end
        end
        
        function res = inflate(a,sigma)
            n = length(a);
            res = Interval.empty(n,0);
            if(length(sigma) == 1)
                for i = 1:n
                    res(i) = Interval([a(i).lb-sigma,a(i).ub+sigma]);
                end
            elseif(n == length(sigma))
                for i = 1:n
                    res(i) = Interval([a(i).lb-sigma(i),a(i).ub+sigma(i)]);
                end
            else
                error('Incompatible sizes')
            end
        end
        
        function res = applyForAll(f,a,b,isInterval)
            if(nargin ~= 4)
                isInterval = true;
            end
            
            n = length(a); m = length(b);
            if(n == 1)
                res = f(b,a);
            elseif(m == 1)
                if(isInterval)
                    res = Interval.empty(n,0);
                else
                    res = zeros(1,length(a));
                end
                for i = 1:n
                    res(i) = f(a(i),b);
                end
            elseif(n == m)
                if(isInterval)
                    res = Interval.empty(n,0);
                else
                    res = zeros(1,length(a));
                end
                for i = 1:n
                    res(i) = f(a(i),b(i));
                end
            else
                error('IntervalVector of different sizes');
            end
        end
        %% Operation Overloards
        
        function res = isempty(a)
            res = false(1,length(a));
            for i = 1:length(a)
                if(isempty(a(i).lb) || isempty(a(i).ub))
                    res(i) = true;
                else
                    res(i) = false;
                end
            end
        end        
        
        % Display function
        function disp(obj)
            str = '';
            n = length(obj);            
            for i = 1:n
                str = [str sprintf('[%f ... %f]',obj(i).lb,obj(i).ub)];
            end
            sprintf('%s',str)
        end
        
        % Check if interval contains value       
        function res = contains(a,b)
            n = length(a); m = length(b);
            if(n == 1 && m == 1)
                if(isnumeric(b))
                    res = b >= a.lb && b <= a.ub;
                elseif(isnumeric(a))
                    res = b.contains(a);
                else
                    res = b.lb >= a.lb && b.ub <= a.ub;
                end
            else
                res = applyForAll(@contains,a,b,false);
            end
        end
        
        % AND overloard (Interval intersection)
        function res = and(a,b)
            n = length(a); m = length(b);
            if(n == 1 && m == 1)
                if(a.isempty() || b.isempty())
                    res = Interval([]);
                elseif (a.ub <= b.lb || b.ub <= a.lb)
                    res = Interval([]);
                else
                    res = Interval([max([a.lb,b.lb]),min(a.ub,b.ub)]);
                end
            else
                res = applyForAll(@and,a,b);
            end
        end
        
        % OR overloard
        function res = or(a,b)
            if(length(a) == length(b))
                if a.isempty()
                    res = b;
                elseif b.isempty()
                    res = a;
                else
                    res = Interval([min([a.lb,b.lb]),max(a.ub,b.ub)]);
                end
            else
                res = applyForAll(@or,a,b);
            end
        end
        
        % Unary Plus override
        function res = uplus(a)
            res = a;
        end
        
        % Unary Minus override
        function res = uminus(a)
            for i = 1:length(a)
                a(i) = Interval([-a(i).ub,-a(i).lb]);
            end
            res = a;
        end
        
        % ADD overloard
        function res = plus(a,b)
            n = length(a); m = length(b);
            if(n == 1 && m == 1)
                if(isnumeric(b))
                    res = Interval([a.lb+b,a.ub+b]);
                elseif(isnumeric(a))
                    res = b+a;
                else
                    res = Interval([a.lb+b.lb,a.ub+b.ub]);
                end
            else
                res = applyForAll(@plus,a,b);
            end
        end
        
        % SUB overloard
        function res = minus(a,b)
            res = a+(-b);
        end
        
        % MULT override
        function res = mtimes(a,b), res = a.*b; end
        function res = times(a,b)
            if(isa(b,'Box'))
                res = b.*a;
            else
                n = length(a); m = length(b);
                if(n == 1 && m == 1)
                    if(isnumeric(b))
                        res = Interval([a.lb*b,a.ub*b]);
                    elseif(isnumeric(a))
                        res = b.*a;
                    else
                        L = [a.lb*b.lb,a.lb*b.ub,a.ub*b.lb,a.ub*b.ub];
                        res = Interval([min(L),max(L)]);
                    end

                else
                    res = applyForAll(@times,a,b);
                end
            end
        end
        
        %EQ override
        function res = eq(a,b)
            n = length(a); m = length(b);
            if(n == 1 && m == 1)
                if(isnumeric(b))
                    res = a==Interval(b);
                elseif(isnumeric(a))
                    res = b+a;
                else
                    res = a.lb==b.lb && a.ub==b.ub;
                end
            else
                res = applyForAll(@eq,a,b,false);
            end
        end
        
        % DIV override
        function res = mldivide(a,b), res = b./a; end
        function res = ldivide(a,b), res = b./a; end
        function res = mrdivide(a,b), res = a./b; end
        function res = rdivide(a,b) % a./b
            n = length(a); m = length(b);
            if(n == 1 && m == 1)
                if(isnumeric(b))
                    res = a./Interval(b);
                elseif(isnumeric(a))
                    res = b.\Interval(a);
                else
                    if(b == 0)
                        warning('Divisor is the numeral 0')
                        res = Interval(nan);
                    elseif(~b.contains(0))
                        res = a.*Interval([1/b.ub,1/b.lb]);
                    else
                        warning('Divisor Interval contains 0');
                        if(b.lb < 0 && b.ub > 0)
                            res = Interval([-Inf,Inf]);
                        elseif(b.lb < 0)
                            res = a.*Interval([-Inf,1/b.lb]);
                        else
                            res = a.*Interval([1/b.ub,+Inf]);
                        end
                    end
                end

            else
                res = applyForAll(@rdivide,a,b);
            end
        end
        
        %% Other Interval functions
       
        function res = sqr(a)
           res = Interval.empty(length(a),0);
           for i = 1:length(a)
               L = [a(i).lb^2,a(i).ub^2];
               if a(i).contains(0)
                    res(i) = Interval([0,max(L)]);
               else
                    res(i) = Interval([min(L),max(L)]);
               end
           end 
        end
        
        function res = sqrt(a)
            res = Interval.empty(length(a),0);
            for i = 1:length(a)
                domain = a(i)&Interval([0,+Inf]);
                res(i) = Interval(sqrt(domain.lb),sqrt(domain.ub));
            end
        end
        
        function res = width(a)
            res = zeros(1,length(a));
            for i = 1:length(a)
                res(i) = a(i).ub - a(i).lb;
            end
        end
        
        function res = mid(a)
            res = zeros(1,length(a));
            for i = 1:length(a)
                res(i) = a(i).lb + a(i).width()/2;
            end
        end
        
        function res = exp(a)
            res = Interval.empty(length(a),0);
            for i = 1:length(a)
                res(i) = Interval([exp(a(i).lb),exp(a(i).ub)]);
            end
        end
%   
        function res = sin(a)
            res = Interval.empty(length(a),0);
            for i = 1:length(a)
                res(i) = cosInterval(a(i)-pi/2);
            end
        end
    
        function res = cos(a)
            res = Interval.empty(length(a),0);
            for i = 1:length(a)
                res(i) = cosInterval(a(i));
            end
        end

% 	def log(x):
% 		if x.ub<=0:
% 			Interval(1,0)
% 		elif 0 in x:
% 			Interval(-inf,math.log(x.ub))
% 		else:
% 			Interval(math.log(x.lb),math.log(x.ub))
% 
% 	def subset(x,y):
% 		if x.is_empty():
% 			return True
% 		else:
% 			return (x.lb in y) and (x.ub in y)
% 
% 	def disjoint(x,y):
% 		return (x&y).is_empty()
% 
        function res = left(a)
            res = Interval.empty(length(a),0);
            for i = 1:length(a)
                res(i) = Interval([a(i).lb,0.5*(a(i).ub + a(i).lb)]);
            end
        end

        function res = right(a)
            res = Interval.empty(length(a),0);
            for i = 1:length(a)
                res(i) = Interval([0.5*(a(i).ub + a(i).lb),a(i).ub]);
            end
        end
        
        function res = getBounds(a)
            res = [low(a);high(a)];
        end
        
        function res = low(a)
            res = zeros(1,length(a));
            for i = 1:length(a)
                res(i) = a(i).lb;
            end
        end
        
        function res = high(a)
            res = zeros(1,length(a));
            for i = 1:length(a)
                res(i) = a(i).ub;
            end
        end
        
        function res = vol(a)
            res = 1;
            for i=1:length(a)
                res = res*a(i).width;
            end
        end
        
        function plot(obj,color,LineWidth)
            if length(obj)~= 2
                error('IntervalVector plot Only implemented for 2D boxes')
            else
                if nargin == 2
                    LineWidth = 1;
                end
                x0y0 = obj.low; x0 = x0y0(1); y0 = x0y0(2); 
                x1y1 = obj.high; x1 = x1y1(1); y1 = x1y1(2); 
                plotX = [x0;x1;x1;x0;x0];
                plotY = [y0;y0;y1;y1;y0];
                plot(plotX,plotY,color,'LineWidth',LineWidth);
            end
        end
	end
end