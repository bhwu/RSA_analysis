function [ C_bound,rx ] = binCC( n, m )
% Computes Channel capacity for a binomial random variable with parameters
% n,m and 1/2 using Csiszar-Tusnady's algorithm

    rx = ones(n+1,1) * 1/(n+1);
    pyx = zeros(n+1, n+m+1);
    qxy = zeros(n+1, n+m+1);
    for(x = 0:n)
        pyx(x+1, :) = pdf('Binomial', [-x:n+m-x], m, 1/2);
    end
    num_iter = 500;
    %C_upper = zeros(1,num_iter);
    %C_lower = zeros(1, num_iter);
    C_bound = 0;
    for(i = 1:num_iter)
        temp1 = repmat(rx,1,n+m+1).*pyx;
        qxy = temp1./sum(temp1,1);

%         summand = temp1.*log2(qxy./repmat(rx,1,n+m+1));
%         summand(isnan(summand))=0;
%         C_lower(i) = sum(sum(summand));
        temp2 = prod(qxy.^pyx,2);
        rx = temp2/sum(temp2);
 
%         summand = temp1.*log2(qxy./repmat(rx,1,n+m+1));
%         summand(isnan(summand))=0;
%         C_upper(i) = sum(sum(summand));
    end
    summand = temp1.*log2(qxy./repmat(rx,1,n+m+1));
    summand(isnan(summand))=0;
    C_bound = sum(sum(summand));
%     figure(1);
%     C_diff = C_lower-C_upper;
%     plot(1:num_iter, C_lower, 'b', 1:num_iter, C_upper, 'r')
%     xlabel('num iterations')
%     ylabel('mutual information')
end

function [H] = shannonBin(n,p)
    if(n<=1024)
        N = [0:n];
        probs = pdf('Binomial', N, n, p);
        H = -sum(probs.*log2(probs));
    else
        % slight overestimate, but negligible for such large n
        H = 0.5*log2(2*pi*exp(1)*n*p*(1-p)); 
    end
end