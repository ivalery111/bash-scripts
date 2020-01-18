#!/bin/bash
:'
Before you start using this script, you need to set:
	APP_PWD 	with YOUR application password!
	REAL_NAME 	with YOUR first_name second_name
	GMAIL_USERNAME 	with YOUR email
'

VIMRC=~/.vimrc
MUTTRC=~/.muttrc
GITCONFIG=~/.gitconfig
REAL_NAME='Valery Ivanov'
GMAIL_USERNAME='ivalery111@gmail.com'
APP_PWD='????????'


function config_git(){

echo "[user]" >> $GITCONFIG
echo -e "\tname = $REAL_NAME" >> $GITCONFIG
echo -e "\temail = $GMAIL_USERNAME" >> $GITCONFIG
}

function config_vimrc(){

echo "filetype plugin indent on" >> $VIMRC
echo "syn on se title" >> $VIMRC
echo "set tabstop=8" >> $VIMRC
echo "set softtabstop=8" >> $VIMRC
echo "set shiftwidth=8" >> $VIMRC
echo "set noexpandtab" >> $VIMRC

sudo update-alternatives --config editor
}

function config_muttrc(){

echo "set realname = \"${REAL_NAME}\"" >> $MUTTRC
echo "set from = \"${GMAIL_USERNAME}\"" >> $MUTTRC
echo "set use_from = yes" >> $MUTTRC
echo "set envelope_from = yes" >> $MUTTRC

echo "set smtp_url = \"smtps://${GMAIL_USERNAME}@smtp.gmail.com:465/\"" >> $MUTTRC
echo "set smtp_pass = \"${APP_PWD}\"" >> $MUTTRC
echo "set imap_user = \"${GMAIL_USERNAME}\"" >> $MUTTRC
echo "set imap_pass = \"${APP_PWD}\"" >> $MUTTRC
echo "set folder = \"imaps://imap.gmail.com:993\"" >> $MUTTRC
echo "set spoolfile = \"+INBOX\"" >> $MUTTRC
echo "set ssl_force_tls = yes" >> $MUTTRC


echo "set editor = \"vim\"" >> $MUTTRC
echo "set charset = \"utf-8\"" >> $MUTTRC
echo "set record = ''" >> $MUTTRC
}

function if_installed(){

dpkg -s $1 &> /dev/null

if [ $? -eq 0 ]; then
	echo "Package $1 installed!"
else
	echo "Package $1 is NOT installed!"
	echo -e "\tTry to install the $1"
	install_package $1
fi
}

function install_package(){

sudo apt update
sudo apt-get install $1 -y
if [ $? -eq 0 ]; then
	echo "Package $1 was installed!"
	if [[ $1 == "ssh" ]]; then
		echo "After ssh installing need to reboot the PC!"
		reboot
	fi
else
	echo "CANNOT install $1!"
fi
}

function reboot(){

echo 'Reboot? (y/n)'
read answer
if [[ $answer == "y" ]]; then
	/sbin/reboot
fi
}


echo "Checks if all important packages were already installed..."

: '
Important packages for linux kernel development
'

if_installed build-essential
if_installed screen
if_installed ssh
if_installed vim
if_installed libncurses5-dev
if_installed gcc
if_installed make
if_installed git
if_installed exuberant-ctags
if_installed libssl-dev
if_installed bison 
if_installed flex
if_installed libelf-dev
if_installed bc
if_installed mutt


echo "Configuring the vim"
config_vimrc
echo "Configuring the mutt"
config_muttrc
echo "Configuring the git"
config_git
echo "All Done!"




