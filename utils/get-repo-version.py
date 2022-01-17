#!/usr/bin/python3
import requests, sys, json

repo = sys.argv[1]

response = requests.get(f'https://api.github.com/repos/{repo}/releases/latest')
print(json.loads(response.text)['name'])
