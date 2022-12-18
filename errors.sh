function cx__error_unknow-arg () {
    echo -e $red"cx:"$defaultColor "\"$1\"" "is invalid"
}

function cx__error_unknown_flag () {
     echo -e $red"cx:"$defaultColor "\"$1\"" "is an invalid flag"
     see_help_i_create
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

function see_help_i_delete () {
    echo -e $blue"Tips:"$defaultColor "See$cyan cx delete --help"$defaultColor "to see more about the delete command"
}

function see_help_i () {
    echo -e $blue"Tips:"$defaultColor "See$cyan cx --help$defaultColor for more info" 
}

function cx__error_unknow-command () {
    echo -e $red"cx:"$defaultColor "Unknow command $1"
    see_help_i
}

function cx__error_no_command(){
    echo "cx: A command must be given"
    see_help_i
}

function see_help_i_rename () {
    echo -e $blue"Tips:"$defaultColor "See$cyan cx rename --help"$defaultColor "to see more about the rename command"
}

function cx__error_dir_inexistant () {
    echo -e $red"cx:"$defaultColor "The given directory does not exist"
}

function cx__error_bad_format () {
    echo -e $red"cx invalid format:"$defaultColor $1
    see_help_i_create
}

function cx__error_path_already_exist () {
    echo -e $red"cx:"$defaultColor "A shortcut to this path already exist!"
    echo -e $blue"Tips:"$defaultColor "Use$cyan cx list"$defaultColor to see all the saved paths
}

function cx__error_shortcut_already_exist () {
    echo -e $red"cx:"$defaultColor "A shortcut with this name already exist!"
    echo -e $blue"Tips:"$defaultColor "Use$cyan cx list"$defaultColor to see all the saved paths
}

function cx__error_alias_not_provided () {
    echo -e $red"cx:"$defaultColor "You must give the shortcut name in order to delete it."
    see_help_i_delete
}

function cx__error_alias_not_found () {
    echo -e $red"cx:"$defaultColor "the given shortcut doesn't exist"
}

function cx__error_new_alias_not_provided () {
    echo -e $red"cx:"$defaultColor "You must give the new shortcut name."
    see_help_i_rename
}

function cx__error_not_alias_rename () {
    echo -e $red"cx:"$defaultColor "2 arguments expected, 0 found"
    see_help_i_rename
}

