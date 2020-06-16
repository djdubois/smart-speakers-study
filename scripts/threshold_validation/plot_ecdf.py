import numpy as np
import statsmodels.api as sm # recommended import according to the docs
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import numpy as np1
import sys

df = pd.read_csv(sys.argv[1], error_bad_lines=False, sep=";")

act = df[(df['device'] == sys.argv[2])]
quiet = df[(df['device'] == sys.argv[3])]

sample_act = act['peak'].apply(lambda x: x / 1024)
sample_quiet=  quiet['peak'].apply(lambda x: x / 1024)
ecdf = sm.distributions.ECDF(sample_act)
ecdf_quiet = sm.distributions.ECDF(sample_quiet)

print(ecdf.x)
print(ecdf.y)
print(ecdf_quiet.x)
print(ecdf_quiet.y)
fig, ax = plt.subplots(figsize=(10,7))
handles, labels = ax.get_legend_handles_labels()
ax.legend(handles, labels)
ax.set_ylabel("ECDF", fontsize=25)
ax.set_xlabel("KB/s", fontsize=25)
line_up=plt.plot(ecdf_quiet.x, ecdf_quiet.y, '--', linewidth=5,label='Background Traffic')
line_down=plt.plot(ecdf.x,ecdf.y,linewidth=5,label='Activation Traffic')

plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.xlim(-0.488, 31)
plt.ylim(0.001, 1.03)
plt.grid(True)
plt.legend(fontsize="xx-large",loc=4)
plt.axvline(12.171, color='red', linestyle='solid', linewidth=2, label='Threshold')
ax.annotate('Threshold (X)', xy=(12.255, 0.8), xytext=(12.988, 0.9),
            arrowprops=dict(facecolor='black', shrink=0.05), fontsize=25)
plt.savefig('./fig/ecdf_th.eps')
