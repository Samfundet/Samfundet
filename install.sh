#!/bin/bash

BOT="[samf-bot]"

### Imports ###
echo ; echo ; echo ; echo "================================================================================================================"
[ -f bash_utils.sh ] && echo "$BOT: Don't mind me, I'm just fishing for resource 'bash_utils.sh'" && . bash_utils.sh
[ -f ~/.bash_profile ] && echo "$BOT: Don't mind me, I'm just fishing for resource '~/.bash_profile'" && . ~/.bash_profile
### End: Imports ###


# Initialise global 'X_INTERACTIVE'. Defaults to "y".
echo ; echo ; echo ; echo "================================================================================================================"
X_INTERACTIVE=${X_INTERACTIVE:="y"}
echo "$BOT: Running script in interaction mode: '$X_INTERACTIVE'"


### Welcome ###
echo ; echo ; echo ; echo "================================================================================================================"
echo
echo "$BOT:"
echo "  Hi, and welcome to Samfundet!"
echo
echo "  I will provide everything you need to clone, build, and run the project."
echo
echo "  I am partly interactive and will at some point depend on manual input from you to complete the installation."
echo "   (These steps consists of first time setup of ssh keys etc...)"
echo
echo "  If you know that you have already configured what is asked of you, "
echo "   you may skip the step (no need to remember, I will mention it again)."
echo
if [ $X_INTERACTIVE == "y" ]; then
    echo "  I will prompt for permission before performing any action,"
    echo "   although most of them are neccessary to complete the script."
    echo
    echo "  Questions annotated with (required) must run to succeed successfully."
fi
echo
do_action "\"I understand\"" "echo '$BOT: Here we go!'; sleep 1;" "y" || eval "echo \"$BOT: That's okay, I can't read either 😔. I'll let you off the hook for now...\"; sleep 1; exit 1"
### End: Welcome ###


### Requirements ###

# OS
[[ "$OSTYPE" == "darwin"* ]] ; IS_MAC=$?
[[ "$OSTYPE" == "linux-gnu"* ]] ; IS_UBUNTU=$?

# Attempt to install requirements first.
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
echo ; echo ; echo ; echo "================================================================================================================"
if [ $IS_UBUNTU == 0 ]; then
    do_action "$BOT: Attempt to install requirements (build-essential, procps, curl, file, git, ssh)" "sudo apt update -y ; sudo apt upgrade -y ; sudo apt install -y build-essential procps curl file git ssh" $X_INTERACTIVE
elif [ $IS_MAC == 0 ]; then
    do_action "$BOT: Attempt to install requirements (curl, git)" "brew install git curl" $X_INTERACTIVE
    do_action "$BOT: Install xcode-select" "xcode-select --install" $X_INTERACTIVE
fi

# Fail if missing requirements.
require "git"
require "curl"
require "ssh"
require "file"
require "ps" # procps
### End: requirements ###


### brew ###
# Install brew if it doesn't exist.
if [ ! `which brew` ]; then
    echo ; echo ; echo ; echo "================================================================================================================"
    echo "Homebrew is a packet manager such as 'apt' for Linux."
    do_action "$BOT: Install Homebrew (required)?" "" $X_INTERACTIVE
    if [ $? == 0 ]; then
        # Non-X_INTERACTIVE install.
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Update PATH and current shell.
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bash_profile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
fi

# Update and upgrade brew if it exists.
echo ; echo ; echo ; echo "================================================================================================================"
do_action "$BOT: Update and upgrade Homebrew (required)?" "" $X_INTERACTIVE
if [ $? == 0 ] && [ `which brew` ]; then
    # Update brew.
    echo "Updating and upgrading brew:"
    brew update && brew upgrade && brew upgrade --cask
    echo ; echo "Installing gcc"
    brew install gcc # Recommended by brew.
fi


