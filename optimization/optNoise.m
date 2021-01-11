function [ objectiveVals, statuses, pyx ] = optNoise( mode, xVals, xProbs, constraintVals )
% This function uses cvx to solve the leakage/performance optimization
% problem. The expected inputs are as follows:

% mode: Describes the mode of optimization. If mode == 1, then optNoise
% minimizes leakage under a performance constraint. If mode == 2, then
% optNoise minimizes performance overhead under a leakage constraint

% xVals and xProbs are 1xN arrays that together describe the natural
% distribution of X. In other words, xProbs(i) == Pr(X == xVals(i)) for all
% i. All xProbs are expected to be >0, and xProbs must sum to 1.

% constraintVals is the range of constraint points to perform the optimization
% under. For example, if mode == 1, constraintVals should be a 1xN array
% containing performance values in cycles of overhead.

N = length(xVals);
nDataPts = length(constraintVals);
objectiveVals = zeros(1, nDataPts);
statuses = zeros(1, nDataPts);
subplotx = floor(sqrt(nDataPts));
subploty = ceil(nDataPts/subplotx);
if(mode == 1) % minimize leakage under performance constraint
    for(i = 1:nDataPts)
        cvx_begin
            cvx_solver sedumi
            cvx_solver_settings('maxiter', 300)
            variable pyx(N, N) nonnegative upper_triangular
            minimize( sum(max(pyx)) )
            subject to
                sum(sum(pyx.*repmat(xProbs',1,N),1).*xVals) - sum(xProbs.*xVals) <= constraintVals(i)
                sum(pyx,2) == 1
        cvx_end
        subplot(subplotx, subploty, i);
        imagesc(pyx);
        caxis([0 1]);
        title(['min-leak transition matrix for ', num2str(constraintVals(i)), ' cycles overhead']);
        if(strcmp(cvx_status, 'Solved') || strcmp(cvx_status, 'Inaccurate/Solved'))
            objectiveVals(i) = log2(cvx_optval);
            statuses(i) = 0.5;
            if(strcmp(cvx_status,'Solved'))
                statuses(i) = statuses(i) +0.5;
            end
        end
    end
else
    for(i = 1:nDataPts)
        cvx_begin
            cvx_solver sedumi
            cvx_solver_settings('maxiter', 300)
            variable pyx(N, N) nonnegative upper_triangular
            minimize(sum(sum(pyx.*repmat(xProbs',1,N),1).*xVals) - sum(xProbs.*xVals))
            subject to
                sum(max(pyx)) <= 2^constraintVals(i)
                sum(pyx,2) == 1
        cvx_end
        subplot(subplotx, subploty, i);
        imagesc(pyx);
        caxis([0 1]);
        title(['min-perfOver: transition matrix for ', num2str(constraintVals(i)), ' bits leaked']);
        if(strcmp(cvx_status, 'Solved') || strcmp(cvx_status, 'Inaccurate/Solved'))
            objectiveVals(i) = log2(cvx_optval);
            statuses(i) = 0.5;
            if(strcmp(cvx_status,'Solved'))
                statuses(i) = statuses(i) +0.5;
            end
        end
    end
end