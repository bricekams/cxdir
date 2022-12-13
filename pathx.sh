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
# var: argumenta
first_argument=$1
second_argument=$2
third_argument=$3
fourth_argument=$4
# var: array of args 
declare -a args_array=("$@")




########## CORE FUNCTIONS ##########

# This is more like an entry command.
function pathx__command() {
    if [[ $pathx__hasParams="true" ]]; then
    # has params
        case $first_argument in
        # user want to create a new shortcut
            "create") pathx__create;;
        esac        
    else
    # no params
        echo "no params"
    fi            
}

function pathx__create () {
    if [[ $args_number -gt 2 ]]; then
    # if args number > 2
        case $third_argument in
        # user want to give a specific path 
            "-p" | "--path") echo "the given path will be saved with name $second_argument";;
        # all others     
            * ) (
                source ./errors.sh
                pathx_unknow_args $third_argument
            );;
        esac    
    else
        echo "created"
    fi        
}




########## UTILS AND HELPERS ##########

function pathx__hasParams() {
    if [[ $args_number  -eq 0 ]]; then
    # if no args
        echo "true"
    else
    # if args found
        echo "false"
    fi 
}


pathx__command