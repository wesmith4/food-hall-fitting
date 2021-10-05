function [CustomerPreferences] = initPreferences(numCustomers, cohort)   
    % Takes numCustomers, cohort and returns CustomerPreferences matrix

    CustomerPreferences = zeros(numCustomers, 3);
    % Should change these to make more sense with my versions
    
    preferenceLevels = [.85 .5 .15]; 
    Personas = perms(preferenceLevels); % Results in 6x3 matrix
    cohortDistributions = [ones(1,6);1,0,0,0,0,0;1,0,0,0,0,1;1,0,0,0,0,3];

    % Personas 1 & 2 prefer Cuisine 1 the most
    % Personas 3 & 5 prefer Cuisine 2 the most
    % Personas 4 & 6 prefer Cuisine 3 the most
      
    % Detect needed distribution
    thisDistribution = cohortDistributions(cohort,:);
    groupSize = numCustomers/sum(thisDistribution);
        
    % Now generate preferences matrix from the needed dist. of personas
    counter = 1;
    for i=1:6
        while thisDistribution(i)
            counter2 = groupSize;
            while counter2
                CustomerPreferences(counter,:) = Personas(i,:);
                counter2 = counter2 - 1;
                counter = counter + 1;
            end
            thisDistribution(i) = thisDistribution(i) - 1;
        end
    end
end