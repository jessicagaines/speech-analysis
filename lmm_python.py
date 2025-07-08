# -*- coding: utf-8 -*-
"""
Created on Wed Jun 11 16:22:12 2025

@author: jgaines
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import statsmodels.api as sm
from statsmodels.stats import anova
import statsmodels.formula.api as smf

data = pd.read_csv("pitch.csv",header=0)
data['cycle_cat'] = data['cycle'].astype(str)
data['phase_num'] = np.ndarray(len(data['phase']))
data['phase_num'][data['phase'] == "baseline"] = 0
data['phase_num'][data['phase'] == "hold"] = 1
data['phase_num'][data['phase'] == "early_washout"] = 2
data['phase_num'][data['phase'] == "late_washout"] = 3

print(data)

md = smf.mixedlm("pitch ~ 1 + phase_num + cycle + phase_num*cycle", data, groups=data["participant"])
mdf = md.fit()
print(mdf.summary())

md = smf.mixedlm("pitch ~ 1 + phase + cycle + phase*cycle", data, groups=data["participant"])
mdf = md.fit()
print(mdf.summary())

md = smf.mixedlm("pitch ~ 1 + phase + cycle_cat + phase*cycle_cat", data, groups=data["participant"])
mdf = md.fit()
print(mdf.summary())