### docker ###
if [[ ! `docker compose` ]]; then
    echo ; echo ; echo ; echo "================================================================================================================"
    if [ $IS_UBUNTU == 0 ]; then
        do_action "$BOT: Install docker (required)?" "" $X_INTERACTIVE
        if [ $? == 0 ]; then
            # https://docs.docker.com/engine/install/ubuntu/
            sudo apt-get remove docker docker-engine docker.io containerd runc
            sudo apt-get update
            sudo apt-get install -y ca-certificates curl gnupg lsb-release
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
        fi
    elif [ $IS_MAC == 0 ]; then
        do_action "$BOT: Install docker (required)?" "brew install docker docker-compose; mkdir -p ~/.docker/cli-plugins; ln -sfn /usr/local/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose" $X_INTERACTIVE
    fi
fi

### colima ###
# Replacement for docker-desktop. Only needed for MacOS.
# https://github.com/abiosoft/colima
if [ ! `which colima` ] && [ $IS_MAC == 0 ]; then
    echo ; echo ; echo ; echo "================================================================================================================"
    do_action "$BOT: Install colima (required unless you have docker-desktop)?" "brew install colima && colima start" $X_INTERACTIVE
fi


### bash-completion ###
# echo ; echo ; echo ; echo "================================================================================================================"
# do_action "$BOT: Install bash-completion (recommended)?" "brew install bash-completion" $X_INTERACTIVE


### jq ###
if [ ! `which jq` ]; then
    echo ; echo ; echo ; echo "================================================================================================================"
    if [ $IS_UBUNTU == 0 ]; then
        do_action "$BOT: Install jq (required)?" "sudo apt install -y jq" $X_INTERACTIVE
    elif [ $IS_MAC == 0 ]; then
        do_action "$BOT: Install jq (required)?" "brew install jq" $X_INTERACTIVE
    fi
fi


### postgresql ###
if [ ! `which psql` ]; then
    echo ; echo ; echo ; echo "================================================================================================================"
    if [ $IS_UBUNTU == 0 ]; then
        do_action "$BOT: Install postgresql (required)?" "sudo apt install -y postgresql libpq-dev && sudo service postgresql restart" $X_INTERACTIVE
    elif [ $IS_MAC == 0 ]; then
        do_action "$BOT: Install postgresql (required)?" "brew install postgresql && brew services restart postgresql" $X_INTERACTIVE
    fi
fi


### pyenv ###
if [ ! `which pyenv` ]; then
    echo ; echo ; echo ; echo "================================================================================================================"
    # do_action "$BOT: Install pyenv (required)?" "brew install pyenv ; echo 'export PYENV_ROOT=~/.pyenv' >> ~/.bash_profile && echo 'export PATH=~/.pyenv/bin:$PATH' >> ~/.bash_profile ; echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval '$(pyenv init -)'\nfi' >> ~/.bash_profile ; . ~/.bash_profile" $X_INTERACTIVE
    # https://github.com/pyenv/pyenv/wiki#suggested-build-environment
    do_action "$BOT: Install pyenv (required)?" "" $X_INTERACTIVE
    if [ $? == 0 ] ; then # If 'yes'.
        # Install pyenv dependencies to OS.
        if [ $IS_UBUNTU ] ; then
            sudo apt install -y make build-essential libssl-dev zlib1g-dev \
                libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
                libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
        elif [ $IS_MAC ] ; then
            brew install openssl readline sqlite3 xz zlib tcl-tk
        fi

        # Install pyenv.
        brew install pyenv
        echo 'export PYENV_ROOT=~/.pyenv' >> ~/.bash_profile
        echo 'export PATH=~/.pyenv/bin:$PATH' >> ~/.bash_profile
        echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bash_profile
        . ~/.bash_profile
    fi
fi


### github-cli ###
if [ ! `which gh` ]; then
    echo ; echo ; echo ; echo "================================================================================================================"
    do_action "$BOT: Install github-cli (gh) (required)?" "brew install gh" $X_INTERACTIVE
fi


