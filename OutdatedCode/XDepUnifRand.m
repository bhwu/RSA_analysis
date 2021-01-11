% Simple numerical comparison between x-dependent uniform random scheme vs
% deterministic cut-off at the same performance level for a 20-bit key

n = 40;
L1 = log2(sum(1./[1:n+1]));
perf1 = n/4;

C = log2(n);
for(x=0:n)
    C = C-nchoosek(n,x)*(0.5)^n*log2(n-x+1)
end