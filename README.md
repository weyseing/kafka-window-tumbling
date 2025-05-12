# Setup
- Create all Kafka connectors in `connector` folder.
- Create all Ksql streams/tables in `ksql` folder.
- `db_data.order` will be used as **sample table** in MySQL DB.

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

# Grace Period: Counting Late Events
**GRACE PERIOD** in ksqlDB windowed aggregations defines how long after a window closes late-arriving events can still be added to that window; once the grace period ends, any records for that window will be ignored and will not appear in the results.

**IMPORTANT:** MUST RECREATE the `table_hourly_order_count` table in KSQL DB to avoid incorrect future window.

- Check Ksql table result.
    > ```sql
    > SELECT product, order_count, from_unixtime(window_start) AS window_start, from_unixtime(window_end) AS window_end FROM table_hourly_order_count EMIT CHANGES;
    > ```

- **Windows & Grace Period**
    - The window size is **5 minutes** & **2 days** grace period. Example "current time" is `2024-05-14 09:14:00`.
    - Latest window: `09:10:00` to `09:15:00` on `2024-05-14`
    - Grace period for this window ends: `2024-05-16 09:15:00`

- **Insert with latest window create_date (inside window)**
   ```sql
   INSERT INTO `order` (product, amount, buyer_id, create_date)
   VALUES ('Widget', 1, 1, '2024-05-14 09:14:00');
   ```
   - ✅ Included in the latest window.

- **Insert at the window border (start time), as if arriving before grace period ended**
   ```sql
   INSERT INTO `order` (product, amount, buyer_id, create_date)
   VALUES ('Widget', 2, 1, '2024-05-12 09:10:00');
   ```
    - ✅ Included in the `2024-05-12 09:10:00` to `09:15:00` window if ingested before `2024-05-14 09:15:00`.

- **Insert just before the window (misses the next window)**
   ```sql
   INSERT INTO `order` (product, amount, buyer_id, create_date)
   VALUES ('Widget', 3, 1, '2024-05-12 09:09:59');
   ```
   - ❌ Not included because the grace period for the previous window `2024-05-12 09:05:00–09:10:00` is already over.