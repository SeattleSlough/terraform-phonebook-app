#! /bin/bash
dnf update -y
dnf install pip -y
pip3 install flask==2.3.3
pip3 install flask-mysql
dnf install git -y
TOKEN=${user-data-git-token}
USER=${user-data-git-user}
cd /home/ec2-user
git clone https://github.com/$USER/phonebook-app.git phonebook
python3 phonebook/phonebook-app.py

# Replace line 10 with https://$TOKEN@github.com/$USER/<repo> to allow for a private repo
# I've made the phonebook app repo public so this isn't implemented