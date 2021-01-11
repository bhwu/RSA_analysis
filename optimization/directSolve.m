function [ mn, leak, D, D_rel ] = directSolve( rawData )
% By iterating over equal-gradient zones of the optimal leakage-distortion
% trade-off curve, solves for the k-values (turning points, when the
% gradient changes, where the weight should be shifted next).
% Accepts one argument: the rawData, which contains all available (NUMERICAL)
% measurement data. This data is used to generate an empirical
% distribution, which will be used for all calculations

% Extract empirical distribution
xVals = unique(rawData); % Holds unique values of the raw data in numerical order
N = length(xVals); % Number of unique symbols
q = zeros(1, N); % Holds empirical distribution, assoc with xVals
for(i = 1:N)
    q(i) = sum(rawData == xVals(i))/length(rawData);
end

% Pre-processing
Q = zeros(1, N); % Cumulative empirical distribution function
for(i = 1:N)
    Q(i) = sum(q(1:i));
end
Delta = zeros(N,N); % Delta(i,j) = xVals(j)-xVals(i)
for(i = 1:N)
    for(j = i:N)
        Delta(i,j) = xVals(j)-xVals(i);
    end
end
C = repmat(q',1,N).*Delta; % Cost matrix

% Initial values (start at zero leakage)
leak = 1:N; % maximal leakage = log2(leak)
pxy = [zeros(N,N-1),ones(N,1)]; % transition matrix p(y|x)
D = [sum(C(:,N)),zeros(1,N-1)]; % delay
mn = zeros(2,N-1);
idx = N*ones(N,1); % the column where '1' is located in each row

% Main loop
for(i = 1:N-1)
    D_decr = 0;
    for(m = 1:N-1) % Search for maximizing m,n
        for(n = m+1:N)
            temp = sum(Delta(m,n)*q(1:m)'.*(idx(1:m)==n));
            if(temp>D_decr)
                D_decr = temp;
                mn(1,i) = m;
                mn(2,i) = n;
            end
        end
    end
    for(k = 1:mn(1,i)) % update idx vector
        if(idx(k) == mn(2,i))
            idx(k) = mn(1,i);
        end
    end
    D(i+1) = D(i)-D_decr; % update Delay value
end

% Compute baseline expected computation time
base = sum(q.*xVals);
D_rel = D./base * 100;