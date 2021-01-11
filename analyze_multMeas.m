function [p_success, minf] = analyze_multMeas( uxMap)
% This function computes the probability of a successful guess given more
% than one observation using different ciphertexts and plots the
% probability as a function of the number of ciphertexts used
% The accepted input uxMap is a 2d array containing decryption timing
% measurements where the rows are indexed by ciphertext and the columns are
% indexed by attempted key (private exponent)
    
    % Set some useful lengths
    numCiphers = size(uxMap,1);
    numKeysPoss = size(uxMap,2);
    
    % First set the zero-measurement case to be 1/65535
    p_success = zeros(1, numCiphers+1);
    p_success(1) = 1/size(uxMap,2);
    minf = zeros(1, numCiphers+1);
    
    % loop over the number of ciphertexts (1 through size(uxMap,1))
    for(i = 1:numCiphers)
        disp(['starting i = ', num2str(i)]);
        [x_vectors, i_vecs, i_times] = unique(uxMap(1:i,:)','rows');
        p_success(i+1) = size(x_vectors,1)/numKeysPoss;
        % for each unique x-vector, compute the minf contribution
        cts = zeros(1, length(i_vecs));
        for(j = 1:length(i_vecs))
            cts(j) = sum(i_times == i_times(i_vecs(j)));
        end
        minf(i+1) = -sum(cts/numKeysPoss.*log2(cts/numKeysPoss));
    end
    
    figure(1); % Plot of probability of a successful guess
    plot(0:numCiphers,p_success);
    hold on;
    plot(0:numCiphers,(2.^minf)./numKeysPoss);
    hold off;
    title(['self-decrypt, up to ',num2str(numCiphers),' Ciphertexts'])
    xlabel('# of ciphertexts used')
    ylabel('probability of a successful guess')
    
    figure(2); % Plot of maximal leakage
    plot(0:numCiphers, log2(p_success./p_success(1)));
    hold on;
    plot(0:numCiphers, minf);
    hold off;
    title(['self-decrypt, up to ', num2str(numCiphers) ,' Ciphertexts'])
    xlabel('# of ciphertexts used')
    ylabel('maximal leakage')
    
end