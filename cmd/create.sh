function cx__create () { 
    if [[ -z $alias ]]; then
        dirname=$(basename $(pwd))
        if [[ ! $(is_good_format $dirname) = "good" ]]; then
            (
                source "$errors_file_path"
                msg="You must give an alias using the [-p] option since the current directory's name has an invalid format (non alphanumeric character(s))"
                cx__error_bad_format "$msg"
            )
            exit 1
        fi
        if [[ $(existant_path $(pwd)) = "yes" ]]; then 
            (
                source "$errors_file_path"
                cx__error_path_already_exist
            )
            exit 1
        fi
        save $dirname $(pwd) # save with the dir basename and the current path
        exit 0
    fi

    # if here $alias has been given

    if [[ ! $(is_good_format $alias) = "good" ]]; then
        case $alias in
        # user want help about the `cx create` command 
            "--help") show_help_create
            exit 0;;
        # only an alias has been given
            * ) (
                source "$errors_file_path"
                msg="You must not use non-alphanumeric characters"
                cx__error_bad_format "$msg"
            )
            exit 1;;  
        esac
        exit 0
    fi

    if [ $alias = "list" ] || [ $alias = "create" ] || [ $alias = "uninstall" ] || [ $alias = "delete" ] || [ $alias = "update" ] || [ $alias = "rename" ]; then
        (
            source "$errors_file_path"
            cx__create_error_name
        )
        exit 1
    fi   

    # if here $alias has good format 

    if [[ -z $option ]]; then
        if [[ $(existant_name $alias) = "yes"  ]]; then 
            (
                source "$errors_file_path"
                cx__error_shortcut_already_exist
            )
            exit 1  
        fi

        # alias not found 

        if  [[ $(existant_path $(pwd)) = "yes"  ]]; then
            (
                source "$errors_file_path"
                cx__error_path_already_exist
            )
            exit 1
        fi 

        # path not found 

        save $alias $(pwd) # save with the given alias and the current path
        exit 0
    fi

    # $3 given

   case $option in
        # user want to give a specific path 
            "-p" | "--path") if [[ -n $path ]]; then # path provided

                                if [[ $args_number -gt 4 ]]; then 
                                    (
                                        source "$errors_file_path"
                                        cx__error_unknow-arg ${args_array[4]}
                                    )
                                    exit 1 
                                fi

                                if [[ $(existant_name $alias) = "yes"  ]]; then 
                                    (
                                        source "$errors_file_path"
                                        cx__error_shortcut_already_exist
                                    )
                                    exit 1  
                                fi

                                # alias not found

                                if [[ ! -d $path ]]; then
                                    (
                                        source "$errors_file_path"
                                        cx__error_dir_inexistant
                                    )
                                    exit 1
                                fi
                            
                                # dir exist         

                                if  [[ $(existant_path $path) = "yes"  ]]; then
                                    (
                                        source "$errors_file_path"
                                        cx__error_path_already_exist
                                    )
                                     exit 1
                                fi 

                                # path not found 

                                save $alias $(cd $path 2> /dev/null && pwd) # save with the given alias and the given path
                                exit 0
                            else # path ommited 
                                (
                                    source "$errors_file_path"
                                    cx__error_path_not_provided
                                )
                                exit 1
                            fi;;    
        # all others     
            * ) (
                source "$errors_file_path"
                cx__error_invalid_option $option
            );;
    esac  
}       

# insert row in saved.csv
function save() {
    echo "$(date "+%F"),$1,$2" >> $csv_file_path
    echo -e "\xE2\x9C\x94 done!"
    echo -e "cx: Use$cyan cx $1""$defaultColor"
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

function show_help_create () {
    echo ""
    echo $cyan"NAME:"$defaultColor
    echo -e "\t cx create - create a new shortcut"
    echo ""
    echo $cyan"DESCRIPTION:"$defaultColor
    echo -e "\t Use this command to create a new shortcut so that you can use 'cx <shortcut name>' to quickly change your current directory"
    echo ""
    echo $cyan"USAGE:"$defaultColor
    echo -e "\t cx create: will create a shortcut whit the current directory name (if valid = alphanumeric charcaters) and the current directory path."
    echo ""
    echo -e "\t cx create [<alias>]: will create a shortcut with the given alias as name and the current path."
    echo ""
    echo -e "\t cx create <alias> -p 'a_path': will create a shortcut with the given alias as name and the given path."
    echo ""
}