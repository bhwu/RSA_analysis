function [mleak] = compute_mleak(xDist, Z)
% Computes maximal leakage L(X->Y), where Y = X+Z
    Y = conv(xDist, Z);
    mleak = 0;
    % For each nonzero probability Y value,...
    for(i = 1:length(Y))
        if(Y(i)>0)
            max_x = 0;
            % For each nonzero probability X value that's possible with the
            % noise distribution Z, ...
            for(j = 1:min(length(xDist), i))
                if(xDist(j)>0 && i-j+1 <= length(Z))
                    % Keep track of the largest cond. probability assoc. with x
                    if(Z(i-j+1)>max_x)
                        max_x = Z(i-j+1);
                    end
                end
            end
            % Keep a running sum of the maximums for each Y
            mleak = mleak + max_x;
        end
    end
    % Log the result
    mleak = log2(mleak);
end