#!/bin/bash

wget -c https://github.com/purduesigbots/pros-cli/releases/download/3.1.4/pros_cli_v5-3.1.4-py3-none-any.whl
pip install ./pros_cli_v5-3.1.4-py3-none-any.whl
git submodule init
git submodule update
pip install ./sphinx_rtd_theme
pip install -r requirements.txt
