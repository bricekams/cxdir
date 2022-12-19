#!/bin/bash
rm -rf ~/.cxdir
mkdir ~/.cxdir
touch saved.csv
echo "Date,Shortcut,Path" >> saved.csv
cp -r . ~/.cxdir
rm -rf ~/.cxdir/.git ~/.cxdir/.gitignore ~/.cxdir/install.sh
echo 'export PATH="$PATH":"$HOME/.cxdir"' >> ~/.bashrc
echo "alias cx='. cx'" >> ~/.bashrc
exit 0