import os
import csv
import datetime
import sys

filename=sys.argv[1]
results = []

with open(filename) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        try:
            if (line_count==0):
                results.append(row)
                line_count=line_count+1
            else:
                date_time_obj = datetime.datetime.strptime(row[0], '%Y-%m-%d %H:%M:%S')
                timestamp = int(datetime.datetime.timestamp(date_time_obj))
                row[0] = timestamp
                results.append(row)
        except:
            pass
if len(results) > 1:
    with open(filename+ "_timestamp", mode='w') as results_file:
        results_writer = csv.writer(results_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        for row in results:
            results_writer.writerow(row)
