#!/bin/bash

if [[ $USER == "root" ]]; then
	echo "you must run this as user"
	exit 1
fi

if [[ $(cat $HOME/.bashrc | grep "rbenv") == "" ]]; then
	echo "PATH=\"\$PATH:\$HOME/.rbenv/bin:\$HOME/.rbenv/shims\"" >> $HOME/.bashrc
fi

source $HOME/.bashrc
wget https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer
chmod +x rbenv-installer
PATH="$PATH:$HOME/.rbenv/bin:$HOME/.rbenv/shims"
./rbenv-installer
rm ./rbenv-installer
rbenv install 3.0.0
rbenv global 3.0.0
git clone git://github.com/jf/rbenv-gemset.git $HOME/.rbenv/plugins/rbenv-gemset
rbenv gemset init calvinballconsortium

if [ -z ${GEM_HOME} ]; then 
	echo "GEM_HOME=\$(ls -t -U | ruby -e 'puts Gem.user_dir')" >> $HOME/.bashrc
	echo "GEM_PATH=\$GEM_HOME" >> $HOME/.bashrc
	echo "PATH=\$PATH:\$GEM_HOME/bin" >> $HOME/.bashrc
	source $HOME/.bashrc
fi

# Ruby and npm installed, normally
npm install
bundle install

