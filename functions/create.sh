function cx__create () {
    # if args number > 2
    if [[ $args_number -gt 2 ]]; then
        case $option in
        # user want to give a specific path 
            "-p" | "--path") if [[ -n $path ]]; then # path provided
                    cx__create__process $alias $(cd $path 2> /dev/null && pwd)
                else # path ommited 
                    (
                        source "$errors_file_path"
                        cx__error_path_not_provided
                    )
                fi;;    
        # all others     
            * ) (
                source "$errors_file_path"
                cx__error_invalid_option $option
            );;
        esac
    # then if args number < 2        
    elif [[ -n $alias ]]; then
        case $alias in
        # user want help about the `cx create` command 
            "--help") cx__help_show create;;
        # only an alias has been given
            * ) cx__create__process $alias $(pwd);; # (regex to validate the given string)    
        esac    
    else # `cx create` command without alias and any option
        cx__create__process $(basename $(pwd)) $(pwd) 
    fi           
}

# insert row in saved.csv
function cx__create__process() {
    if [[ ! $(is_good_format $1) = "good" ]]; then
        if [[ -z $alias ]]; then # alias not given
            (
                source "$errors_file_path"
                msg="You must give an alias using the [-p] option since the current directory's name has an invalid format (non alphanumeric character(s))"
                cx__error_bad_format "$msg"
            )
            exit 1  
        fi
        (
            source "$errors_file_path"
            msg="The shortcut name must only content alphanumeric characters"
            cx__error_bad_format "$msg"
        )
        exit 1
    fi    
    if [[ -d $2 && -n $2 ]] && [[ ! $(exitant $2) = "yes" ]]; then # $path exist

        echo "$(date "+%F"),$1,$2" >> $csv_file_path
        echo -e "\xE2\x9C\x94 done!"
        echo -e "cx: Use$cyan cx $1""$defaultColor"

    elif [[ ! -d $2 && -z $2 ]]; then # path does not exist
        (
            source "$errors_file_path"
            cx__error_dir_inexistant
        )
    elif [[ $(exitant $2) = "yes" ]]; then
        (
            source "$errors_file_path"
            cx__path_already_exist
        )     
    else
        echo ""       
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