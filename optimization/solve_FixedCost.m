function [ml_pml, ml_pmi, mi_pml, mi_pmi, pml, pmi] = solve_FixedCost(uxmap, costBound, scaling)
% Given P(X) and a fixed costBound, solves two optimizations:
% 1) ML-optimal scheme p_ml
% 2) MI-optimal scheme p_mi
% Then compute the maximal leakages of both and the mutual information of
% both

xVals = unique(uxmap);
N = length(xVals);
xProbs = zeros(1,length(xVals));
for(i = 1:length(xVals))
    xProbs(i) = sum(uxmap == xVals(i))/length(uxmap);
end
Hx = sum(entr(xProbs));

cvx_begin
    cvx_solver gurobi
    variable pxy(N, N) nonnegative upper_triangular
    minimize(sum(max(pxy/scaling)))
    subject to
        sum(sum(pxy/scaling.*repmat(xProbs',1,N),1).*xVals) - sum(xProbs.*xVals) <= costBound/scaling
        sum(pxy,2)/scaling == 1
cvx_end
pml = pxy/scaling;

% Minimize mutual information under the additional constraint that
% p(y)=p(x) (note that under this constraint, p(x|y) = p(y|x))
cvx_begin
    cvx_solver sedumi
    variable pxy(N,N) nonnegative upper_triangular %Note:p(x|y)
    yProbs = xProbs; %enforce p(y)=p(x)
    %unroll upper triangular version of p(y)
    A = repmat(yProbs,N,1);
    At = A.';
    m = tril(true(size(At)));
    v = At(m).';
    maximize( sum(v.*entr(pxy/scaling)) )
    subject to
        sum(sum(pxy/scaling.*repmat(xProbs',1,N),1).*xVals) - sum(xProbs.*xVals) <= costBound/scaling
        sum(pxy,2)/scaling == 1
        %sum(pxy(:,1))==0
        %sum(pxy(:,3))==0
cvx_end
pmi=pxy/scaling;
%pmi=0;

ml_pml=log2(sum(max(pml)));
%ml_pmi=0;
ml_pmi=log2(sum(max(pmi)));
yProbs=xProbs*pml;
jointProbs=repmat(xProbs',1,N).*pml;
mi_pml=Hx+sum(entr(yProbs))-sum(sum(entr(jointProbs)));
%mi_pmi=0;
mi_pmi=Hx-sum(sum(repmat(xProbs,N,1).*entr(pmi)));