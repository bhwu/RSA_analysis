function [outputArg1,outputArg2] = randProtect(uxMap, seeds)
%Does the same thing as analyze_singMeas, except using randomly generated
%protection schemes

NUM_DATA_POINTS = length(seeds);

figure(1);
xVals = unique(uxMap);
px = zeros(1,length(xVals));
    for(i = 1:length(xVals))
        px(i) = sum(uxMap == xVals(i))/length(uxMap);
    end
n = length(xVals);    
minf = zeros(1,length(seeds)); % mutual information
mleak = zeros(1,length(seeds)); % maximal leakage
CC = zeros(1,length(seeds));
perf = zeros(1,length(seeds)); % performance overhead


for(i = 1:length(seeds))
    cost = zeros(n,n);
    % Construct timing channel cost matrix
    for(x = 1:n)
        for(y = 1:n)
            if(y>x)
                cost(x,y) = xVals(y)-xVals(x);
            end
            if(y<x)
                cost(x,y) = inf;
            end
        end
    end
    pxy = genMarkovUT(n,seeds(i));
    minf(i) = compute_minf(px, pxy);
    mleak(i) = compute_mleak(pxy);
    CC(i) = csiszar_tusnady(pxy, 200);
    perf(i) = compute_perf(px, pxy, cost);
    disp(['Done i = ', num2str(i)])
end

    % plot all the data
    plot(minf, perf, 'ro');
    hold on;
    plot(mleak, perf, 'bo');
    plot(CC, perf, 'ko');
    axis([0 max(mleak) 0 max(perf)]);
    ylabel('overhead (cycles)');
    xlabel('Leakage (bits)');
    title(['randomProtect']);
    %legend('mutual information', 'maximal leakage', 'channel capacity', 'Location','northeast');
    hold off;
    set(gcf,'Position',[10,10,700,450])