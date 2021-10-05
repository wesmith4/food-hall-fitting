% Model parameters
numCustomers = 1200;
numGames = 5000;
numTrials = 20;
cohorts = [1,2,3,4];
versions = [1,2,3];

outcomes = zeros(10,3);
combinations = [111,112,113,122,123,133,222,223,233,333];
for i=1:10 % Create usable matrix from the above combinations
    outcomes(i,:) = dec2base(combinations(i),10) - '0';
end

% Initializers for learning buckets
S1 = 10000;
S2 = 80000;

% Initialize results matrices
SatisfactionDataCohort1 = zeros(numTrials, 3);
SatisfactionDataCohort2 = zeros(numTrials, 3);
SatisfactionDataCohort3 = zeros(numTrials, 3);
SatisfactionDataCohort4 = zeros(numTrials, 3);

BucketDataCohort1 = zeros(3,10);
BucketDataCohort2 = zeros(3,10);
BucketDataCohort3 = zeros(3,10);
BucketDataCohort4 = zeros(3,10);


for cohort = cohorts % Cohort loop
    CustomerPreferences = initPreferences(numCustomers, cohort);
    CustomerSatisfaction = getSatisfaction(outcomes,CustomerPreferences);
    
    for version = versions % Version loop
        
        rng(version)
        for trial = 1:numTrials % Trial Loop
            
            disp(['Beginning Cohort ' num2str(cohort) ', version ' num2str(version) ', trial ' num2str(trial)])
            
            % Initialize learning buckets
            StallCuisinePropensities = S1*ones(3,3);
            StrategyPropensities = S2*ones(1,10);
            
            Cuisines = [0 0 0];
            HistVolumes = zeros(numGames,3);
            OutcomeFrequencies = zeros(1,10);
            
            for day=1:numGames % Day loop
                
                % Handle stall updating
                if ~mod(day,30) || day == 1
                    [Cuisines,bucket] = updateCuisines(StallCuisinePropensities,StrategyPropensities,version,outcomes,Cuisines);
                    OutcomeFrequencies(bucket) = OutcomeFrequencies(bucket) + 1;
                end
                
                
                % Handle everyday operations
                [StallCuisinePropensities,StrategyPropensities,Volumes] = processCustomers(StallCuisinePropensities,StrategyPropensities,CustomerPreferences,Cuisines,outcomes,version,bucket);
                HistVolumes(day,1:3) = Volumes;
                
                % Implementation of forgetting in learning buckets
                StallCuisinePropensities = .9995*StallCuisinePropensities;
                StrategyPropensities = .9995*StrategyPropensities;
                
                tempStall = StallCuisinePropensities/sum(StallCuisinePropensities);
                StallCuisinePropensities(tempStall < .01) = 0;
                tempStrategy = StrategyPropensities/sum(StrategyPropensities);
                StrategyPropensities(tempStrategy < .01) = 0;
                
            end
            
            % Populate results matrices
            if cohort == 1
                SatisfactionDataCohort1(trial, version) = sum(CustomerSatisfaction.*OutcomeFrequencies);
                BucketDataCohort1(version,:) = BucketDataCohort1(version,:) + OutcomeFrequencies;
            elseif cohort == 2
                SatisfactionDataCohort2(trial, version) = sum(CustomerSatisfaction.*OutcomeFrequencies);
                BucketDataCohort2(version,:) = BucketDataCohort2(version,:) + OutcomeFrequencies;
            elseif cohort == 3
                SatisfactionDataCohort3(trial, version) = sum(CustomerSatisfaction.*OutcomeFrequencies);
                BucketDataCohort3(version,:) = BucketDataCohort3(version,:) + OutcomeFrequencies;
            elseif cohort == 4
                SatisfactionDataCohort4(trial, version) = sum(CustomerSatisfaction.*OutcomeFrequencies);
                BucketDataCohort4(version,:) = BucketDataCohort4(version,:) + OutcomeFrequencies;
            end
            
            
        end
    end
end

% Two sample t-tests for difference of means from Version 1
pValues = zeros(4,3);

for i=2:3
    [h,p,ci,stats] = ttest2(SatisfactionDataCohort1(:,i),SatisfactionDataCohort1(:,1),'Alpha', .001, 'Vartype', 'unequal');
    pValues(1,i) = p;
end

for i=2:3
    [h,p,ci,stats] = ttest2(SatisfactionDataCohort2(:,i),SatisfactionDataCohort2(:,1),'Alpha', .001, 'Vartype', 'unequal');
    pValues(2,i) = p;
end

for i=2:3
    [h,p,ci,stats] = ttest2(SatisfactionDataCohort3(:,i),SatisfactionDataCohort3(:,1),'Alpha', .001, 'Vartype', 'unequal');
    pValues(3,i) = p;
end

for i=2:3
    [h,p,ci,stats] = ttest2(SatisfactionDataCohort4(:,i),SatisfactionDataCohort4(:,1),'Alpha', .001, 'Vartype', 'unequal');
    pValues(4,i) = p;
end



