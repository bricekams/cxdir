# More than 2 args to the pathx command when using `pathx create`
function pathx_create_error_1() {
    echo -e $red"Error:"$defaultColor \"${args_array[2]}\" "is an invalid argument"
    echo -e $blue"Tips:"$defaultColor "Use"$cyan "pathx create [shortcut name]"$defaultColor "to create a new shortcut pointing to the current directory"
}

function pathx_unknow_args () {
    echo "Error:" "\"$1\"" "is invalid" 
}