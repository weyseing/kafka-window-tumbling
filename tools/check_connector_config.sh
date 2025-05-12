if [ -z "$1" ]
then
        echo "Please pass connector name get from API call curl -X GET http://localhost:8083/connectors. Eg: ./view_connector_config.sh xxxx"
else
        curl --silent -X GET http://$CONNECTOR_USER:$CONNECTOR_PASS@localhost:8083/connectors/$1/config | jq .
fi