### Offer to install applications to MacOS ###
if [ $IS_MAC == 0 ]; then
    # Cask packages are MacOS only.

    ### google-chrome ###
    echo ; echo ; echo ; echo "================================================================================================================"
    do_action "$BOT: Install google-chrome (optional)?" "brew install --cask google-chrome" "y"

    ### iterm2 ###
    echo ; echo ; echo ; echo "================================================================================================================"
    echo "Iterm2 is an improved version of Terminal."
    do_action "$BOT: Install iterm2 (optional)?" "brew install --cask iterm2" "y"


    ### visual-studio-code ###
    echo ; echo ; echo ; echo "================================================================================================================"
    do_action "$BOT: Install visual-studio-code (optional)?" "brew install visual-studio-code" "y"


    ### alt-tab ###
    # Enables tabbing similar to Windows.
    # https://alt-tab-macos.netlify.app/
    echo ; echo ; echo ; echo "================================================================================================================"
    echo ; echo ; echo "AltTab is an application that provides a tabbing experience similar to Windows."
    do_action "$BOT: Install alt-tab (optional)?" "brew install --cask alt-tab" "y"
fi


### Setup project ###
if [ `which gh` ]; then
    echo ; echo ; echo ; echo "================================================================================================================"
    echo "Make a PAT (Personal Access Token) here: https://github.com/settings/tokens/new"
    echo "Select scopes (repo, read:org, admin:public_key)."
    echo "This token is important. Store it someplace safe, preferably a password manager (github will never show it again)."
    echo
    do_action "$BOT: I have created (or already have) a PAT." "" $X_INTERACTIVE

    # Get email.
    # echo ; echo ; echo ; echo "================================================================================================================"
    # get_var_with_confirm "EMAIL" "Email at github.com: "

    # Create ssh key.
    echo ; echo ; echo ; echo "================================================================================================================"
    do_action "$BOT: Do you wish to create a new ssh key?" "" "y"
    if [ $? == 0 ]; then
        get_var_with_confirm "EMAIL" "Email at github.com: "
        ssh-keygen -t ed25519 -C $EMAIL
    fi

    # Get private ssh key to use further.
    # echo ; echo ; echo ; echo "================================================================================================================"
    # shopt -s extglob # Enable enhanced globbing.
    # ls ~/.ssh/!(*.pub) # Show all private keys to user.
    # ls -lad ~/.ssh/*
    # get_var_with_confirm "KEY_PRIV" "Please give me the path to a PRIVATE ssh key: "

    # Add ssh key to github.
    echo ; echo ; echo ; echo "================================================================================================================"
    # Github will ask to add ssh-key on authentication.
    echo "You should skip if you have done this step before."
    echo "If you generate/add ssh key, select SSH as preferred method, then use PAT to authenticate."
    do_action "$BOT: Add ssh key to your Github account?" "gh auth login" "y"
    
    # Add ssh key to ~/ssh/config.
    echo ; echo ; echo ; echo "================================================================================================================"
    echo "You should skip if you have done this step before."
    do_action "$BOT: Add an ssh key to ~/.ssh/config with host (github.com)?" "echo 'I have listed the content in ~/.ssh for you:'; ls -lad ~/.ssh/*" "y"
    if [ $? == 0 ]; then
        get_var_with_confirm "KEY_PRIV" "Please give me the path to a PRIVATE ssh key: "
        echo $'\nHost github.com\n\tPreferredauthentications publickey\n\tIdentityFile '$KEY_PRIV >> ~/.ssh/config
    fi

    # Start ssh-agent.
    echo ; echo ; echo ; echo "================================================================================================================"
    do_action "$BOT: Start ssh-agent (required)?" "echo 'I have listed the content in ~/.ssh for you:'; ls -lad ~/.ssh/*" "y"
    if [ $? == 0 ]; then
        get_var_with_confirm "KEY_PRIV" "Please give me the path to a PRIVATE ssh key: "
        # chmod 600 $KEY_PRIV # Only accessible to you.
        eval "$(ssh-agent -s)" # Start ssh-agent.
        ssh-add $KEY_PRIV # Add key to ssh-agent session.
        # echo $'\neval "$(ssh-agent -s)" # Start ssh-agent.\nssh-add '$KEY_PRIV$' # Add key to ssh-agent session.\n' >> ~/.bash_profile
        # . ~/.bash_profile
    fi
