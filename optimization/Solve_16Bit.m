% This script uses the cvx toolbox in order to solve the optimal noising
% problem:
% minimize L(X->Y) over p(y|x)
% subject to"
%   p(y|x) = 0 for y<x
%   p(y|x) >= 0 for all x,y
%   E[Y-X] <= p_overhead_max
%clear all;
data = importdata('../rawData/FixedMod_100Sample_self.mat');
%data = importdata('../rawData/FixedMod_20Sample_gmp_powm.mat');
uxMap = data.Timing(1, :);
xVals = unique(uxMap);
xProbs = zeros(1,length(xVals));
for(i = 1:length(xVals))
    xProbs(i) = sum(uxMap == xVals(i))/length(uxMap);
end

% figure(1);
% constraintVals = 0:300:1500;
% [minLeakVals, statuses, pyx] = optNoise_v2(1, xVals, xProbs, constraintVals, 10000);

figure(2);
%constraintVals = log2(1:length(xVals)/40:length(xVals));
constraintVals = log2(2.5)%log2(1:length(xVals));
[minPerfVals, statuses, pyx, times] = optNoise_v2(2, xVals, xProbs, constraintVals, 10000);