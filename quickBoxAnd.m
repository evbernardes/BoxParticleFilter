function AnB = quickBoxAnd(A,B)
	x_lb = max([A(1).lb,B(1).lb]);
	y_lb = max([A(2).lb,B(2).lb]);
	x_ub = min([A(1).ub,B(1).ub]);
	y_ub = min([A(2).ub,B(2).ub]);
	AnB = Interval([x_lb,x_ub],[y_lb,y_ub]);
end