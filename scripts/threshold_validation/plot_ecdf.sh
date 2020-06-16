PATH_ACT=$1
PATH_QUIET=$2
DEV_ACT=$3
DEV_QUIET=$4
cat $PATH_ACT $PATH_QUIET > threshold_max.csv
sed  -i '1i peak;device' threshold_max.csv
python3 plot_ecdf.py threshold_max.csv $DEV_ACT $DEV_QUIET
