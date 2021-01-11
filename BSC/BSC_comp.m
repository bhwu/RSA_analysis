p = [0:0.01:0.5];
px = [0.25, .75];
p_ex = p(2:end);
ML = log2(2-2*p);
CC = [1, 1+p_ex.*log2(p_ex)+(1-p_ex).*log2(1-p_ex)];
clear p_ex;

figure(1);
plot(p,ML,'b-');
hold on;
plot(p,CC,'r:');
hold off;
axis([0 0.5 0 1]);
% legend('ML','MI and CC');
% xlabel('p')
% ylabel('Leakage (bits)')
% title('ML, MI, and CC on BSC with uniform random X')