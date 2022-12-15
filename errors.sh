function pathx__error_unknow-arg () {
    echo -e $red"pathx:"$defaultColor "\"$1\"" "is invalid"
}

function pathx__error_invalid_option () {
    echo -e $red"pathx:"$defaultColor "\"$1\"" "is an invalid option"
}

function pathx__error_path_not_provided () {
    echo -e $red"pathx:"$defaultColor "When using -p or --path, a valid path sould be given"
    see_help_i_create
}

function see_help_i_create () {
    echo -e $blue"Tips:"$defaultColor "Use$cyan pathx create --help$defaultColor to get more info about the \`create\` command"
}

function see_help_i () {
    echo -e $blue"Tips:"$defaultColor "See$cyan pathx --help$defaultColor for more info" 
}

function pathx__error_unknow-command () {
    echo -e $red"pathx:"$defaultColor "Unknow command $command"
    see_help_i
}

function pathx__error_no_command(){
    echo "pathx: A command must be given"
    see_help_i
}

function pathx__error_dir_inexistant () {
    echo -e $red"pathx:"$defaultColor "The given directory does not exist"
}

function pathx__error_bad_format () {
    echo -e $red"pathx invalid format:"$defaultColor $1
    see_help_i_create
}

function pathx__path_already_exist () {
    echo -e $red"pathx:"$defaultColor "A shortcut to this path already exist!"
    echo -e $blue"Tips:"$defaultColor "Use$cyan pathx list"$defaultColor to see the saved path
}

