function [leak, cost, cf, pxy_out] = trueOpt(rawData,numReps,resolution, lpts)
%Uses CVX to compute the true optimal cost for a set of leakage points 
% (note that while the code can handle many points, it may not run very fast
% the intended usage is to obtain a relatively small number of points)
% For documentation on inputs, see greedy.m
% lpts is the set of leakage values to optimize for
data = min(reshape(rawData,[numReps, length(rawData)/numReps])); % Minimum timing of each pair

h = histogram(data, 'BinWidth', resolution); % histogram data
alph = h.BinEdges(1:end-1); % lower value of each bin
N = length(alph);
p = h.Values/length(data); % natural distribution of x
c = zeros(N,N); % cost function
% Upper Triangular cost
% for(x = 1:N)
%     for(y = 1:N)
%         c(x,y) = alph(y)-alph(x);
%     end
% end

% Circular Shift Cost
vec = 1:N
for(x = 1:N)
    c(x,:) = circshift(vec,x-1);
end
cf = c;

pxy_out = zeros(N,N,N);
for(i = 1:length(lpts))
    L = lpts(i);
    cvx_begin
        cvx_solver sedumi
        variable pxy(N,N) nonnegative upper_triangular
        minimize (sum(sum(repmat(p',1,N).*c.*pxy)))
        subject to
            sum(max(pxy))<=L
            sum(pxy,2)==1
    cvx_end
    pxy_out(:,:,i) = pxy;
    leak(i) = L;
    cost(i) = cvx_optval;
end



