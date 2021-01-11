function [] = analyze_MI_Opt(uxMap, leaks, scaling)
% This script performs two tasks
% First, for the given leakage bounds "leaks", it uses cvx to compute the
% mutual information optimal protection schemes.
% Second, using these protection schemes, it computes the channel capacity
% and maximal leakage, and plots the respective trade-off curves in
% comparison to the mutual information

% Obtain X alphabet
xVals = unique(uxMap);
N = length(xVals);
% Obtain distribution of X
px = zeros(1,length(xVals));
for(i = 1:length(xVals))
    px(i) = sum(uxMap == xVals(i))/length(uxMap);
end
% Upper triangular unroll px for later
px_UR = zeros(1,sum(1:N));
j = 1;
for(i = 1:N)
    px_UR(j:j+i-1) = px(1:i);
    j = j+i;
end
% Generate cost matrix
cxy = zeros(N,N);
for(x = 1:N)
    for(y = 1:N)
        if(y>x)
            cxy(x,y) = xVals(y)-xVals(x);
        end
        if(y<x)
            cxy(x,y) = inf;
        end
    end
end

% Part 1: loop over leaks and perform an optimization for each
for(i = 1:length(leaks))
    cvx_begin
        cvx_solver sedumi
        %cvx_solver_settings('maxiter', 300)
        variable pxy(N,N) nonnegative upper_triangular
        minimize(sum(sum(repmat(px',1,N) .* pxy/scaling .* cxy)))
        subject to
            % MI
            sum(entr(px))/log(2) - sum(sum(px_UR.*entr(pxy)))/log(2)<= leaks(i)
            % ML
            %sum(max(pxy))<=2.^leaks(i)
            % LDP
            
            sum(pxy,2)/scaling == 1
    cvx_end
    pxy
end