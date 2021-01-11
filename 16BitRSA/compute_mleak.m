function [mleak] = compute_mleak(pxy)
    mleak = log2(sum(max(pxy)));
end