#!/bin/bash
echo "BOOSTRAP SCRIPT Debian/Ubuntu"
echo "The script you are running has basename `basename "$0"`, dirname `dirname "$0"`"
echo "The present working directory is `pwd`"


if [[ $USER != "root" ]]; then
	echo "you must run this as root"
	exit 1
fi

# web server and certbot
apt-get install -y nginx-full
apt-get install -y python3-certbot-nginx
apt-get install -y build-essential git curl autoconf bison

# build Nokogiri
apt-get install -y patch zlib1g-dev liblzma-dev
# build rmagick
apt-get install -y libmagickwand-dev
# use yet another PNG reading software since imagemagick sometimes can't convert
apt-get install -y pngquant
# cron, but for one-time jobs
apt-get install -y at

string=$(uname -a)
# you can force debian or ubuntu package names if you want.
# this is useful with WSL (at least WSL1) since uname doesn't return the distro name.
if [[ $string == *"Debian"* ]] | [[ $1 == "--debian" ]]; then
	curl -sL https://deb.nodesource.com/setup_lts.x | bash -
	apt-get install -y nodejs
	# dependencies for rbenv to build ruby on Debian https://linuxize.com/post/how-to-install-ruby-on-debian-10/
	apt-get install -y libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
fi

# Using Ubuntu
if [[ $string == *"Ubuntu"* ]] | [[ $1 == "--ubuntu" ]]; then
	curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
	sudo apt-get install -y nodejs
	# dependencies for rbenv to build ruby on Ubuntu according to https://linuxize.com/post/how-to-install-ruby-on-ubuntu-20-04/
	apt-get install -y libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev libdb-dev
fi


# echo "remember to put /scripts/usr_share_dbus1_system.conf >> into >> /usr/share/dbus-1/system.conf"
cp -a server_config/usr/* /usr/
cp ./scripts/calvinball_daemon.service /etc/systemd/system/calvinball_daemon.service
systemctl daemon-reload
echo "remember to activate later: systemctl start calvinball_daemon"
# activate it later
# systemctl start calvinball_daemon

cp -a server_config/etc/* /etc/

mkdir audio images resources
mkdir -p /var/www/html/calvinballconsortium
ln -s audio /var/www/html/calvinballconsortium/audio
ln -s images /var/www/html/calvinballconsortium/images
ln -s resources /var/www/html/calvinballconsortium/resources

