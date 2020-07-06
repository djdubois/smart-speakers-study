import pandas as pd
import numpy as np
from datetime import datetime
import sys

df = pd.read_csv(sys.argv[1], error_bad_lines=False, sep=";")

th = float(sys.argv[2])

mac_dev = sys.argv[3]

time_pcap = df['frame_time_epoch'].iloc[0]

df['frame_time_epoch'] = pd.to_datetime(df['frame_time_epoch'], unit='s')


data = df[(df['eth_src'] == mac_dev) & (df['tcp_dstport'] == 443)]

df2 = data.groupby(pd.TimeGrouper(key='frame_time_epoch', freq='1s')).sum()

df3 = df2[(df2['frame_len'] > th)]

df4 = df3['frame_len']

if (df4.empty):
	print("empty")
else:
	print(str(time_pcap) + str(",0"))
	print(df4.iloc[[0, -1]].to_csv(header=False))

