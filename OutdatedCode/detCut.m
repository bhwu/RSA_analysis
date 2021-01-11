% Computes tradeoff between performance and leakage for deterministic
% cut-off protection scheme for key length n.
% Set 0<=c<=n. Then if x<=c -> y =c
% Else y=x
clear all;
n = 40;
c = 0:n;
L = log2(n-c+1);

perf = zeros(1, length(c));
for(c_val = 0:n)
    for(i = 0:n)
        if(i<=c_val)
            perf(c_val+1) = perf(c_val+1) + c_val*nchoosek(n,i)*(0.5)^n;
        else
            perf(c_val+1) = perf(c_val+1) + i * nchoosek(n,i)*(0.5)^n;
        end
    end
end
perf = perf-n/2;

figure(1);
plot(perf,L);
xlabel('performance: E[Y-X]');
ylabel('leakage L(X-Y) (bits)');
title('deterministic cutoff scheme tradeoff for 20-bit RSA key');