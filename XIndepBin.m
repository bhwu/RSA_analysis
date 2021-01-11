function [] = XIndepBin(dist)
% Produces a trade-off curve between performance vs security (channel
% capactiy, guessing gain, and maximal leakage) for a repeated squaring attack on RSA
% Takes a single input n (the key length); produces a curve with 20 data
% points from m = 0 to n (roughly evenly spaced)

% 16-bit key analysis, with histogram structure h
%dist = h.Values/length(h.Data);
%n = floor((max(h.Data)-min(h.Data)+1)/2)*2;
%m = floor(0:n/4/30:n/4)*2;
n = 256;
m = floor(0:n/4/30:n/4)*2;
len = length(m);
perf = zeros(1,len);
MI = zeros(1,len);
MLeak = zeros(1,len);
CC = zeros(1,len); % maximum likelihood here

for(i = 1:len)
    disp(['m = ', num2str(m(i))])
    Z = binopdf(0:m(i),m(i),1/2);
    MI(i) = computeMI(dist, Z);
    [perf(i),~,CC(i),MLeak(i)] = computeNM(n,m(i));
    Y = conv(dist, Z);
end

figure(1);
plot(perf, MI, 'r-');
hold on;
plot(perf, CC, 'k-');
plot(perf, MLeak, 'b-');
%axis([0 n/4*scaling 0 max(ML)*1.5]);
xlabel('Performance overhead: E[Y-X] in excess cycles');
ylabel('Security measure (bits)');
title('Weight of Key Example - Metric Comparison')
legend('Mutual information','Channel Capacity', 'Maximal Leakage', 'Location', 'northeast');
%set(gca, 'yscale','log');
hold off;

end

function[perf,MI,CC,ML] = computeNM(n,m)
% Simply a helper function to call all of the below compute functions for a
% given n,m pair. This will make the main code cleaner
if(mod(n,2) == 1 || mod(m,2) == 1)
    disp('n and m must both be even for ML computation');
    perf=0;
    MI=0;
    CC=0;
    ML=0;
    return;
end
perf = expDiff(m);
[MI,CC] = computeCC(n,m);
ML = computeML(n,m);
end

% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% Maximal Leakage functions>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function [ML] = computeML(n,m)
    ML = log2(2*cdf('Binomial', m/2-1, m, 1/2) + (n+1)*pdf('Binomial', m/2,m,1/2));
end
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% Channel Capacity and Mutual Information functions >>>>>>>>>>>>>>>>>>>
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function [MI, CC] = computeCC(n,m)
    MI = shannonBin(n+m,1/2) - shannonBin(m,1/2);
    pyx = zeros(n,n+m);
    if(m>0)
        for(i = 1:n)
            pyx(i,i:i+m-1) = binopdf(1:m,m,1/2);
        end
    else
        pyx(:,1:n) = diag(ones(1,n));
    end
    CC = csiszar_tusnady(pyx, 500);
end

function [MI] = computeMI(z1, z2)
% Given the discrete-time pdfs z1 and z2, compute the mutual information of
% z1;z2
% Ideally, choose z2 to be the smaller distribution
    Z = conv(z1,z2);
    MI = 0;
    for(i = 1:length(Z))
        if(Z(i)>0)
            MI = MI - Z(i)*log2(Z(i));
        end
    end
    for(i = 1:length(z2))
        if(z2(i)>0)
            MI = MI + z2(i)*log2(z2(i));
        end
    end
end

function [H] = shannonBin(n,p)
    if(n<=1024)
        N = [0:n];
        probs = pdf('Binomial', N, n, p);
        H = -sum(probs.*log2(probs));
    else
        % slight overestimate, but negligible for such large n
        H = 0.5*log2(2*pi*exp(1)*n*p*(1-p)); 
    end
end


% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% Performance Metric(s)>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function[perf] = expDiff(m)
% computes E[Y-X]
    perf = m/2;
end
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>