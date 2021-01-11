function [res,xVals,xProbs,pyx,obsTiming] = multipleY(keys, K, oneshotleak)
% For a fixed key, counts the number of possible key guesses from the
% adversary's POV after 1:K observations
    data = importdata('../rawData/FixedMod_100Sample_self.mat');
    data = importdata('../rawData/FixedMod_20Sample_gmp_powm.mat');
    % Solve one-shot leakage optimization using the all ciphertext samples
    %uxMap = reshape(data.Timing,1,size(data.Timing,1)*size(data.Timing,2));
    N=size(data.Timing,1);
    xVals = unique(uxMap);
    xProbs = zeros(1,length(xVals));
    for(i = 1:length(xVals))
        xProbs(i) = sum(uxMap == xVals(i))/length(uxMap);
    end
    [minPerfVals, statuses, pyx, times] = optNoise_v2(2, xVals, xProbs, oneshotleak, 10000);
    
    %Using pyx, construct obsTiming matrix
    disp("Constructing U-Y mapping matrix...")
    obsTiming = zeros(N,65535,2);
    for(i=1:N)
        for(j=1:65535)
            obsTiming(i,j,:) = xVals(find(pyx(find(xVals==data.Timing(i,j)),:)>0));
        end
    end
    obsTiming=reshape(obsTiming,N,65535*2);
    disp("done")
    
    %Perform key guess counting
    disp("Performing key guess counting...")
    res=zeros(length(keys),K);
    for(i=1:length(keys)) % Iterate over each key
        key=keys(i); % Initialize single key analysis
        keyCands = 1:65535;
        for(k=1:K) % Iterate over number of observations
            keyCands = intersect(keyCands,find(obsTiming(k,:)==obsTiming(k,key) | obsTiming(k,:)==obsTiming(k,key+65535)));
            res(i, k)=length(keyCands);
        end
    end
    disp("done");
end

