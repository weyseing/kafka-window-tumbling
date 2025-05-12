# import library
import os
import re
import sys
import json
import requests
from datetime import datetime
from dotenv import load_dotenv

def regex_env_string(match):
    env_variable = match.group(1)
    env_value = os.environ.get(env_variable, "$"+env_variable)
    return env_value

def replace_env(data):
    for key, value in data.items():
        if isinstance(value, str):
            pattern = r'\$([A-Za-z_][A-Za-z0-9_]*)'
            data[key] = re.sub(pattern, regex_env_string, value)

        elif isinstance(value, dict):
            data[key] = replace_env(value)
    return data


if __name__ == "__main__":
    # read json config
    json_file = sys.argv[1]
    with open(json_file, 'r') as file:
        json_data = json.load(file)

    # replace env
    json_data = replace_env(json_data)

    # create connector API
    url = "http://"+str(os.environ.get("CONNECTOR_USER"))+":"+str(os.environ.get("CONNECTOR_PASS"))+"@localhost:8083/connectors"
    headers = {"content-type": "application/json"}
    req_data = {
        "name": json_data["name"],
        "config": json_data
    }
    response = requests.post(url, headers=headers, json=req_data)
    print(response.content.decode('utf-8'))  


