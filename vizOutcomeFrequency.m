figure(2)
sgtitle('Figure 4: Average Outcome Frequency')

for i=1:3
    subplot(4,3,i)
    bar(BucketDataCohort1(i,:)/20)
    title(['Cohort 1, Version ' num2str(i)])
    xlabel('Outcome')
end

for i=1:3
    subplot(4,3,i+3)
    bar(BucketDataCohort2(i,:)/20)
    title(['Cohort 2, Version ' num2str(i)])
    xlabel('Outcome')
end

for i=1:3
    subplot(4,3,i+6)
    bar(BucketDataCohort3(i,:)/20)
    title(['Cohort 3, Version ' num2str(i)])
    xlabel('Outcome')
end

for i=1:3
    subplot(4,3,i+9)
    bar(BucketDataCohort4(i,:)/20)
    title(['Cohort 4, Version ' num2str(i)])
    xlabel('Outcome')
end