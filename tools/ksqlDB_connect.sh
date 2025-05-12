#!/bin/bash

# check argument
if [[ -z "$1" ]]; then
    echo "ERROR: Missing argument"
    echo "Example: $0 ksqlDB_merchant_1"
    exit 1
fi

# ksqlDB
ksqlDB_name=$(echo "$1" | tr '[:lower:]' '[:upper:]')
ksqlDB_endpoint="${ksqlDB_name}_URL"
ksqlDB_key="${ksqlDB_name}_KEY"
ksqlDB_secret="${ksqlDB_name}_SECRET"

# get value from env
key=${!ksqlDB_key}
secret=${!ksqlDB_secret}
endpoint=${!ksqlDB_endpoint}

# connect
ksql -u "$key" -p"$secret" "$endpoint" --config-file '/connect/api_connector/ksql_config.properties'
