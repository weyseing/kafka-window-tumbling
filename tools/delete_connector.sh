if [ -z "$1" ]
then
        echo "Please pass connector name get from API call curl -X GET http://localhost:8083/connectors. Eg: ./delete_connector.sh xxxx"
else
        curl -v -X DELETE "http://$CONNECTOR_USER:$CONNECTOR_PASS@localhost:8083/connectors/$1"
fi