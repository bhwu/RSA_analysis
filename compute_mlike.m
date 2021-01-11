function [mlike] = compute_mlike(uxMap, xDist, Z)
% Computes maximum likelihood gain in guessing U, given the observed Y
% where Y = X+Z
    Y = conv(xDist, Z);
    mlike = 0;
    % For each non-zero probability Y
    for(i = 1:length(Y))
        if(Y(i)>0)
            max_u = 0;
            % For each possible U value, ...
            for(j = 1:length(uxMap))
                testVal = i - uxMap(j);
                if(testVal>0 && testVal<=length(Z))
                    if(Z(testVal)>max_u)
                        max_u = Z(i-uxMap(j));
                    end
                end
            end
            mlike = mlike + 1/length(uxMap)*max_u;
        end
    end
    mlike = log2(mlike * length(uxMap));
end
