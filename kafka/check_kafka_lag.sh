#!/bin/bash

kafka_home=$1
zookeeper=$2
group_name=$3
lag_threshold=$4
lag_data_sampling_count=$5
if [ ! -z $6 ] ; then
    lag_data_file=$6
else
    lag_data_file=/tmp/kafka_lag.data
fi


function init_lag_data() {
    local sample_count=$1
    local result=()
    # initialize lag data array for a given sampling count
    i=0
    while [[ i -lt $sample_count ]]
    do
        result[$i]=0
        i=$((i+1))
    done
    echo ${result[@]}
}

# calculate average lag, drop floating point (i.e. 1.4 => 1)
lag_average=$($kafka_home/bin/kafka-consumer-groups.sh --zookeeper $zookeeper --group $group_name --describe | tail -n+2 | awk -F"," '{sum+=$6}END{ if (NR > 0) printf "%.0f\n", sum / NR; else printf "0\n"; }')

# calculate max lag
max_lag=$($kafka_home/bin/kafka-consumer-groups.sh --zookeeper $zookeeper --group $group_name --describe | tail -n+2 | awk -F "," '{print $6}' | sort -nr | head -n1)

# initialize lag data, load data from file if exists, otherwise initialize array with values of '0' for a given sampling count
if [ ! -f $lag_data_file ] ; then
    # initialize lag data array for a given sampling count
    lag_data_list=($(init_lag_data $lag_data_sampling_count))
    touch $lag_data_file
else
    # read lag data from file
    lag_data_count=$(cat $lag_data_file | wc -l)
    if [ $lag_data_count -eq $lag_data_sampling_count ] ; then
        lag_data_list=(`cat "$lag_data_file"`)
    # if data is not consistent, initialize and append last one
    else
        last_lag_data=$(cat $lag_data_file | tail -n1)
        lag_data_list=($(init_lag_data $lag_data_sampling_count))
        lag_data_list=(${lag_data_list[@]:1})
        lag_data_list=("${lag_data_list[@]}" "$last_lag_data")
    fi
fi

# remove the first lag data, retain given size(sampling_count) of elements in array
lag_data_list=(${lag_data_list[@]:1})

# append current lag metric to the end of array
lag_data_list=("${lag_data_list[@]}" "$lag_average")

# write lag metric to file
printf "%s\n" "${lag_data_list[@]}" > $lag_data_file

# test if lag is increasing
highest_lag=${lag_data_list[0]}
is_lag_increasing="true"
for lag in "${lag_data_list[@]}"
do
    if [ $is_lag_increasing == "false" ] ; then
        break
    fi
    if [ $lag -ge $highest_lag ] ; then
        highest_lag=$lag
        if [ $is_lag_increasing == "true" ] ; then
            is_lag_increasing="true"
        else
            is_lag_increasing="false"
        fi
    else
        is_lag_increasing="false"
    fi
done

# test if lag is excceed threshold
is_lag_exceed_threshold="false"
if [ $lag_average -gt "$lag_threshold" ] || [ $max_lag -gt "$lag_threshold" ] ; then
    is_lag_exceed_threshold="true"
fi

# if both condition is not satisfied, send alarm. '1' to lagging, '0' to normal
if [ $is_lag_increasing == "true" ] && [ $is_lag_exceed_threshold == "true" ] ; then
    echo "1"
else
    echo "0"
fi

