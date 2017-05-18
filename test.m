x = [];
for i = 1:i_max
    for j = 1:j_max
        x = [x; i,j,j+(i-1)*j_max];
    end
end

t = find((diff(x(:,3)) == 1) == false);

k = x(:,3);


j = mod(k,j_max);
j(j == 0) = j_max;
i = 1 + (k-j)/j_max;