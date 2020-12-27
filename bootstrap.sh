#!/bin/sh
echo "BOOSTRAP SCRIPT Debian/Ubuntu"
echo "The script you are running has basename `basename "$0"`, dirname `dirname "$0"`"
echo "The present working directory is `pwd`"

apt-get install -y build-essential git patch zlib1g-dev liblzma-dev
apt-get install -y libmagickwand-dev
apt-get install -y nginx-full
apt-get install -y python3-certbot-nginx

string=$(uname -a)
if [[ $string == *"Debian"* ]]; then
	curl -sL https://deb.nodesource.com/setup_current.x | bash -
	apt-get install -y nodejs
fi

# Using Ubuntu
if [[ $string == *"Ubuntu"* ]]; then
	curl -sL https://deb.nodesource.com/setup_current.x | sudo -E bash -
	sudo apt-get install -y nodejs
fi


## install RBENV, but you could use system Ruby instead...
# echo "PATH=\$PATH:\$HOME/.rbenv/bin:\$HOME/.rbenv/shims" >> $HOME/.bashrc
# source $HOME/.bashrc
# curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash

apt-get install -y rbenv
rbenv install 2.7.2
if [ -z ${GEM_HOME+x} ]; then 
	echo "GEM_HOME=\$(ls -t -U | ruby -e 'puts Gem.user_dir')" >> $HOME/.bashrc
	echo "GEM_PATH=\$GEM_HOME" >> $HOME/.bashrc
	echo "PATH=\$PATH:\$GEM_HOME/bin" >> $HOME/.bashrc
	source $HOME/.bashrc
fi
git clone git://github.com/jf/rbenv-gemset.git $HOME/.rbenv/plugins/rbenv-gemset
rbenv gemset init calvinballconsortium

# Ruby and npm installed, normally
npm install
gem install bundler
bundle install

