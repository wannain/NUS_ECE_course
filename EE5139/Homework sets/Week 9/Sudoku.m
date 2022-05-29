% Stoping conditions
tolerance = 1e-3;
timeout = 10;
% Precondition for the Sudoku: The (i,j)-th entry is considered to be
% missing if pre(i,j)==0, otherwise, it is considered as given as pre(i,j).
pre = [5, 3, 0, 0, 7, 0, 0, 0, 0;
       6, 0, 0, 1, 9, 5, 0, 0, 0;
       0, 9, 8, 0, 0, 0, 0, 6, 0;
       8, 0 ,0, 0, 6, 0, 0, 0, 3;
       4, 0, 0, 8, 0, 3, 0, 0, 1;
       7, 0, 0, 0, 2, 0, 0 ,0, 6;
       0, 6, 0, 0, 0, 0, 2, 8, 0;
       0, 0, 0, 4, 1, 9, 0, 0, 5;
       0, 0, 0, 0, 8, 0, 0, 7, 9];
% Preallocation for the messages: m stands for the messages from the
% variable nodes to the factor nodes, and n stands for the messages from
% the factors to the variables nodes
m = cell(9,9,3); % (i, j, one of {row, column, block factor})
n_row = cell(9,9); n_col = cell(9,9); n_block = cell(3,3,3,3);
m_new = cell(9,9,3);
% Homework (0/4): You may add some additonal code outside the loop that you
% need here.
% ... ...
% Initialization 
for i = 1:9
    for j = 1:9
        if pre(i,j)>0
            temp = zeros(1,9);
            temp(pre(i,j)) = 1;
            for a = 1:3
                m{i,j, a} = temp;
            end
        else
            for a = 1:3
                m{i,j, a} = ones(1,9)/9;
            end
        end
    end
end
m_new = m;
clear('i','j','temp','a');
diff = inf;
t = 0;
while (t<timeout && diff>tolerance)
t = t + 1;
% Update the messages from the row regulating factors to their variables
for a = 1:9
    for k = 1:9
        % Homework (1/4): Write a piece of code to compute the message from
        % the factor regulating the a-th row to the variable (a,k). Hint:
        % The messages will be assigned to n_row{a, k}.
    end
end
clear('a','k');
% Update the messages from the column regulating factors to their variables
for b = 1:9
    for k = 1:9
        % Homework (2/4): Write a piece of code to compute the message from
        % the factor regulating the b-th column to the variable (k,b).
        % Hint: The messages will be assigned to n_col{b, k}.
    end
end
clear('b','k');
% Update the messages from the block regulating factors to their variables
for c1 = 1:3
for c2 = 1:3
    for k1 = 1:3
    for k2 = 1:3
        % Homework (3/4): Write a piece of code to compute the message from
        % the factor regulating the (c1,c2)-th block to the variable
        % (3*c1+k1-3, 3*c2+k2-3). Hint: The messages will be assigned to
        % n_block{c1,c2,k1,k2}.
    end
    end
end
end
clear('c1','c2','k1','k2');
% Update the messages from the varaibles to the factors. Note that the
% messages from the 'given" variable are invariant.
for i = 1:9
for j = 1:9
	if pre(i,j)==0
        % Homework (4/4): Write a piece of code to compute the message from
        % the (i,j)-th variable to its row-regulating, column-regulating
        % and block regulating factors. Hint 1: The messages will be
        % assigned to m_new{i,j, 1}, m_new{i,j, 2} and m_new{i,j, 3},
        % repectively. Hint 2: Pay attention to the hints of step 1-3, and
        % write down the messages from the THREE factor nodes to this
        % variable.
	end
end
end
clear('i','j')
% Compute the difference between m_new and m
diff = 0;
for k = 1:numel(m)
    d = sum(abs(m{k} - m_new{k}))/2;
    if d > diff
        diff = d;
    end
end
clear('k','d');
m = m_new;
disp(diff);
end

% Decision
output = zeros(9);
for i=1:9
    for j = 1:9
        if pre(i,j)>0
            output(i,j) = pre(i,j);
        else
            c1 = floor((i-1)/3)+1; k1 = i - 3*(c1-1);
            c2 = floor((j-1)/3)+1; k2 = j - 3*(c2-1);
            p = n_row{i,j}.*n_col{j,i}.*n_block{c1,c2,k1,k2};
            p = p/sum(p);
            [~, output(i,j)] = max(p);
        end
    end
end
clear('i','j','c1','c2','k1','k2');
disp(output);