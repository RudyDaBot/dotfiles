#!/usr/bin/python3
import requests, sys, json

def latest_release(repo):
    response = requests.get(f'https://api.github.com/repos/{repo}/releases/latest')
    return json.loads(response.text)['name']

def latest_tag(repo):
    response = requests.get(f'https://api.github.com/repos/{repo}/tags')
    return json.load(response.text)[0]['name']

type = sys.argv[1]
repo = sys.argv[2]

if type == "--release":
    print(latest_release(repo))
elif type == "--tag":
    print(latest_tag(repo))
else:
    print("You may only use --release or --type")
