 function cx__change () {
    if [[ -n $alias ]]; then # not necessary args
        case $alias in
            # user want help about the `cx` command 
                "--help") cx__help_show cx
                exit 0;;
            # only an alias has been given
                * ) (
                    source "$errors_file_path"
                    cx__error_unknown_flag $alias
                )  
        esac
        return
    fi

    if [[ ! $(is_good_format $command) = "good" ]]; then
        (   
            source "$errors_file_path"
            cx__error_alias_not_found
        )
        return
    fi

    if [[ ! $(existant_name $command) = "yes" ]]; then
        (   
            source "$errors_file_path"
            cx__error_alias_not_found
        )
        return
    fi

    # alias found 
    cd "$(get_path $command)" 2> /dev/null # do not forget, in this case, command is the alias 
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


function is_good_format () {
    if [[ $1 =~ [^[:alnum:]_] ]]; then # there are non alpha numeric characters
        echo "bad"
    else
        echo "good"
    fi        
}