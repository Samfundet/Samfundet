
### functions ###
function is_yes {
    [ "$1" = "y" ] || [ "$1" = "Y" ]
    return $?
}

function is_no {
    [ "$1" = "n" ] || [ "$1" = "N" ]
    return $?
}

function is_valid_answer {
    is_yes $1 || is_no $1
    return $?
}

function do_action {
    # $1: description
    # $2: string of chained commands
    # $3: interactive mode (y or n)
    # Utilises global 'interactive' to prompt user. Defaults to "y" if missing.
    local interactive=$3
    local should_ask=${interactive:="y"}
    local do_action_ans=0

    # Ask to do action if interactive mode.
    if [ "$should_ask" = "y" ]; then
        while ! is_valid_answer $do_action_ans ; do
            read -p "$1 [y/n]: " do_action_ans
        done
        # Make lowercase.
        do_action_ans=`echo $do_action_ans | tr "[:upper:]" "[:lower:]"`
    else 
        do_action_ans="y" # Manually set action to run.
        echo "$1 [y/n]: $do_action_ans" # Show header of current step even if non-interactive.
    fi
    # Run command if accepted.
    if [ "$do_action_ans" = "y" ]; then
        eval $2
        return 0 # OK
    fi
    return 1 # Answered no.
}

function require {
    # Exits if command is not found.
    # $1: command to check if exists
    if [ ! `which $1` ]; then
        echo "Error: '$1' is required"
        exit 1
    fi
}

function install_extensions {
    # Requires `code` is installed on PATH.
    # Requires `js`.
    # $1: path to json file: {"recommendations": [...]}

    # Fetch extensions.
    local extensions=`jq -c '.[][]' $1`
    local stripped_extensions=`echo $extensions | xargs echo`
    # Install extensions.
    for ext in $stripped_extensions
    do
        code --install-extension $ext --force
    done
}

function get_var_with_confirm {
    # $1: name assigned to variable.
    # $2: prompt
    local confirm=n
    while ! is_yes $confirm ; do
        read -p "$2" user_input
        read -p "Is this correct? ($1=$user_input) [y/n]: " confirm
    done
    # echo "confirm $confirm"
    printf -v "$1" "%s" "$user_input"

    echo "$1=$user_input"
}

function get_hidden_var_with_confirm {
    # $1: name assigned to variable.
    # $2: prompt
    local confirm=n
    while ! is_yes $confirm ; do
        read -s -p "$2" user_input
        read -p "Confirm that you want to proceed [y/n]: " confirm
    done
    # echo "confirm $confirm"
    printf -v "$1" "%s" "$user_input"

    echo "$1=$user_input"
}
### End: functions ###
