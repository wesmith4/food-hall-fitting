% Cohort 1

% Version 1 and Version 2
mean1 = mean(SatisfactionDataCohort1(:,1));
mean2 = mean(SatisfactionDataCohort1(:,2));
std1 = std(SatisfactionDataCohort1(:,1));
std2 = std(SatisfactionDataCohort1(:,2));
df = 20 + 20 - 2;

tval = tinv(.975,df);

testStat = (mean1 - mean2)/(sqrt(std1^2/20 + std2^2/20));

[h,p,ci,stats] = ttest2(SatisfactionDataCohort1(:,1),SatisfactionDataCohort1(:,2),'Alpha', .001, 'Vartype', 'unequal')

pValues = zeros(4,3)

for i=2:3
    [h,p,ci,stats] = ttest2(SatisfactionDataCohort1(:,i),SatisfactionDataCohort1(:,1),'Alpha', .001, 'Vartype', 'unequal')
    pValues(1,i) = p;
end

for i=2:3
    [h,p,ci,stats] = ttest2(SatisfactionDataCohort2(:,i),SatisfactionDataCohort2(:,1),'Alpha', .001, 'Vartype', 'unequal')
    pValues(2,i) = p;
end

for i=2:3
    [h,p,ci,stats] = ttest2(SatisfactionDataCohort3(:,i),SatisfactionDataCohort3(:,1),'Alpha', .001, 'Vartype', 'unequal')
    pValues(3,i) = p;
end

for i=2:3
    [h,p,ci,stats] = ttest2(SatisfactionDataCohort4(:,i),SatisfactionDataCohort4(:,1),'Alpha', .001, 'Vartype', 'unequal')
    pValues(4,i) = p;
end
