#!/bin/sh

# disk 사용량이 70% 를 넘어가면 제일 오래된 파일순서로 디스크 공간을 확보할때까지 정리를 수행한다.
check_disk=/logs
cut_usage=70

while [ `df -h $check_disk|cut -c40-42|grep -i [^a-z]|bc` -ge $cut_usage ]
do
  fd=`/bin/ls -tr $check_disk | head -n1 2>/dev/null`
  echo $fd
  rm -f $check_disk/$fd
done

