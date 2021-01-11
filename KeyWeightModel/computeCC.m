function [C] = computeCC(N,M)
% COMPUTECC Computes channel capacity of a binomial random variable X,
% noised with binomial random variable Z, both with probability parameters of
% 1/2. I.E. Computes max_p(x){I(X;Y)} where Y=X+Z
pxy = zeros(N+1,N+M+1);
Z = binopdf(0:M,M,1/2);
c = [Z(1), zeros(1,N+M-1)];
r = [Z, zeros(1, N-1)];
pxy=toeplitz(c,r);
pxy = pxy(1:N,:);

C = csiszar_tusnady(pxy);
