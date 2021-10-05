function [CustomerSatisfaction] = getSatisfaction(outcomes,CustomerPreferences)

numCustomers = size(CustomerPreferences,1);
CustomerSatisfaction = zeros(1,10);

for outcome=1:10
    availableCuisines = outcomes(outcome,:); % Detect cuisines from outcome #
    for i=1:numCustomers
        for cuisine=1:3
            % For every customer x every cuisine, add their preference for
            % that cuisine to the total Satisfaction if that cuisine is
            % available in the given outcome
            if ismember(cuisine,availableCuisines)
                CustomerSatisfaction(outcome) = CustomerSatisfaction(outcome) + CustomerPreferences(i,cuisine);
            end
        end
    end
end
end

