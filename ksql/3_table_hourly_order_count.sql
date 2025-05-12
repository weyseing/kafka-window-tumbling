CREATE TABLE table_hourly_order_count 
WITH (KAFKA_TOPIC='table_hourly_order_count', VALUE_FORMAT='AVRO') AS
SELECT
    product,
    COUNT(*) AS order_count,
    WINDOWSTART AS window_start,
    WINDOWEND AS window_end
FROM stream_order_intake
WINDOW TUMBLING (SIZE 5 MINUTE, GRACE PERIOD 2 DAYS)
GROUP BY product
EMIT CHANGES;
