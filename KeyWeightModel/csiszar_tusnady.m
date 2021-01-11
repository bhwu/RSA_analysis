function [ C ] = csiszar_tusnady( pxy)
% Using a given Y|X distribution, computes channel capacity using the
% Csiszar-Tusnady alternating maximization algorithm. This function accepts
% pyx, the transition matrix P(Y|X), an nxm matrix

n = size(pxy,1);
m = size(pxy,2);

% Start by guessing r(x) to be uniform
rx = ones(1,n) * 1/(n);
C = -100;
delC = 100;
while(delC >= 1e-4)
    qxy = repmat(rx',1,m).*pxy;
    qxy = qxy./(repmat(sum(qxy),n,1));
    CPrev = C;
    C = repmat(rx',1,m).*pxy.*log2(qxy./repmat(rx',1,m));
    C = nansum(nansum(C));
    delC = abs(C-CPrev);
    
    rx = prod(qxy.^pxy,2,'omitnan');
    rx = rx'./nansum(rx);
end