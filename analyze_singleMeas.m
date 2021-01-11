function [  ] = analyze_singleMeas( uxMap, noise )
    % Plots a comparative plot of mutual information (minf), maximal
    % leakage (mleak), and maximum likelihood correct guess probability
    % gain (mlike), given a u-x mapping (1-D vector) and a noise type
    
    % Constants:
    NUM_DATA_PTS = 30; % Not guaranteed to be exact, but used to approximate number of data points

    % Prepare data for later use
    figure(1);
    h = hist(uxMap, 'BinEdges', 0:max(uxMap)+1);
    xDist = h.Values/length(h.Data);
    
    % Depending on the type of noise, set up noise inline function and
    % noise parameter values
    % IMPORTANT: When adding future noise options, remember that the inline
    % function must be written in such a way as to give a distribution
    % ranging from 0 to max, with increments of 1.
    if(strcmp(noise, 'white'))
        zfunc = inline('binopdf(0:m,m,1/2)','m');
        maxWidth = max(h.Data) - min(h.Data);
        m = 0:floor(maxWidth/NUM_DATA_PTS):maxWidth;
    elseif(strcmp(noise, 'binomial-fixed-width'))
        maxWidth = max(h.Data) - min(h.Data);
        zfunc = inline(['binopdf(0:',num2str(maxWidth),',',num2str(maxWidth),',p)'],'p');
        p_min = 1/maxWidth;
        m = p_min:(1-2*p_min)/NUM_DATA_PTS:1-p_min;
    elseif(strcmp(noise, 'uniform'))
        zfunc = inline('ones(1,m+1)/(m+1)','m');
        maxWidth = max(h.Data) - min(h.Data);
        m = 0:floor(maxWidth/NUM_DATA_PTS):maxWidth;
    elseif(strcmp(noise, 'geometric'))
        zfunc = inline('[(1 - 10/(m+10)).^(0:m-2) * (10/(m+10)), (1-10/(m+10))^(m-1)]','m');
        maxWidth = max(h.Data) - min(h.Data);
        m = 0:floor(maxWidth/NUM_DATA_PTS):maxWidth;
    elseif(strcmp(noise, 'geometric-fixed-width'))
        maxWidth = max(h.Data) - min(h.Data);
        zfunc = inline(['[(1 - p).^(0:',num2str(maxWidth),'-2) * p, (1-p)^(',num2str(maxWidth),'-1)]'],'p');
        m = 1./(maxWidth:-maxWidth/NUM_DATA_PTS:2);
    elseif(strcmp(noise, 'poisson'))
        zfunc = inline('[poisspdf(0:m-1,m/3), 1-poisscdf(m-1,m/3)]','m');
        maxWidth = max(h.Data) - min(h.Data);
        m = 0:floor(maxWidth/NUM_DATA_PTS):maxWidth;
    elseif(strcmp(noise, 'poisson-fixed-width'))
        maxWidth = max(h.Data) - min(h.Data)
        zfunc = inline(['[poisspdf(0:',num2str(maxWidth-1),', L), 1-poisscdf(',num2str(maxWidth-1),', L)]'],'L');
        m = 0:maxWidth/NUM_DATA_PTS:maxWidth
    else
        disp('noise type not recognized');
        return;
    end
    
    % Prepare data point structures
    minf = zeros(1,length(m));
    mleak = zeros(1,length(m));
    mlike = zeros(1,length(m));
    perf = zeros(1,length(m)); % performance overhead
    
    % For each data point, compute minf, mleak, and mlike
    for(i = 1:length(m))
        Z = zfunc(m(i));
        minf(i) = compute_minf(xDist,Z);
        mleak(i) = compute_mleak(xDist, Z);
        mlike(i) = compute_mlike(uxMap, xDist, Z);
        perf(i) = compute_perf(Z);
    end
    
    % plot all the data
    figure(8);
    plot(perf, minf, 'r');
    hold on;
    plot(perf, mleak, 'b');
    plot(perf, mlike, 'ko');
    xlabel('Performance overhead (cycles)');
    ylabel('Leakage measure (bits)');
    title(['Noise type: "', noise,'"']);
    legend('mutual information', 'maximal leakage', 'maximum likelihood gain', 'Location','northeast');
    hold off;

end




