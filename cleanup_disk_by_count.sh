#!/bin/bash

# 파일의 갯수를 체크해서 최근 몇개만 남기고 이전 데이타들은 삭제
DATE=`date +'%Y%m%d_%H%m%S'`  ## 로그 기록을 위해 작업시간을 기록한다.
BACKUPCOUNT=300    ## 최근 300 개만 남기고 지운다.
WORKDIR=/data1/crawl_data
 
dirlist=`/bin/ls -t $WORKDIR`
 
i=1;
for fd in $dirlist; do
   if [ "$i" -ge $BACKUPCOUNT ]; then
       #echo $i $fd
       rm -f $WORKDIR/$fd
   fi
   i=$(($i+1))
done

