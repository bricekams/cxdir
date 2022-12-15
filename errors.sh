function cx__error_unknow-arg () {
    echo -e $red"cx:"$defaultColor "\"$1\"" "is invalid"
}

function cx__error_invalid_option () {
    echo -e $red"cx:"$defaultColor "\"$1\"" "is an invalid option"
}

function cx__error_path_not_provided () {
    echo -e $red"cx:"$defaultColor "When using -p or --path, a valid path sould be given"
    see_help_i_create
}

function see_help_i_create () {
    echo -e $blue"Tips:"$defaultColor "Use$cyan cx create --help$defaultColor to get more info about the \`create\` command"
}

function see_help_i () {
    echo -e $blue"Tips:"$defaultColor "See$cyan cx --help$defaultColor for more info" 
}

function cx__error_unknow-command () {
    echo -e $red"cx:"$defaultColor "Unknow command $command"
    see_help_i
}

function cx__error_no_command(){
    echo "cx: A command must be given"
    see_help_i
}

function cx__error_dir_inexistant () {
    echo -e $red"cx:"$defaultColor "The given directory does not exist"
}

function cx__error_bad_format () {
    echo -e $red"cx invalid format:"$defaultColor $1
    see_help_i_create
}

function cx__path_already_exist () {
    echo -e $red"cx:"$defaultColor "A shortcut to this path already exist!"
    echo -e $blue"Tips:"$defaultColor "Use$cyan cx list"$defaultColor to see all the saved paths
}

