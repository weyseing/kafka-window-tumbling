CREATE STREAM stream_order_intake AS
SELECT AFTER->id, AFTER->product, AFTER->amount, AFTER->buyer_id, AFTER->create_date
FROM stream_order
WHERE 1=1
    AND AFTER IS NOT NULL
EMIT CHANGES;