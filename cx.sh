#!/bin/bash

########## COLORS ##########

defaultColor='\033[0m'
red='\033[0;31m'
cyan='\033[0;36m' 
blue='\033[0;34m'


########## GLOBAL VARIABLES ##########

# var: number of arguments passed
args_number=$#
# var: list of passed arguments
args=$*
# var: arguments
command=$1
alias=$2
option=$3
new_alias=$3
path=$4
# var: array of args 
declare -a args_array=("$@")

## path ##

# path of saved shortcuts files
cx_path="$HOME/projects/sh/cxdir"
# to change
csv_file_path="$cx_path/saved.csv"
# path of errors file
errors_file_path="$cx_path/errors.sh" 
# cmd path
list_file_path="$cx_path/cmd/list.sh"
create_file_path="$cx_path/cmd/create.sh"
delete_file_path="$cx_path/cmd/delete.sh"
rename_file_path="$cx_path/cmd/rename.sh"
update_file_path="$cx_path/cmd/update.sh"


########## CORE FUNCTIONS ##########

# This is more like an entry function.
function cx__main () {
    
    # if has params
    if [[ $(cx__hasParams) = "true" ]]; then
        case $command in
        # user want to [create] a new shortcut
            "create") cx__create_main;;
        # user want to [delete] a shortcut    
            "delete") cx__delete_main;;
        # user want to [rename] a shortcut    
            "rename") cx__rename_main;;
        # user want to [update] the path asigned to a shortcut    
            "update") cx__update_main;;
        # user want to [list] all shortcuts    
            "list") cx__list_main;;
        # user want help about the `cx` command    
            "--help") cx__help_show;;
        # user want to use [cx] to change dir        
            * ) cx__change_dir;;
        esac
    # if no params            
    else
        (
            source "$errors_file_path"
            cx__error_no_command $command
        );
    fi            
}

# entry function to create a new shortcut
function cx__create_main () {
   (
        source $create_file_path
        cx__create
   )
}

function cx__delete_main () { 
    (
        source $delete_file_path
        cx__delete
    )
}

function cx__rename_main () { 
    (
        source $rename_file_path
        cx__rename
    )
}

function cx__update_main () {
    (
        source $update_file_path
        cx__update
    )
}

function cx__list_main () { 
    (
        source $list_file_path
        cx__list ',' "$(cat $csv_file_path)" "false" "true"
    ) 
}

function cx__help_show () { 
    echo $1 
}

function cx__change_dir () {
     echo "change dir"
}


########## UTILS AND HELPERS ##########

function cx__hasParams() {
    if [[ $args_number -gt 0 ]]; then # no args
        echo "true"
    else # args found
        echo "false"
    fi 
}




cx__main