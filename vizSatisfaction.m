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

figure(1)
sgtitle('Figure 1: Total Satisfaction under Outcomes 1-10')
for cohort=1:4
    CustomerPreferences = initPreferences(numCustomers, cohort);
    CustomerSatisfaction = getSatisfaction(outcomes,CustomerPreferences);
    subplot(2,2,cohort)
    bar(CustomerSatisfaction)
    title(['Cohort ' num2str(cohort)])
    xlabel('Outcome')
end





