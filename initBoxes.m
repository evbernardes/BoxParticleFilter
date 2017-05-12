dx = diff(xb0); bound = max(max(abs(dx)));
x_min = min(xb0) - accuracy_x;
x_max = max(xb0) + 2*accuracy_x;
boxes = ceil((x_max - x_min)./accuracy_x); Nboxes = prod(boxes);

% initialising boxes
i_max = boxes(1); j_max = boxes(2);
pos_x1 = x_min(1) + (0:i_max)*accuracy_x(1);
pos_x2 = x_min(2) + (0:j_max)*accuracy_x(2);

Boxes = cell(boxes);
for i=1:i_max
    for j=1:j_max
       Boxes{i,j} = Interval(pos_x1(i:i+1),pos_x2(j:j+1));
    end
end
Boxes = [];
for i=1:i_max
    for j=1:j_max
       Boxes = [Boxes; Interval(pos_x1(i:i+1),pos_x2(j:j+1))];
    end
end