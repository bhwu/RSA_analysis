function [MI] = computeMI(N,M)
% computeMI: Computes mutual information of a binomial random variable X,
% noised with binomial random variable Z, both with probability parameters of
% 1/2. I.E. Computes I(X;Y) where Y=X+Z
% Inputs: N - size of key in bits
%         M - size of noise in bits
% Output: MI - mutual information
% Example Usage: [MI] = computeMI(1024, 512)

MI = computeEntropy(N+M) - computeEntropy(M);