fi


# Clone project.
echo ; echo ; echo ; echo "================================================================================================================"
do_action "$BOT: Clone repo git@github.com:Samfundet/rekenett.git?" "git clone git@github.com:Samfundet/rekenett.git" $X_INTERACTIVE

### Setup project if cloned. ###
if [ `ls rekenett/.env.example` ] ; then # Simple check if an arbitrary file exists.
    # Some extra steps.
    cd rekenett
    cp .env.example .env
    cp .vscode/settings.default.json .vscode/settings.json

    echo ; echo ; echo ; echo "================================================================================================================"
    do_action "$BOT: Do you wish to configure VSCode?" "" $X_INTERACTIVE
    if [ $? == 0 ] ; then
        echo "VSCode setup (requires that you cloned the project):"
        echo
        echo "1. Open VSCode"
        echo "2. Press CMD+Shift+P"
        echo "3. Type 'install code'"
        echo "4. Select the alternative 'Shell Command: Install 'code' command in PATH' "
        echo
        do_action "$BOT: When this is finished, confirm to continue..." "" $X_INTERACTIVE

        # Install default extensions.
        echo ; echo ; echo ; echo "================================================================================================================"
        do_action "$BOT: Install default vscode extensions from .vscode/extensions.json?" "install_extensions .vscode/extensions.json" $X_INTERACTIVE

        # Install recommended extensions.
        # echo ; echo ; echo ; echo "================================================================================================================"
        # do_action "$BOT: Install recommended vscode extensions from .vscode/extensions.json.recommended?" "install_extensions .vscode/extensions.json.recommended" $X_INTERACTIVE
        
    fi

    # Install python virtual environment with dependencies.
    echo ; echo ; echo ; echo "================================================================================================================"
    do_action "$BOT: Install virtual python environment (pyenv, pipenv)?" "pyenv install ; python -m pip install pipenv ; PIPENV_VENV_IN_PROJECT=1 python -m pipenv install --python `cat .python-version`" $X_INTERACTIVE

    # Build project.
    echo ; echo ; echo ; echo "================================================================================================================"
    do_action "$BOT: Build project?" "" $X_INTERACTIVE
    if [ $? == 0 ]; then
        if [ $IS_UBUNTU == 0 ]; then
            sudo docker compose build
        elif [ $IS_MAC == 0 ]; then
            # Mac doesn't need to use sudo.
            docker compose build
        fi
    fi
fi


### Cleanup ###
unset X_INTERACTIVE
unset EMAIL
unset KEY_PRIV


### Final messages ###
echo ; echo ; echo ; echo "================================================================================================================"
echo
cat << EOF
           _ _       _                  _ 
     /\   | | |     | |                | |
    /  \  | | |   __| | ___  _ __   ___| |
   / /\ \ | | |  / _' |/ _ \| '_ \ / _ \ |
  / ____ \| | | | (_| | (_) | | | |  __/_|
 /_/    \_\_|_|  \__,_|\___/|_| |_|\___(_)

EOF
echo
echo "Remember to configure environment settings in file '.env'"
echo
echo "You can now run this command to start the project in a docker container:"
# echo "    docker build -t samfundet/rekenett . && docker run --rm --name samfundet-rekenett -p 8000:8000 -it samfundet/rekenett"
echo "    $ docker compose up"
echo
echo "NOTE: See Dockerfile for more useful commands."
echo
do_action "$BOT: I can also start the project if you'd like" "" "y"
if [ $? == 0 ]; then
    if [ $IS_UBUNTU == 0 ]; then
        sudo docker compose up
    elif [ $IS_MAC == 0 ]; then
        # Mac doesn't need to use sudo.
        docker compose up
    fi
fi

# echo "You can now run these commands to start the project:"
# echo "    python -m pipenv run python manage.py collectstatic"
# echo "    python -m pipenv run python manage.py migrate"
# echo "    python -m pipenv run python manage.py runserver"
