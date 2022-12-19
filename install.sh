#!/bin/bash
mkdir ~/.cxdir
rm -rf .git .gitignore
touch saved.csv
echo "Date,Shortcut,Path" >> saved.csv
cp -r . ~/.cxdir
echo 'export PATH="$PATH":"$HOME/.cxdir"' >> ~/.bashrc
exit 0
