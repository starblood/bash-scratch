# check_kafka_lag.sh
  * kafka 에서 주어진 consumer group 에서 lag(average 혹은 max) 이 주어진 threshold 값보다 크고, 지속적으로 lag 이 증가한다면 알람을 보내줍니다.
  * 1 이면 lag 이 발생, 0 이면 정상
  * 스크립트 인자
    1. kafka bin directory
    2. zookeeper quorum 정보
    3. consumer group name
    4. lag 의 threshold 값
    5. lag 을 판단하기 위해서 몇개의 sampling data 를 추출할 지 지정
    6. lag 데이터를 저장하기 위한 파일의 경로 (optional)
