# Hudi Kafka Connect Demo

## Create the Hudi Control Topic:

Access the Kafka Container:

```sh
docker exec -it kafka bash
```

Use the Kafka command line to create a control topic for Hudi:

```sh
kafka-topics --create --topic hudi-test-topic --partitions 1 --replication-factor 1 --if-not-exists --bootstrap-server localhost:9092
```

## Register Schema in Schema Registry

Access the Kafka Container:

```sh
docker exec -it kafka-cat bash
```

Navigate to the Hudi Kafka Connect Demo Directory:

```sh
cd /opt/data/hudi-kafka-connect-demo/
```

Run the Script to Register the Stocks Schema:

```sh
sh register_stocks_schema.sh
```

## Send Sample Messages to Kafka

Access the Kafka Container Again:

```sh
docker exec -it kafka-cat bash
```

Navigate to the Hudi Kafka Connect Demo Directory:

```sh
cd /opt/data/hudi-kafka-connect-demo/
```

Run the Script to Generate and Send Sample Stock Data to Kafka:

```sh
sh generate_and_send_stocks_data_to_kafka.sh
```

## Register the Hudi Sink Connector

Access the Kafka Connect Container:

```sh
docker exec -it kafka-connect bash
```

Navigate to the Hudi Kafka Connect Demo Directory:

```sh
cd /opt/data/hudi-kafka-connect-demo/
```

Check Existing Connectors:

```sh
curl -s http://localhost:8083/connectors | jq
```

Delete Existing Hudi Sink Connector (if it exists):

```sh
curl -s -X DELETE http://localhost:8083/connectors/hudi-sink-connector
```

Register the Hudi Sink Connector:

```sh
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type:application/json" \
  -H "Accept:application/json" \
  -d @hudi-sink-connector.json
```

Check the Status of the Hudi Sink Connector:

```sh
curl -s http://localhost:8083/connectors/hudi-sink-connector/status | jq
```

Verify if the Hudi table has been created:

```sh
ls -l /tmp/hoodie/hudi-test-topic
```

**Note:** You can verify the data inside kafka-connect conatiner.

## Register the Hudi Sink Connector for S3

Navigate to the Hudi Kafka Connect Demo Directory:

```sh
cd /opt/data/hudi-kafka-connect-demo/
```

Check Existing Connectors:

```sh
curl -s http://localhost:8083/connectors | jq
```

Delete Existing Hudi Sink Connector for S3 (if it exists):

```sh
curl -s -X DELETE http://localhost:8083/connectors/hudi-sink-connector-s3
```

Register the Hudi Sink Connector for S3:

```sh
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type:application/json" \
  -H "Accept:application/json" \
  -d @hudi-sink-connector-s3.json
```

Check the Status of the Hudi Sink Connector for S3:

```sh
curl -s http://localhost:8083/connectors/hudi-sink-connector-s3/status | jq
```

Verify if the Hudi table has been created:

Log in to MinIO and check if the following path exists:

```sh
s3a://warehouse/hudi_test_table/
```

## Register the Hudi Sink Connector for S3 with Hive

Navigate to the Hudi Kafka Connect Demo Directory:

```sh
cd /opt/data/hudi-kafka-connect-demo/
```

Check Existing Connectors:

```sh
curl -s http://localhost:8083/connectors | jq
```

Delete Existing Hudi Sink Connector for S3 with Hive (if it exists):

```sh
curl -s -X DELETE http://localhost:8083/connectors/hudi-sink-connector-s3-hive
```

Register the Hudi Sink Connector for S3 with Hive:

```sh
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type:application/json" \
  -H "Accept:application/json" \
  -d @hudi-sink-connector-s3-hive.json
```

Check the Status of the Hudi Sink Connector for S3 with Hive:

```sh
curl -s http://localhost:8083/connectors/hudi-sink-connector-s3-hive/status | jq
```

Verify if the Hudi table has been created:

1) Log in to MinIO and check if the following path exists:

```sh
s3a://warehouse/hudi_test_table/
```

2) Launch Hive Shell and verify the table is listed.