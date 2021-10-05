function [] = visualize(cohort,version)
close all
%% Initialize
numCustomers = 1200;

draw = true;

numGames = 5000;

S1 = 10000;
S2 = 80000;

combinations = [111,112,113,122,123,133,222,223,233,333];
outcomes = zeros(10,3);
for i=1:10
    outcomes(i,:) = dec2base(combinations(i),10) - '0';
end

    
CustomerPreferences = initPreferences(numCustomers, cohort);
CustomerSatisfaction = getSatisfaction(outcomes,CustomerPreferences);

StallCuisinePropensities = S1*ones(3,3);
StrategyPropensities = S2*ones(1,10);

Cuisines = [0 0 0];
HistVolumes = zeros(numGames,3);
OutcomeFrequencies = zeros(1,10);
for day=1:numGames
%% Game Iteration

% Handle stall updating
if ~mod(day,30) || day == 1
    [Cuisines,bucket] = updateCuisines(StallCuisinePropensities,StrategyPropensities,version,outcomes,Cuisines);
    OutcomeFrequencies(bucket) = OutcomeFrequencies(bucket) + 1;
end


% Handle everyday operations

[StallCuisinePropensities,StrategyPropensities,Volumes] = processCustomers(StallCuisinePropensities,StrategyPropensities,CustomerPreferences,Cuisines,outcomes,version,bucket);
HistVolumes(day,1:3) = Volumes;

% Forgetting
StallCuisinePropensities = .9995*StallCuisinePropensities;
StrategyPropensities = .9995*StrategyPropensities;

tempStall = StallCuisinePropensities/sum(StallCuisinePropensities);
StallCuisinePropensities(tempStall < .01) = 0;

if version == 3
tempStrategy = StrategyPropensities/sum(StrategyPropensities);
StrategyPropensities(tempStrategy < .01) = 0;
end

% Visualizations
if draw && (~mod(day,60) || day == numGames || day == 1)
    
    figure(1)
    sgtitle(['Version ' num2str(version) ', Cohort ' num2str(cohort) ', Iteration ' num2str(day)])
    if version == 1 || version == 2
        subplot(2,2,1),

        bar(StallCuisinePropensities./sum(StallCuisinePropensities,2),'stacked')
        legend('Cuisine 1', 'Cuisine 2', 'Cuisine 3','Location', 'EastOutside')
        title('Stall Cuisine Propensities')
    end
     
    subplot(2,2,2),
    bar(CustomerSatisfaction);
    title('Customer Satisfaction')
    xlabel('Outcome')
    
    if version == 3
    subplot(2,2,1),
        bar(StrategyPropensities/sum(StrategyPropensities,2))
        title('Food Hall Strategy Propensities')
        xlabel('Strategy')
    end
    
    subplot(2,2,4),
    bar(OutcomeFrequencies)
    title('Outcome Frequencies')
    xlabel('Outcome')
    ylabel('Frequency')
    
end

end
end



