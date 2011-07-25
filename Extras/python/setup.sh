#!/bin/bash

#sudo easy_install pip virtualenv

virtualenv --no-site-packages ./curator_ext_env

source ./curator_ext_env/bin/activate

pip install --upgrade -r requirements.txt

