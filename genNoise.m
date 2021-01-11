function [ zfunc ] = genNoise( type, params )
% Generates a noise function given a type (descriptive string) and
% appropriate parameters (ordered array). The inline function takes only
% one input: the "width" of the distribution from 0 to m.

% type binomialIndep: binomial distribution with a fixed p-value; Expects a
% single parameter (p), and gives an inline function zfunc(m) that
% generates the entire distribution from 0 to m.

    if(strcmp(type, 'binomialIndep'))
        assert(length(params) == 1);
        zfunc = inline(['binopdf(0:m,m,',num2str(params(1)),')'],'m');
    elseif(strcmp(type, 'uniform'))
        assert(length(params) == 0);
        zfunc = inline('ones(1,m+1)/(m+1)', 'm');
    elseif(strcmp(type, 'geometric'))
        assert(length(params) == 1);
        zfunc = inline([''].'m')
    elseif(strcmp(type, 'none'))
        zfunc = inline('1', 'm');
    else
        disp('Noise type not recognized, code will not behave as expected');
        zfunc = inline('-1');
        return
    end

end