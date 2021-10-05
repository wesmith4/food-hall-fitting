function [StallCuisinePropensities,StrategyPropensities,Volumes] = processCustomers(StallCuisinePropensities,StrategyPropensities, CustomerPreferences,Cuisines,strategies,version,bucket)
%     Handles customer choices and payoffs and stall payoffs

    numCustomers = size(CustomerPreferences,1);
    choices = zeros(1,numCustomers);

    for customer=1:numCustomers % Loop through all customers
        
        % Set current preferences according to the cuisines AVAILABLE
        prefs = zeros(1,4);
        for i=1:3 
            prefs(i) = CustomerPreferences(customer,Cuisines(i));
        end
        % Preference for staying home (choice 4) = maximum possible sum of preferences
        % minus sum of current preferences
        prefs(4) = .85*3 - sum(prefs);
        
        % Convert to cumulative scale from 0 to 1 for use with rand
        cumulativePrefs = cumsum(prefs)/sum(prefs);
        
        % Use choice structure similar to Roth & Erev
        choice = 1;
        x = rand;
        for i=2:4
            if x > cumulativePrefs(i-1)
                choice = i;
            end
        end
        choices(customer) = choice; 
    end
    Volumes = zeros(1,3);
    
    for i=1:3
        Volumes(i) = sum(choices == i); % Get service volumes for each stall
        if version == 1 || version == 2 % Add to individual stalls' buckets for their cuisine choices
            StallCuisinePropensities(i,Cuisines(i)) = StallCuisinePropensities(i,Cuisines(i)) + Volumes(i);
        end
    end
    
    if version == 2 % Contribute to buckets according to other stalls' volumes, but at a .5 rate
        for i=1:3
            for j=1:3
                if i ~= j
                    StallCuisinePropensities(i,Cuisines(j)) = StallCuisinePropensities(i,Cuisines(j)) + Volumes(j)*.5;
                end
            end
        end
    end
        
    % Add to buckets for the strategy/outcome of available cuisines
    % This is most relevant for version 3
    StrategyPropensities(bucket) = StrategyPropensities(bucket) + sum(Volumes);
end