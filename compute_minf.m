function [minf] = compute_minf(xDist, Z)
% Computes mutual information I(X;Y), where Y = X+Z
    Y = conv(xDist, Z);
    minf = 0;
    % First compute Shannon entropy of Y
    for(i = 1:length(Y))
        if(Y(i)>0)
            minf = minf - Y(i)*log2(Y(i));
        end
    end
    % Then subtract Shannon entropy of Z
    for(i = 1:length(Z))
        if(Z(i)>0)
            minf = minf + Z(i)*log2(Z(i));
        end
    end
end
