function [ CC ] = csiszar_tusnady( pyx, num_iter)
% Using a given Y|X distribution, computes channel capacity using the
% Csiszar-Tusnady alternating maximization algorithm. This function accepts
% pyx, the transition matrix P(Y|X), an nxm matrix

n = size(pyx,1);
m = size(pyx,2);

% Start by guessing r(x) to be uniform
rx = ones(n,1) * 1/(n);
qxy = zeros(n, m);
for(i = 1:num_iter)
    for(y = 1:m)
        rx_pyx = rx.*pyx(:,y);
        qxy(:,y) = rx_pyx/sum(rx_pyx);
    end
    sum_x = 0;
    for(x = 1:n)
        qxy_pyx = qxy(x,:).^pyx(x,:);
        product = prod(qxy_pyx(qxy_pyx > 1e-10));
        sum_x = sum_x + product;
        rx(x) = product;
    end
    rx = rx/sum_x;
end

CC = 0;
for(x = 1:n)
    for(y = 1:m)
        add = rx(x)*pyx(x,y)*log2(qxy(x,y)/rx(x));
        if(~isnan(add))
            CC = CC + add;
        end
    end
end


% % Start by guessing r(x) to be uniform
% rx = ones(n,1) * 1/(n);
% RX = repmat(rx, 1, m);
% qxy = zeros(n, m);
% 
% for(i = 1:num_iter)
%     rx_pyx = RX.*pyx; %temp value = r(x) *p(y|x)
%     qxy = rx_pyx./sum(rx_pyx,1);
%     qxy(isnan(qxy)) = 0;
%     qxy_pyx = qxy.^pyx;
%     for(j = 1:m)
%         col = qxy_pyx(:,j);
%         tempProd(j) = prod(col(col>1e-15));
%     end
%     rx = tempProd/sum(tempProd);
%     RX = repmat(rx',1,m);
% end
% rx
% RX = repmat(rx,1,m);
% summand = RX.*pyx.*log2(qxy./RX);
% summand(isnan(summand)) = 0;
% CC = sum(sum(summand));
