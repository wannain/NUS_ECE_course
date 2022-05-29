
function y = stepfunc(x,t)% this function is for strategy (b) of the data processing,t is the threshold
[rows,columns] = size(x);
y = zeros(rows,columns);
for i = 1:rows;
    for j = 1:columns;
        if x(i,j) > t;
            x(i,j) = 1;
        end
    end
end
y = x;
