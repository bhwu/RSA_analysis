function [data] = comparison()
% COMPARISON Plots 32 points on a 1024-bit key under the key weight
% model to show the gap between MI, CC, and ML
figure(1);
N = 1024;
%M = 0:32:1024
M=unique([0,floor(2.^(0:0.25:10)./2)*2]);
MI = zeros(1,length(M));
CC = zeros(1,length(M));
ML = zeros(1,length(M));
for(i = 1:length(M))
    disp(['M = ', num2str(M(i))]);
    MI(i) = computeMI(N,M(i));
    CC(i) = computeCC(N,M(i));
    ML(i) = computeML(N,M(i));
end
plot(ML,M/2,'-b','LineWidth',2);
hold on;
plot(CC,M/2, '--k','LineWidth',2);
plot(MI,M/2, ':r','LineWidth',2);
title('Square-and-multiply with binomial noise metric comparison')
ylabel('Total Cost (multiples of K ms)')
xlabel('Leakage (bits)')
legend('ML','CC','MI','Location','NorthEast')
axis([0 10 0 512]);
hold off;

data = zeros(4,length(M));
data(1,:) = M/2;
data(2,:) = MI;
data(3,:) = CC;
data(4,:) = ML;
csvwrite('compdata.csv',data);