# Hudi Kafka Connect Demo

## Register Schema in Schema Registry

```sh
docker exec -it kafka-cat bash
cd /opt/data/hudi-kafka-connect-demo/
sh register_stocks_schema.sh
```

## Send Sample messages to the Kafka

```sh
docker exec -it kafka-cat bash
cd /opt/data/hudi-kafka-connect-demo/
sh generate_and_send_stocks_data_to_kafka.sh
```

## Register the Hudi Sink Connector

```sh
docker exec -it kafka-connect bash

cd /opt/data/hudi-kafka-connect-demo/

curl -s http://localhost:8083/connectors | jq
curl -s -X DELETE http://localhost:8083/connectors/hudi-sink-connector

curl -X POST http://localhost:8083/connectors \
  -H "Content-Type:application/json" \
  -H "Accept:application/json" \
  -d @hudi-sink-connector.json

curl -s http://localhost:8083/connectors/hudi-sink-connector/status | jq
```

```sh
cd /opt/data/hudi-kafka-connect-demo/

curl -s http://localhost:8083/connectors | jq
curl -s -X DELETE http://localhost:8083/connectors/hudi-sink-connector-s3

curl -X POST http://localhost:8083/connectors \
  -H "Content-Type:application/json" \
  -H "Accept:application/json" \
  -d @hudi-sink-connector-s3.json

curl -s http://localhost:8083/connectors/hudi-sink-connector-s3/status | jq
```

```sh
cd /opt/data/hudi-kafka-connect-demo/

curl -s http://localhost:8083/connectors | jq
curl -s -X DELETE http://localhost:8083/connectors/hudi-sink-connector-s3-hive

curl -X POST http://localhost:8083/connectors \
  -H "Content-Type:application/json" \
  -H "Accept:application/json" \
  -d @hudi-sink-connector-s3-hive.json

curl -s http://localhost:8083/connectors/hudi-sink-connector-s3-hive/status | jq
```

