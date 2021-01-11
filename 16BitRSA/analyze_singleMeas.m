function [  ] = analyze_singleMeas( uxMap, noise )
    % Plots a comparative plot of mutual information (minf), maximal
    % leakage (mleak), and maximum likelihood correct guess probability
    % gain (mlike), given a u-x mapping (1-D vector) and a noise type
    
    % Constants:
    NUM_DATA_PTS = 30; % Not guaranteed to be exact, but used to approximate number of data points

    % Prepare data for later use
    figure(1);
    xVals = unique(uxMap);
    px = zeros(1,length(xVals));
    for(i = 1:length(xVals))
        px(i) = sum(uxMap == xVals(i))/length(uxMap);
    end
    
    % Depending on the type of noise, set up noise inline function and
    % noise parameter values
    % IMPORTANT: When adding future noise options, remember that the inline
    % function must be written in such a way as to give a distribution
    % ranging from 0 to max, with increments of 1.
    if(strcmp(noise, 'binomial'))
        zfunc = @(m) binopdf(0:m,m,1/2);
        maxWidth = length(xVals);
        %m = 0:floor(maxWidth/NUM_DATA_PTS):maxWidth;
        m = unique([0, floor(2.^(0:log2(maxWidth)/NUM_DATA_PTS:log2(maxWidth)))]);
    elseif(strcmp(noise, 'uniform'))
        zfunc = @(m) ones(1,m+1)/(m+1);
        maxWidth = length(xVals);
        m = 0:floor(maxWidth/NUM_DATA_PTS):maxWidth;
    elseif(strcmp(noise, 'geometric'))
        zfunc = @(m)[(1-10/(m+10)).^(0:m-1) *(10/(m+10)), (1-10/(m+10))^(m)];
        maxWidth = length(xVals);
        m = 0:floor(maxWidth/NUM_DATA_PTS):maxWidth;
    elseif(strcmp(noise, 'poisson'))
        zfunc = @(m) [poisspdf(0:m-1,m/3), 1-poisscdf(m-1,m/3)];
        maxWidth = length(xVals);
        m = 0:floor(maxWidth/NUM_DATA_PTS):maxWidth;
    else
        disp('noise type not recognized');
        return;
    end
    
    % Prepare data point structures
    minf = zeros(1,length(m)); % mutual information
    mleak = zeros(1,length(m)); % maximal leakage
    CC = zeros(1,length(m));
    perf = zeros(1,length(m)); % performance overhead
    n = length(xVals);
    iSz = mode(xVals(2:end)-xVals(1:end-1));
    yVals = [xVals, max(xVals)+iSz:iSz:max(xVals)+iSz*maxWidth];
    
    % For each data point, compute minf, mleak, and mlike
    for(i = 1:length(m))
        Z = zfunc(m(i));
        cost = zeros(n,n+m(i));
        % Construct timing channel cost matrix
        for(x = 1:n)
            for(y = 1:n+m(i))
                if(y>x)
                    cost(x,y) = yVals(y)-xVals(x);
                end
                if(y<x)
                    cost(x,y) = inf;
                end
            end
        end
        pxy = zeros(n,n+m(i));
        % Construct p(y|x) matrix
        for(x = 1:n)
            pxy(x,x:x+m(i)) = Z;
        end
        minf(i) = compute_minf(px, pxy);
        mleak(i) = compute_mleak(pxy);
        CC(i) = csiszar_tusnady(pxy, 200);
        perf(i) = compute_perf(px, pxy, cost);
        disp(['Done i = ', num2str(i)])
    end
    
    % plot all the data
    plot(mleak, perf, 'b-','LineWidth',2);
    hold on;
    plot(CC, perf, 'k--','LineWidth',2);
    plot(minf, perf, 'r:','LineWidth',2);
        axis([0 max(mleak) 0 max(perf)]);
    ylabel('Total Cost (cycles)');
    xlabel('Leakage (bits)');
    title('GMP implementation metric comparison')
    legend('ML', 'CC', 'MI', 'Location','northeast');
    hold off;
    %set(gcf,'Position',[10,10,700,450])
    
    data = zeros(4,length(m));
    data(1,:) = perf;
    data(2,:) = minf;
    data(3,:) = CC;
    data(4,:) = mleak;
    csvwrite(['16BData_',noise,'.csv'], data);

end




