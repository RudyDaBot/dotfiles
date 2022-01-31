#!/bin/bash

cat << EOF
┌──────────────────────────────────────────────────────────────────────┐
│This Bash Script is made by Rishab (@Grobo021 on GitHub) to create    │
│a ~/.venv folder with Python Packages he needs, which are:-           │
│* Tensorflow                                                          │
│* NumPy                                                               │
│* Pandas                                                              │
│* MatPlotLib                                                          │
│                                                                      │
│This script is **OPTIONAL** and is not needed by most people, use this│
│if you do things in AI. Also you can modify requirements.txt to get   │
│other Python Packages you may need.                                   │
└──────────────────────────────────────────────────────────────────────┘
EOF

while ! getopts ":noconfirm:" opt; do
    read -p "Do you wish to run the virtual python environment script? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

python3 -m venv ~/.venv
source .venv/bin/activate
pip install -r requirements.text
deactivate
