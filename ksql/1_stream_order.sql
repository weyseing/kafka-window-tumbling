CREATE STREAM stream_order WITH (KAFKA_TOPIC='source_debezium.db_data.order', VALUE_FORMAT='AVRO');
