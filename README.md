# Hudi Kafka Connect Demo

## Register Schema in Schema Registry

```sh
sh setup_schema_registry.sh
```

## Send Sample messages to the Kafka

```sh
sh generate_stocks_data.sh
```

## Register the Hudi Sink Connector

```sh
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type:application/json" \
  -H "Accept:application/json" \
  -d @hudi-sink-connector.json

curl http://localhost:8083/connectors/hudi-sink-connector/status
```

