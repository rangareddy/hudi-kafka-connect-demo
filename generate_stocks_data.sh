KAFKA_HOSTNAME=${KAFKA_HOSTNAME:-"kafka"}
KAFKA_PORT=${KAFKA_PORT:-29092}
KAFKA_TOPIC_NAME=${KAFKA_TOPIC_NAME:-"hudi-test-topic"}
STOCKS_DATA_FILE=stocks_data.json
EVENTS_FILE=${EVENTS_FILE:-"kafka_input_events"}
numHudiPartitions=5
recordKey=volume
partitionField=date
numBatch=1
recordValue=0
numRecords=5

# Generate kafka messages from raw records
# Each records with unique keys and generate equal messages across each hudi partition
partitions={}
for ((i = 0; i < ${numHudiPartitions}; i++)); do
  partitions[$i]="partition_"$i
done

totalNumRecords=$((numRecords + recordValue))

for ((i = 1;i<=numBatch;i++)); do
  rm -f ${EVENTS_FILE}
  date
  echo "Start batch $i ..."
  batchRecordSeq=0
  for (( ; ; )); do
    while IFS= read line; do
      for partitionValue in "${partitions[@]}"; do
        echo $line | jq --arg recordKey $recordKey --arg recordValue $recordValue --arg partitionField $partitionField \
          --arg partitionValue $partitionValue -c '.[$recordKey] = $recordValue | .[$partitionField] = $partitionValue' >> ${EVENTS_FILE}
        ((recordValue = recordValue + 1))
        ((batchRecordSeq = batchRecordSeq + 1))

        if [ $batchRecordSeq -eq $numRecords ]; then
          break
        fi
      done

      if [ $batchRecordSeq -eq $numRecords ]; then
        break
      fi
    done <"$STOCKS_DATA_FILE"

    if [ $batchRecordSeq -eq $numRecords ]; then
        date
        echo " Record key until $recordValue"
        sleep 20
        break
      fi
  done

  echo "Publish stocks data to Kafka topic ${KAFKA_TOPIC_NAME} ..."
  grep -v '^$' ${EVENTS_FILE} | kafkacat -b "${KAFKA_HOSTNAME}:${KAFKA_PORT}" -t "${KAFKA_TOPIC_NAME}" -T -P
done

