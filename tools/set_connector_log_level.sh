# check empty plugin name
if [ -z "$1" ]
then
    echo '{"ERROR": "Please pass connector plugin name, get from API call (./list_all_plugins.sh)"}' | jq .
    exit 1
fi

# check empty log level
if [ -z "$2" ]
then
    echo '{
    "ERROR": "Please pass log level",
    "log_levels": {
        "OFF": "Turns off logging.",
        "FATAL": "Severe errors that cause premature termination.",
        "ERROR": "Other runtime errors or unexpected conditions.",
        "WARN": "Runtime situations that are undesirable or unexpected, but not necessarily wrong.",
        "INFO": "Runtime events of interest at startup and shutdown.",
        "DEBUG": "Detailed diagnostic information about events.",
        "TRACE": "Detailed diagnostic information about everything."
    }
    }' | jq .
    exit 1
fi

# check plugin name
plugin_list=$(./list_all_plugins.sh)
if ! echo "$plugin_list" | grep -q "\"class\": \"$1\""; then
  echo '{"ERROR": "Connector plugin ('"$1"') is not present in the plugin list. Please get plugin names from API call (./list_all_plugins.sh)"}' | jq .
  exit 1
fi

# set log level
curl -s -X PUT -H "Content-Type:application/json" http://$CONNECTOR_USER:$CONNECTOR_PASS@localhost:8083/admin/loggers/$1 -d '{"level": "'"$2"'"}'

