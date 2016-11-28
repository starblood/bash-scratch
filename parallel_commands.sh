#!/bin/bash

function run_parallel() {
    for cmd in "$@"; do {
      echo "Process \"$cmd\" started";
      $cmd & pid=$!
      PID_LIST+=" $pid";
    } done
    
    trap "kill $PID_LIST" SIGINT
    echo "Parallel processes have started";
    wait $PID_LIST
    echo "All processes have completed";
}

cmd1="sleep 1"
cmd2="sleep 4"
run_parallel "$cmd1" "$cmd2"

echo "hello"
