# CXDIR 
### Simple shortcut manager

I made this tool to save time when working. now instead of using `cd a/very/long/path`, i can use <br/>
`cx shortcut` and quickly change my current directory to another one based on the path pointed by this shortcut.

It's a [zoxide](https://github.com/ajeetdsouza/zoxide) like tool made in bash-scripting

If there is something that i can guarantee, it's that: It works on my computer **(Ubuntu)** 
Please try on you environement and let's improve it

### Installation 

1. clone this repo <br/>
`git clone https://github.com/jotterkain/cxdir` <br/>
or using Github CLI <br/>
`gh repo clone jotterkain/cxdir`
2. inside the root of the project, execute: <br/>
`. install.sh` <br/>


You're good!!

### How does it work ?

### . create a new shortcut 

`cx create`: If you want to create a shortcut with the current directory name and the current path

`cx create <alias>`: If you want to create a shortcut with the given alias and the  current path

`cx create <alias> -p <a_path>`: If you want to create a shortcut with the given alias and the given path

Important: the name of shortcuts must only use alphanumeric characters

### . rename a shortcut
to rename a shortcut 

`cx rename <old_name> <new_name>`

### . update a shortcut
To update the path of a shortcut

`cx update` 

### . list
To list all the saved shortcuts

`cx list`

### . delete a shortcut 

`cx delete <alias>`: If you want to delete the given shortcut

`cx delete --all`: If you want to delete all the shortcut... be careful!

### . help

`cx --help`: General

`cx <command> --help`: specific command


### CONTRIBUTION

You just have to clone this project as show above and make a pull request


### Credits

Made by me, Jotter Kain...<br/>
Twitter [jotterkn](https://twitter.com/jotterkn)




