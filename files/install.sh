#!/usr/bin/env bash

cd "$( dirname "$0" )"

chmod a+x tools/*
mv tools/* /usr/local/bin/

# install updates
apt-get update
apt-get upgrade -y
apt-get autoremove -y

# install needed tools
pip install --upgrade pip
pip install m2r

# perform installation cleanup
apt-get -y clean
apt-get -y autoclean
apt-get -y autoremove
rm -r /var/lib/apt/lists/*
