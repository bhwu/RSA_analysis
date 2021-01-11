function [H] = computeEntropy(N)
% COMPUTEENTROPY computes the entropy of a binomial random variable with
% probability parameter 1/2 and size parameter N
% Input: N - size parameter
% Output: H - Entropy

X = binopdf(0:N,N,1/2);
H = -nansum(X.*log2(X));