# Imports
import numpy as np
import pandas as pd

# Model parameters
numCustomers = 1200
numGames = 5000
numTrials = 20
cohorts = [1, 2, 3, 4]
versions = [1, 2, 3]

outcomes = np.zeros(10, 3)
combinations = [111, 112, 113, 122, 123, 133, 222, 223, 233, 333]

for i in range(10):
    outcomes[i] = combinations[i].str.split
