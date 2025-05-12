#!/bin/bash

# check argument
if [[ -z "$1" ]]; then
    echo "ERROR: Missing KSQLDB name"
    echo "Example: $0 ksqlDB_merchant_1"
    exit 1
fi

if [[ -z "$2" ]]; then
    echo "ERROR: Missing KSQL command"
    echo 'Example: $0 $1 "SHOW STREAMS"'
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

# command
ksql_command="$2"

# connect
ksql -u "$key" -p"$secret" "$endpoint" --config-file '/connect/api_connector/ksql_config.properties' -e "$ksql_command;"