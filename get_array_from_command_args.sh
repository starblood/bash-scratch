#!/bin/bash

# get comma(',') seperated input string from command line
# and then convert into array variable
HOSTS_INPUT=$1
HOSTS=()
IFS=',' read -r -a HOSTS <<< "$HOSTS_INPUT"

echo "hosts: ${HOSTS[@]}"
echo "hosts[0]: ${HOSTS[0]}"
echo "hosts[1]: ${HOSTS[1]}"
echo "hosts[2]: ${HOSTS[2]}"


