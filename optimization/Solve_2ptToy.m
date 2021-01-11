% This script uses the two-value toy x distribution in order to explore
% basic properties of the simplest possible timing variation. It does four
% things: 
% First, it solves the min-leakage optimization under a uniform x, and
% varying the performance constraint
% Second, it solves the min-leakage optimization under different x
% distributions and a constant performance overhead


clear all;
data = importdata('../madeUpData/twoValToyEx.mat');
xProbs = data.xProbs;
xVals = data.xVals;

% 1:
figure(1);
constraintVals = 0:4:20;
[objectiveVals, statuses] = optNoise_v2(1, xVals, xProbs, constraintVals, 100);
colorbar;
objectiveVals
statuses

% 2: 
p_lows = 0.1:0.1:0.9;
for(i = 2:length(p_lows)+1)
    figure(i);
    optNoise_v2(1, xVals, [p_lows(i-1), 1-p_lows(i-1)], constraintVals, 100);
end