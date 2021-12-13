#!/usr/bin/python3
import requests, sys, json
response = requests.get('https://api.github.com/repos/nvm-sh/nvm/releases/latest')
print(json.loads(response.text)['name'])
