#!/bin/bash
mkdir ~/.cxdir
touch saved.csv
echo "Date,Shortcut,Path" >> saved.csv
cp -r . ~/.cxdir
rm -rf ~/.cxdir/.git ~/.cxdir/.gitignore
echo 'export PATH="$PATH":"$HOME/.cxdir"' >> ~/.bashrc
exit 0
