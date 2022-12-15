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

## path ##

# path of saved shortcuts files
# to change
csv_file_path="/home/bricekk/projects/sh/path_manager/saved.csv"
# path of errors file
errors_file_path="/home/bricekk/projects/sh/path_manager/errors.sh" 



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
                source "$errors_file_path"
                pathx__error_unknow-command
            );;
        esac
    # if no params            
    else
        (
            source "$errors_file_path"
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
                    pathx__create $alias $(cd $path 2> /dev/null && pwd)
                else # path ommited 
                    (
                        source "$errors_file_path"
                        pathx__error_path_not_provided
                    )
                fi;;    
        # all others     
            * ) (
                source "$errors_file_path"
                pathx__error_invalid_option $option
            );;
        esac
    # then if args number < 2        
    elif [[ -n $alias ]]; then
        case $alias in
        # user want help about the `pathx create` command 
            "--help") pathx__help_show create;;
        # only an alias has been given
            * ) pathx__create $alias $(pwd);; # (regex to validate the given string)    
        esac    
    else # `pathx create` command without alias and any option
        pathx__create $(basename $(pwd)) $(pwd) 
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
    if [[ $args_number -gt 0 ]]; then # no args
        echo "true"
    else # args found
        echo "false"
    fi 
}

# insert row in saved.csv
function pathx__create() { 
    if [[ $(is_good_format $1) = "good" ]] && [[ -d $2 && -n $2 ]] && [[ ! $(exitant $2) = "yes" ]]; then # good format and $path exist

        echo "$(date "+%F"),$1,$2" >> $csv_file_path

    elif [[ ! -d $2 && -z $2 ]]; then # path does not exist
        (
            source "$errors_file_path"
            pathx__error_dir_inexistant
        )
    elif [[ $(exitant $2) = "yes" ]]; then
        (
            source "$errors_file_path"
            pathx__path_already_exist
        )     
    else # bad format
        if [[ -n $alias ]]; then # alias given
            (
                source "$errors_file_path"
                msg="The shortcut name must only content alphanumeric characters"
                pathx__error_bad_format "$msg"
            )
        else # alias not given
            (
                source "$errors_file_path"
                msg="You must give an alias using the [-p] option since the current directory's name has an invalid format (non alphanumeric character(s))"
                pathx__error_bad_format "$msg"
            )    
        fi       
    fi         
}

# check if the shortcut name has correct fomart
function is_good_format () {
    if [[ $1 =~ [^[:alnum:]_] ]]; then # there are non alpha numeric characters
        echo "bad"
    else
        echo "good"
    fi        
}

function exitant () {
    tmp_1=$(echo "$1 \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g")
    paths=$(awk -F "\"*,\"*" '{print $3}' /home/bricekk/projects/sh/path_manager/saved.csv)
    length_1=$(echo -n $tmp_1 | wc -m)
    for i in $paths; do
        tmp_2=$(echo "$i \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g")
        length_2=$(echo -n $tmp_2 | wc -m)
        if [[ "$tmp_1" == *$tmp_2* && $length_1 -eq $length_2  ]]; then
            echo "yes"
            break
        fi    
    done             
}


pathx__main