# Setup
- Create all connectors in `connector` folder.
- Create all Ksql streams/tables in `ksql` folder.
- `db_data.order` will be used as **sample data table**.

# Control Timestamp
- To use your own timestamp field for the stream, set the `TIMESTAMP` option in the `WITH` clause. This tells ksqlDB to use your chosen field as the event time instead of the default.
    > ```sql
    > ...
    > WITH (KAFKA_TOPIC = 'stream_order_intake', VALUE_FORMAT = 'AVRO', TIMESTAMP = 'create_date') AS 
    > SELECT
    >   PARSE_TIMESTAMP(after->create_date, 'yyyy-MM-dd''T''HH:mm:ssX') AS create_date
    > ...
    > ```

- Check Ksql table result.
    > ```sql
    > SELECT product, order_count, from_unixtime(window_start) AS window_start, from_unixtime(window_end) AS window_end FROM table_hourly_order_count EMIT CHANGES;
    > ```

- Insert record to MySQL DB with `create_date`
    > ```sql
    > INSERT INTO db_data.order (id, product, amount, buyer_id, create_date) VALUES (null, 'Thingamajig', 8, 1, '2024-05-12 09:37:00');
    > ```


-  Using `DEFAULT` Timestamp
    - When insert record with `create_date`, ksqlDB uses the **current system time** as the event timestamp.
    - The record will appear in the window for the time it was **received**.
        > ```shell
        > CREATE_DATE = 2024-05-12T09:37:00
        > WINDOW_START = 2025-05-12T16:50:00
        > ```

-  Using `CUSTOM` Timestamp
    - When insert record with `create_date` and set your stream's **TIMESTAMP** column to use `create_date`, ksqlDB uses that value as the event timestamp.
    - The record will be grouped into the window according to the actual **create_date** value.
        > ```shell
        > CREATE_DATE = 2024-05-12T09:37:00
        > WINDOW_START = 2024-05-12T09:35:00.000
        > ```

# Grace Period