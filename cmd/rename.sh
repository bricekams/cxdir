function cx__rename () {
    if [[ $args_number -gt 3 ]]; then
        (
            source "$errors_file_path"
            cx__error_unknow-arg ${args_array[3]}
        )
        exit 1
    fi    
    if [[ -z $alias ]]; then
        (
            source "$errors_file_path"
            cx__error_not_alias_rename
        )
        exit 1
    fi
    if [[ ! $(is_good_format $alias) = "good" ]];then
        case $alias in 
            "--help") show_help_rename
            exit 0;;
            * ) (
                source "$errors_file_path"
                cx__error_invalid_option $alias
            )
        esac
        exit 1
    fi
    if [[ ! $(existant $alias) = "yes" ]]; then
        (
            source "$errors_file_path"
            cx__error_alias_not_found
        )
        exit 1
    fi
    if [[ -z $new_alias ]]; then
        (
            source "$errors_file_path"
            cx__error_new_alias_not_provided 
        )
        exit 1
    fi
    if [[ ! $(is_good_format $new_alias) = "good" ]]; then
        (
            source "$errors_file_path"
            msg="The new shortcut name must only content alphanumeric characters"
            cx__error_bad_format "$msg"
        )
        exit 1
    fi    
    if [[ $(existant $new_alias) = "yes" ]]; then
        (
            source "$errors_file_path"
            cx__error_shortcut_already_exist
        )
        exit 1;
    fi
    cx__rename_process $alias $new_alias
    echo -e "\xE2\x9C\x94 done!"
    echo -e "cx: Shortcut renamed, use$cyan cx $new_alias""$defaultColor"                                    
}

function cx__rename_process () {
    tmp_1=$(echo "$1 \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g") # transform: remove all non alnum char in the given string
    length_1=$(echo -n $tmp_1 | wc -m) # the length of the given string after been transformed
    shortcuts=($(awk -F "\"*,\"*" '{print $2}' $csv_file_path))
    new_alias=$2
    paths=($(awk -F "\"*,\"*" '{print $3}' $csv_file_path))
    for i in ${!shortcuts[@]}; do
        # bash arrays are 0-indexed
        tmp_2=$(echo "${shortcuts[$i]} \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g") # assign a transformed value of i to tmp_2
        length_2=$(echo -n $tmp_2 | wc -m) # the length of  tmp_2
        if [[ "$tmp_1" == *$tmp_2* && $length_1 -eq $length_2  ]]; then # exist in the file
            line=$(($i+1))
            path=${paths[$i]}
            sed -i "${line}d" $csv_file_path
            echo "$(date "+%F"),$2,$path" >> $csv_file_path
            break
        fi
    done
}


function existant () {
    tmp_1=$(echo "$1 \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g") # transform: remove all non alnum char in the given string
    length_1=$(echo -n $tmp_1 | wc -m) # the length of the given string after been transformed
    paths=$(awk -F "\"*,\"*" '{print $2}' $csv_file_path) # assign all the value of the third column of saved.csv to paths
    for i in $paths; do
        tmp_2=$(echo "$i \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g") # assign a transformed value of i to tmp_2
        length_2=$(echo -n $tmp_2 | wc -m) # the length of  tmp_2
        if [[ "$tmp_1" == *$tmp_2* && $length_1 -eq $length_2  ]]; then # exist in the file
            echo "yes" 
            break
        fi    
    done             
}


function is_good_format () {
    if [[ $1 =~ [^[:alnum:]_] ]]; then # there are non alpha numeric characters
        echo "bad"
    else
        echo "good"
    fi        
}


function show_help_rename () {
    echo ""
    echo $cyan"NAME:"$defaultColor
    echo -e "\t cx rename - rename a shortcut"
    echo ""
    echo $cyan"DESCRIPTION:"$defaultColor
    echo -e "\t Use this command to rename a shortcut."
    echo ""
    echo $cyan"USAGE:"$defaultColor
    echo -e "\t cx rename <old_name> <the_new>"
    echo ""
}