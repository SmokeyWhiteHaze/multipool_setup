#!/bin/bash
#########################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
# This script is intended to be ran from the multipool installer
#########################################################

if [ -z "$TAG" ]; then
	TAG=v1.00
fi

# Are we running as root?
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root. Did you leave out sudo?"
	exit
fi

# Clone the MultiPool repository if it doesn't exist.
if [ ! -d $HOME/multipool/yiimp_single ]; then
	if [ ! -f /usr/bin/git ]; then
		echo Installing git . . .
		apt-get -q -q update
		DEBIAN_FRONTEND=noninteractive apt-get -q -q install -y git < /dev/null
		echo
	fi

	echo Downloading MultiPool YiiMP Single Server Installer $TAG. . .
	git clone \
		-b $TAG --depth 1 \
		https://github.com/cryptopool-builders/multipool_yiimp_single.git \
		$HOME/multipool/yiimp_single \
		< /dev/null 2> /dev/null

	echo
fi

# Change directory to it.
cd $HOME/multipool

# Update it.
if [ "$TAG" != `git describe` ]; then
	echo Updating MultiPool YiiMP Single Server Installer to $TAG . . .
	git fetch --depth 1 --force --prune origin tag $TAG
	if ! git checkout -q $TAG; then
		echo "Update failed. Did you modify something in `pwd`?"
		exit
	fi
	echo
fi

# Start setup script.
cd $HOME/multipool/yiimp_single
start.sh
