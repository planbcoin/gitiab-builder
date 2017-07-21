ssh 192.168.1.2 "PATH=$PATH:/usr/local/bin/; . ~/.bash_profile; cd ~/code/gitian-builder; git pull --no-edit; ./r ${1:-osx}"
rm ~/Downloads/planbcoin*.dmg ~/Downloads/planbcoin*.tar.gz
scp 192.168.1.2:~/Downloads/planbcoin*.dmg ~/Downloads
scp 192.168.1.2:~/Downloads/planbcoin*.tar.gz ~/Downloads
