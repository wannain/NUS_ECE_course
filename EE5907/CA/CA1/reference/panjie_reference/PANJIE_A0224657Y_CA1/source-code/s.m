%This function is for Q3
 
function y = s(u)
y = zeros(length(u));
for i = 1:length(u);
    y(i,i) = u(i)*(1-u(i));
end
