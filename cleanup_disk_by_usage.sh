#!/bin/sh

# disk 사용량이 70% 를 넘어가면 제일 오래된 파일순서로 디스크 공간을 확보할때까지 정리를 수행한다.
check_disk=/dev/sda3
cleanup_dir=/daum/logs/straw
cut_usage=70

echo "check_disk: $check_disk, cleanup_dir: $cleanup_dir"
while [ $(df -h $check_disk| grep -A1 "$check_disk"| awk '{print $5}' | cut -d'%' -f1) -ge $cut_usage ]
do
  fd=`/bin/ls -tr $cleanup_dir | head -n1 2>/dev/null`
  echo $fd
  rm -f $cleanup_dir/$fd
done

