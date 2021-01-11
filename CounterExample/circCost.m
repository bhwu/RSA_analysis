% Produces an optimal tradeoff for a "flat" X (equal probability, and linear symbols)
% and a circularly-shifted cost function.
clear all;
clc;
X_alph = 1:4;
Y_alph = X_alph;
N = length(X_alph);
leaks = 1:0.1:N;
costs = zeros(1,length(leaks));
pxy_out = zeros(N,N,N);

cf = zeros(N,N);
vec = [0:N-1];
for(x = 1:N)
    cf(x,:) = circshift(vec,x-1);
end

for(i = 1:length(leaks))
    L = leaks(i);
    cvx_begin
        cvx_solver sedumi
        variable pxy(N,N) nonnegative
        minimize (sum(sum(cf.*pxy)))
        subject to
            sum(max(pxy))<=L;
            sum(pxy,2)==1;
    cvx_end
    pxy_out(:,:,i) = pxy;
    costs(i) = cvx_optval;
end