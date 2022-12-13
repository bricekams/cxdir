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
path=$4
# var: array of args 
declare -a args_array=("$@")




########## CORE FUNCTIONS ##########

# This is more like an entry function.
function pathx__main () {
    
    # if has params
    if [[ $(pathx__hasParams) = "true" ]]; then
        case $command in
        # user want to [create] a new shortcut
            "create") pathx__create_main;;
        # user want to [delete] a shortcut    
            "delete") pathx__delete_main;;
        # user want to [rename] a shortcut    
            "rename") pathx__rename_main;;
        # user want to [update] the path asigned to a shortcut    
            "update") pathx__update_main;;
        # user want to [list] all shortcuts    
            "list") pathx__list_main;;
        # user want help about the `pathx` command    
            "--help") pathx__help_show;;
        # user want to use [pathx] to change dir        
            * ) (
                source ./errors.sh
                pathx__error_unknow-command
            );;
        esac
    # if no params            
    else
        (
            source ./errors.sh
            pathx__error_no_command
        );
    fi            
}

# entry function to create a new shortcut
function pathx__create_main () {
    # if args number > 2
    if [[ $args_number -gt 2 ]]; then
        case $option in
        # user want to give a specific path 
            "-p" | "--path") if [[ -n $path ]]; then # path provided
                    pathx__create $alias $path
                else # path ommited 
                    (
                        source ./errors.sh
                        pathx__error_path_not_provided
                    )
                fi;;    
        # all others     
            * ) (
                source ./errors.sh
                pathx__error_unknow-arg $option
            );;
        esac
    # then if args number < 2        
    elif [[ -n $alias ]]; then
        case $alias in
        # user want help about the `pathx create` command 
            "--help") pathx__help_show create;;
        # an alias has been given
            * ) pathx__create $alias $path;; # (regex to validate the given string)    
        esac    
    else # `pathx create` command without alias and any option
        echo pathx__create $alias $path
    fi           
}

function pathx__delete_main () { 
    echo ""
}

function pathx__rename_main () { 
    echo "" 
}

function pathx__update_main () {
    echo "" 
}

function pathx__list_main () { 
    echo "" 
}

function pathx__help_show () { 
    echo "" 
}

function pathx__change_dir () {
     echo ""
}


########## UTILS AND HELPERS ##########

function pathx__hasParams() {
    if [[ $args_number -gt 0 ]]; then
    # if no args
        echo "true"
    else
    # if args found
        echo "false"
    fi 
}

function pathx__create() { 
    
}

pathx__main