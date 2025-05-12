CREATE STREAM stream_order_intake
WITH (KAFKA_TOPIC = 'stream_order_intake', VALUE_FORMAT = 'AVRO', TIMESTAMP = 'create_date') AS
SELECT 
    AFTER->id, AFTER->product, AFTER->amount, AFTER->buyer_id, 
    PARSE_TIMESTAMP(after->create_date, 'yyyy-MM-dd''T''HH:mm:ssX') AS create_date,
    (ROWTIME + 8*60*60*1000) AS row_time
FROM stream_order
WHERE 1=1
    AND AFTER IS NOT NULL
EMIT CHANGES;