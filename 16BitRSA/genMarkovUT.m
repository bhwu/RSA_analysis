function [mat] = genMarkovUT(size, seed)
%Generates a random square transition matrix of the specified size, using
%the specified random seed
rng(seed);
mat = rand(size, size);
mat(mat < ) = 0;
mat = triu(mat);
mat = mat./sum(mat,2);

% rng(seed);
% mat = zeros(size,size);
% for(i = 1:size)
%     randind1 = randi(size-i+1)+i-1;
%     mat(i,randind1) = mat(i,randind1)+0.5;
%     randind2 = randi(size-i+1)+i-1;
%     mat(i,randind2) = mat(i,randind2)+0.5;
% end