function [ pyx ] = fromDiagonal( diagonals)
%This function accepts a vector of diagonal values, and generates the
%corresponding off-diagonal values, returning the entire pyx matrix

N = length(diagonals);
pyx = diag(diagonals);
for(x = 1:N-1)
    y = x;
    rowSum = diagonals(x);
    for(y = x:N)
        pyx(x,y) = 1-rowSum;
        if(diagonals(y)<=1-rowSum)
            pyx(x,y) = diagonals(y);
        end
        rowSum = sum(pyx(x,:));
    end
end