function cx__delete () {
    if [[ $args_number -gt 2 ]]; then # unecessary arg at the end...
        (
            source "$errors_file_path"
            cx__error_unknow-arg ${args_array[2]}
            see_help_i_delete
        )
    else
        if [[ -n $alias && $(is_good_format $alias) = "good" ]]; then # alias exist and fromat good
            cx__delete_process $alias
        elif [[ -n $alias ]] && [[ ! $(is_good_format $alias) = "good" ]]; then # alias exist and format bad
            case $alias in
                "--help") show_help_delete
                exit 0;;
                "--all") cx__delete_all_process;;
                * ) ( # unknow option
                    source "$errors_file_path"
                    cx__error_alias_not_found $alias
                    see_help_i_delete
                );;
            esac
        else # alias does'nt exist
            (
                source "$errors_file_path"
                cx__error_alias_not_provided
            )  
        fi
    fi                      
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

function cx__delete_all_process () {
    shortcuts=($(awk -F "\"*,\"*" '{print $2}' $csv_file_path))
    for i in ${!shortcuts[@]}; do
        sed -i "2d" $csv_file_path # for each itteration delete de second line to not delete the headers
    done
    echo -e "\xE2\x9C\x94 done!"
}

function is_good_format () {
    if [[ $1 =~ [^[:alnum:]_] ]]; then # there are non alpha numeric characters
        echo "bad"
    else
        echo "good"
    fi        
}

function show_help_delete () {
    echo ""
    echo $cyan"NAME:"$defaultColor
    echo -e "\t cx delete - delete a shortcut"
    echo ""
    echo $cyan"DESCRIPTION:"$defaultColor
    echo -e "\t Use this command to delete a shortcut or more"
    echo ""
    echo $cyan"USAGE:"$defaultColor
    echo -e "\t cx delete <shortcut_name>: will delete the shortcut with the given name"
    echo ""
    echo -e "\t cx delete --all: will delete all the saved shortcut, be carefull"
    echo ""
}