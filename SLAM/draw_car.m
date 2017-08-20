function draw_car(x)
   M=[-1  4 5  5 4 -1 -1   -1 0  0  -1  1  0 0 -1 1 0 0 3 3 3; % body  
      -2 -2 -1 1 2 2  -2   -2 -2 -3 -3 -3 -3 3  3 3 3 2 2 3 -3;
      ones(1,21)] ;
   Rav=[-1 1;0 0;1 1];  % front wheel
   R=[cos(x(3)),-sin(x(3)),x(1);sin(x(3)),cos(x(3)),x(2);0 0 1];
   M=R*M;    
   Ravd=R*[cos(x(5)),-sin(x(5)) 3;sin(x(5)),cos(x(5)) 3 ;0 0 1]*Rav;
   Ravg=R*[cos(x(5)),-sin(x(5)) 3;sin(x(5)),cos(x(5)) -3;0 0 1]*Rav;
   plot(M(1,:),M(2,:),'red','LineWidth',2);            
   plot(Ravd(1,:),Ravd(2,:),'magenta','LineWidth',2);  
   plot(Ravg(1,:),Ravg(2,:),'magenta','LineWidth',2);  
end
   