% Requires that the variable x is defined in the workspace, where x is the
% timing profile of a single ciphertext for every possible key

if(exist('x'))
    % Prepare x for later use
    h = histogram(x, 'BinEdges', 0:(max(x)+1)); % histogram of data
    xdist = h.Values./length(x); % probability distribution of x variable
    possX = find(xdist>0); % List of possible x-values
    impossX = find(xdist == 0); % List of impossible x-values
    
    % variables
    pyx = sdpvar(max(x)+1, 2*max(x)+2); % indexed (x(0:max(x)), y(0:max(y)))
    xrange = 1:(max(x)+1);
    yrange = 1:(2*max(x)+2);
    
    % constraints
    C = [pyx>=0]; % nonnegative probabilities
    for(i = 1:length(possX))
        C = [C, sum(pyx(possX(i),:)) == 1]; % Require possible x rows to sum to 1
        C = [C, sum(pyx(possX(i),1:possX(i)-1)) == 0]; % Require y>=x
    end
    C = [C, sum(sum(pyx(impossX,:))) == 0]; % Require impossible x rows to be all 0
    perfOver = 0;
    for(fix_x = 1:size(pyx,1)) % Compute expected performance overhead
        perfOver = perfOver + sum(pyx(fix_x,:).*(yrange-fix_x).*(yrange-fix_x >= 0));
    end
    C = [C, perfOver<=max(yrange)]; % Performance constraint
    
    % Objective function
    mleak = sum(max(pyx));
    
    % Solve
    sol = optimize(C,mleak , sdpsettings('solver','linprog','verbose','1'));
    noiseDist = value(pyx);
end

