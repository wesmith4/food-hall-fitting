function [Cuisines,bucket] = updateCuisines(StallCuisinePropensities, StrategyPropensities,version,strategies,Cuisines)
% Returns new Cuisine choices & the respective outcome/strategy #


% Versions 1 & 2: individual stalls make decisions
if version == 1 || version == 2
    choices = zeros(1,3);
    
    % Use choice structure similar to Roth & Erev model
    for stall = 1:3
        props = StallCuisinePropensities(stall,:);
        cumulativeProps = cumsum(props)/sum(props);
        
        x = rand;
        choice = 1;
        for j=2:3
            if x > cumulativeProps(j-1)
                choice = j;
            end
        end
        choices(stall) = choice;
    end
    Cuisines = choices;
    
    % Detect strategy/outcome of these latest cuisine choices
    for i=1:10
        strategy = strategies(i,:);
        num1 = sum(strategy == 1);
        num2 = sum(strategy == 2);
        num3 = sum(strategy == 3);
        if num1 == sum(Cuisines == 1) && num2 == sum(Cuisines == 2) && num3 == sum(Cuisines == 3)
            bucket = i;
        end
    end
    

% Version 3: Food Hall chooses a strategy, makes all decisions
elseif version == 3
    % Also uses the Roth & Erev style choice structure
    props = StrategyPropensities;
    cumulativeProps = cumsum(props)/sum(props);
    
    strategy = 1;
    x = rand;
    for i=2:length(props)
        if x > cumulativeProps(i-1)
            strategy = i;
        end
    end
    
    Cuisines = strategies(strategy,:);
    bucket = strategy;
end

end