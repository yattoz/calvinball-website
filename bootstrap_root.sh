#!/bin/bash
echo "BOOSTRAP SCRIPT Debian/Ubuntu"
echo "The script you are running has basename `basename "$0"`, dirname `dirname "$0"`"
echo "The present working directory is `pwd`"


if [[ $USER != "root" ]]; then
	echo "you must run this as root"
	exit 1
fi

# build Nokogiri
apt-get install -y build-essential git patch zlib1g-dev liblzma-dev
# build rmagick
apt-get install -y libmagickwand-dev
# web server and certbot
apt-get install -y nginx-full
apt-get install -y python3-certbot-nginx

# dependencies for rbenv to build ruby according to https://linuxize.com/post/how-to-install-ruby-on-ubuntu-20-04/
apt-get install -y git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev

# Ubuntu 20.04 has Ruby 2.7, Debian 10 has Ruby 2.5 which is still perfectly viable.
# apt-get install -y ruby ruby-dev 

string=$(uname -a)
if [[ $string == *"Debian"* ]]; then
	curl -sL https://deb.nodesource.com/setup_lts.x | bash -
	apt-get install -y nodejs
fi

# Using Ubuntu
if [[ $string == *"Ubuntu"* ]]; then
	curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
	sudo apt-get install -y nodejs
fi


