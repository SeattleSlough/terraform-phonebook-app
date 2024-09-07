#!/bin/bash
dnf update -y
dnf install pip -y
pip3 install flask==2.3.3
pip3 install flask-mysql
dnf install git -y
git clone https://github.com/SeattleSlough/phonebook-app.git phonebook

# the above line would be replaced with a token login to allow for a private repo