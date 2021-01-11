function [totalLeak] = N_obs_bf(P,N)
%Does an N-obs brute-force search for total ML, given the protection scheme
%P
Y_guess=find(sum(P,1)>0);
Y_poss=length(Y_guess);
obsVecs =zeros(Y_poss^N,N);
%Populate obsVecs
for(i=0:Y_poss^N-1)
    encoding = dec2base(i,Y_poss,N);
    for(j=1:N)
        obsVecs(i+1,j) = Y_guess(str2num(encoding(j))+1);
    end
end

%brute-force search
colMax=zeros(1,Y_poss^N);
for(obs=1:size(obsVecs,1)) %search across all observation vectors
    for(x=1:size(P,1))%search across all X-values
        ptemp=prod(P(x, obsVecs(obs,:)));
        if(ptemp>colMax(obs))
            colMax(obs)=ptemp;
        end
    end
end

totalLeak=sum(colMax);