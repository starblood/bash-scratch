#!/bin/bash

str=$1
lstr=$(echo "$1" | awk '{print tolower($0)}')

echo "lstr: $lstr"

