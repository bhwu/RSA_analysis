function [perf] = compute_perf(px, pxy, cost)
    % Computes expected performance overhead, given p(x), p(y|x), and c(x,y)
    perf = 0;
    for(i = 1:length(px))
        sub_j = find(~isinf(cost(i,:)));
        perf = perf + px(i)*sum(pxy(i,sub_j).*cost(i, sub_j));
    end
end