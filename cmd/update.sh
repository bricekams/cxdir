function cx__update ()  {
    if [[ -n $alias ]]; then 
        case $alias in
            # user want help about the `cx update` command 
                "--help") show_help_update
                exit 0;;
            # only an alias has been given
                * ) (
                    source "$errors_file_path"
                    cx__error_unknown_flag $alias
                )
                exit 1;;  
        esac
    fi    

    echo "You want to update the path of a shortcut"
    echo -n "Enter the shortcut name: "
    read shortcut_name

    if [[ ! $(is_good_format $shortcut_name) = "good" ]]; then 
        (   
            source "$errors_file_path"
            cx__error_alias_not_found
        )
        exit 1
    fi

    # the given alias has good format, next

    if [[ ! $(existant_name $shortcut_name) = "yes" ]]; then
        (
            source "$errors_file_path"
            cx__error_alias_not_found
        )
        exit 1
    fi

    # the given alias exist, next

    echo -e "The current path is:" $cyan$(get_path $shortcut_name)$defaultColor
    echo -n "Enter the new path: "
    read new_path

    if [[ $(existant_path $new_path) = "yes" ]]; then   
        (
            source "$errors_file_path"
            cx__error_path_already_exist
        )
        exit 1
    fi     

    # path not found, next


    echo "$(date "+%F"),$shortcut_name,$(cd $path 2> /dev/null && pwd)" >> $csv_file_path # save with new path
    cx__delete_process $shortcut_name # delete line 
    exit 0
}


# check if the shortcut name has correct fomart
function is_good_format () {
    if [[ $1 =~ [^[:alnum:]_] ]]; then # there are non alpha numeric characters
        echo "bad"
    else
        echo "good"
    fi        
}

function existant_path () {
    tmp_1=$(echo "$1 \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g") # transform: remove all non alnum char in the given string
    length_1=$(echo -n $tmp_1 | wc -m) # the length of the given string after been transformed
    paths=$(awk -F "\"*,\"*" '{print $3}' $csv_file_path) # assign all the value of the third column of saved.csv to paths
    for i in $paths; do
        tmp_2=$(echo "$i \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g") # assign a transformed value of i to tmp_2
        length_2=$(echo -n $tmp_2 | wc -m) # the length of  tmp_2
        if [[ "$tmp_1" == *$tmp_2* && $length_1 -eq $length_2  ]]; then # exist in the file
            echo "yes"
            break
        fi    
    done             
}

function existant_name () {
    tmp_1=$(echo "$1 \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g") # transform: remove all non alnum char in the given string
    length_1=$(echo -n $tmp_1 | wc -m) # the length of the given string after been transformed
    shortcuts=$(awk -F "\"*,\"*" '{print $2}' $csv_file_path) # assign all the value of the second column of saved.csv to shortcuts
    for i in $shortcuts; do
        tmp_2=$(echo "$i \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g") # assign a transformed value of i to tmp_2
        length_2=$(echo -n $tmp_2 | wc -m) # the length of  tmp_2
        if [[ "$tmp_1" == *$tmp_2* && $length_1 -eq $length_2  ]]; then # exist in the file
            echo "yes"
            break
        fi    
    done             
}

function get_path () {
    tmp_1=$(echo "$1 \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g") # transform: remove all non alnum char in the given string
    length_1=$(echo -n $tmp_1 | wc -m) # the length of the given string after been transformed
    paths=($(awk -F "\"*,\"*" '{print $3}' $csv_file_path)) # assign all the value of the third column of saved.csv to paths
    shortcuts=($(awk -F "\"*,\"*" '{print $2}' $csv_file_path)) # assign all the value of the second column of saved.csv to shortcuts
    for i in ${!shortcuts[@]}; do
        tmp_2=$(echo "${shortcuts[$i]} \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g") # assign a transformed value of i to tmp_2
        length_2=$(echo -n $tmp_2 | wc -m) # the length of  tmp_2
        if [[ "$tmp_1" == *$tmp_2* && $length_1 -eq $length_2  ]]; then # exist in the file
            echo "${paths[$i]}"
            break
        fi    
    done 
}


function cx__delete_process () {
    tmp_1=$(echo "$1 \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g") # transform: remove all non alnum char in the given string
    length_1=$(echo -n $tmp_1 | wc -m) # the length of the given string after been transformed
    shortcuts=($(awk -F "\"*,\"*" '{print $2}' $csv_file_path))
    for i in ${!shortcuts[@]}; do
        tmp_2=$(echo "${shortcuts[$i]} \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g") # assign a transformed value of i to tmp_2
        length_2=$(echo -n $tmp_2 | wc -m) # the length of  tmp_2
        if [[ "$tmp_1" == *$tmp_2* && $length_1 -eq $length_2  ]]; then # alias exist in the file
            line=$(($i+1)) # line index
            sed -i "${line}d" $csv_file_path # delete that line
            echo -e "\xE2\x9C\x94 done!" # echo sucess
            exit 0; 
            break
        fi
    done
    ( # alias not found
        source "$errors_file_path"
        cx__error_alias_not_found
        exit 12
    )
}

function show_help_update () {
    echo ""
    echo $cyan"NAME:"$defaultColor
    echo -e "\t cx update - update the path of a shortcut"
    echo ""
    echo $cyan"DESCRIPTION:"$defaultColor
    echo -e "\t update the path of a shortcut"
    echo ""
    echo $cyan"USAGE:"$defaultColor
    echo -e "\t cx update"
    echo ""
}