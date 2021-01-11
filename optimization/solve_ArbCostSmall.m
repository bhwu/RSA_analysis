function [Cs, Ls] = solve_ArbCostSmall()
cxy = [100 3 8 5 7; 8 6 4 5 2; 7 3 1 3 5; 6 4 9 8 2; 3 7 1 4 6];
Ls = 1.4:0.01:1.6;
Cs = zeros(length(Ls));
for(i = 1:length(Ls))
    cvx_begin
        cvx_solver sedumi
        variable pxy(5, 5) nonnegative
        minimize( sum(sum(cxy.*pxy)) )
        subject to
            sum(max(pxy)) <= Ls(i)
            sum(pxy,2) == 1
    cvx_end
    Cs(i) = cvx_optval;
end