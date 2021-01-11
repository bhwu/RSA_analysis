function [L] = computeML(N,M)
%COMPUTEML Computes maximal leakage of a binomial random variable X,
% noised with binomial random variable Z, both with probability parameters of
% 1/2. I.E. Computes \mathscr{L}(X->Y) where Y=X+Z
L = log2(2*sum(binopdf(0:M/2-1,M,1/2)) + (N+1)*binopdf(M/2,M,1/2));