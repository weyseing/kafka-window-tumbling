CREATE STREAM stream_order_intake AS
SELECT 
    AFTER->id, AFTER->product, AFTER->amount, AFTER->buyer_id, AFTER->create_date,
    (ROWTIME + 8*60*60*1000) AS row_time
FROM stream_order
WHERE 1=1
    AND AFTER IS NOT NULL
EMIT CHANGES;