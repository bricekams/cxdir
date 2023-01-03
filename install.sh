#!/bin/bash
rm -rf ~/.cxdir
mkdir ~/.cxdir
rm saved.csv 2> /dev/null
touch saved.csv
echo "Date,Shortcut,Path" >> saved.csv
cp -r . ~/.cxdir
rm -rf ~/.cxdir/.git ~/.cxdir/.gitignore ~/.cxdir/install.sh
echo 'export PATH="$PATH":"$HOME/.cxdir"' >> ~/.bashrc
echo "alias cx='. cx'" >> ~/.bashrc
echo -e "\xE2\x9C\x94 installed, close and reopen the terminal. You are good!"