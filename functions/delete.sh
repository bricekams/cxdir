function cx__delete () {
    if [[ -n $alias && $(is_good_format $alias) = "good" ]]; then
        cx__delete_process $alias
    elif [[ -n $alias ]] && [[ ! $(is_good_format $alias) = "good" ]]; then 
        case $alias in
            "--help") cx__help_show delete;;
            "--all") cx__delete_all_process;;
            * ) (
                source "$errors_file_path"
                cx__error_invalid_option $alias
            );;
        esac
    else
        (
            source "$errors_file_path"
            cx__error_alias_not_provided
        )
    fi                        
}

function cx__delete_process () {
    tmp_1=$(echo "$1 \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g") # transform: remove all non alnum char in the given string
    length_1=$(echo -n $tmp_1 | wc -m) # the length of the given string after been transformed
    shortcuts=($(awk -F "\"*,\"*" '{print $2}' $csv_file_path))
    for i in ${!shortcuts[@]}; do
        tmp_2=$(echo "${shortcuts[$i]} \!\@\#$%^&*" | sed "s/[^[:alnum:]-]//g") # assign a transformed value of i to tmp_2
        length_2=$(echo -n $tmp_2 | wc -m) # the length of  tmp_2
        if [[ "$tmp_1" == *$tmp_2* && $length_1 -eq $length_2  ]]; then # exist in the file
            line=$(($i+1)) # line index
            sed -i "${line}d" $csv_file_path # delete that line
            echo -e "\xE2\x9C\x94 done!"
            exit 0;
            break
        fi
    done
    (
        source "$errors_file_path"
        cx__error_alias_not_found
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