function [leak, cost, pxy] = greedy(rawData,numReps,resolution)
% Performs the greedy algorithm on input data (1xN array) for timing
% channel cost matrix (upper triangular constraint).
% data input is the raw simulation data, numReps is the number of
% repetitions for each ciphertext-key pair, resolution is given in numbers
% of cycles
data = min(reshape(rawData,[numReps, length(rawData)/numReps])); % Minimum timing of each pair

h = histogram(data, 'BinWidth', resolution); % histogram data
alph = h.BinEdges(1:end-1); % lower value of each bin
N = length(alph);
p = h.Values/length(data); % natural distribution of x
c = zeros(N,N); % cost function
for(x = 1:N)
    for(y = 1:N)
        if(x<=y)
            c(x,y) = alph(y)-alph(x);
        else
            c(x,y) = Inf;
        end
    end
end

% transition matrices
pxy = zeros(N,N,N); 
pxy(:,:,1) = [zeros(N,N-1),ones(N,1)]; % first transition matrix

% leakage values
leak = 1:N;

% cost values
cost = zeros(N,1);
cost(1) = computeCost(p,c,pxy(:,:,1));

for(L = 2:N)
    oldpxy = pxy(:,:,L-1); % extract previous protection scheme
    sources = find(any(oldpxy)); % identify all candidate sources (index of columns with any ones)
    targets = find(~any(oldpxy)); % identify all candidate targets (index of columns with no ones)
    delta = 0; src=0; tar=0; % initialize comparison variables
    for(s = 1:length(sources)) % iterate over all source candidates
        for(t = 1:length(targets)) % and over all target candidates
            move_x = find(oldpxy(:,sources(s)) == 1);
            move_x = move_x(1:find(move_x>targets(t),1,'first')-1);
            % compute the set of x's that should be moved to optimize delta cost
            delta_temp = sum(p(move_x)'.*(c(move_x,sources(s))-c(move_x,targets(t)))); % compute delta cost of this source-target pair
            if(delta_temp>delta) % check if it's better than current best
                delta = delta_temp;
                src = sources(s);
                tar = targets(t);
            end
        end
    end
    if(src>0 && tar >0)
        newpxy = oldpxy;
        move_x = find(oldpxy(:,src) == 1);
        move_x = move_x(1:find(move_x>tar,1,'first')-1);
        newpxy(move_x,src)=0;
        newpxy(move_x,tar)=1;
        pxy(:,:,L) = newpxy;
        cost(L) = computeCost(p,c,newpxy);
    else
        pxy(:,:,L)=pxy(:,:,L-1);
        cost(L)=cost(L-1);
    end
end

end


function [cost] = computeCost(p,c,pxy)
Px = repmat(p',1,length(p));
cost = Px.*c.*pxy;
cost(isnan(cost))=0;
cost = sum(sum(cost));
end