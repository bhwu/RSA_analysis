function [perf] = compute_perf(Z)
    % Computes expected performance overhead, given noise distribution Z
    perf = sum([0:length(Z)-1].*Z);
end