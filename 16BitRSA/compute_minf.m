function [minf] = compute_minf(px,pxy)
    N = length(px);
    M = size(pxy,2);
    p_joint = pxy.*repmat(px',1,M);
    py = sum(p_joint,1);
    summand = p_joint.*log2(p_joint./(repmat(px',1,M).*repmat(py,N,1)));
    summand(find(isnan(summand))) = 0;
    minf = sum(sum(summand));
end
