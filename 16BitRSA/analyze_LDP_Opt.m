function [last_pxy, smallest_cost] = analyze_LDP_Opt(leak, precision)
%Brute-force computes optimal protection under local differential privacy
%for given leak value and precision level
%leak is the leakage bound (this function will not cause LDP to exceed that bound)
%precision is a power of 10 to which the transition matrix probabilities
%will be accurate

%hard-coded X and cost matrix
xVals = [1 2 3 4];
N = 4;
px = [.25 .25 .25 .25];
cxy = [1 2 3 4; 1 2 3 4 ; 1 2 3 4 ;1 2 3 4 ];
pxy = zeros(4,4);
last_pxy = pxy;
smallest_cost = 1000000000;
for(p_11 = 0:precision:1)
    for(p_12 = 0:precision:1)
        for(p_13 = 0:precision:1)
            for(p_21 = 0:precision:1)
                for(p_22 = 0:precision:1)
                    for(p_23 = 0:precision:1)
                        for(p_31 = 0:precision:1)
                            for(p_32 = 0:precision:1)
                                for(p_33 = 0:precision:1)
                                    for(p_41 = 0:precision:1)
                                        for(p_42 = 0:precision:1)
                                            for(p_43 = 0:precision:1)
                                                pxy = [p_11 p_12 p_13 1-p_11-p_12-p_13;p_21 p_22 p_23 1-p_21-p_22-p_23;p_31 p_32 p_33 1-p_31-p_32-p_33;p_41 p_42 p_43 1-p_41-p_42-p_43];
                                                if(pxy(:,4)>=0)
                                                    LDP = log2(max(max(pxy)./min(pxy)));
                                                    if(LDP<= leak)
                                                        cost = sum(sum(repmat(px',1,N).*pxy.*cxy));
                                                        if(cost<smallest_cost)
                                                            LDP
                                                            last_pxy = pxy;
                                                            smallest_cost = cost;
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
