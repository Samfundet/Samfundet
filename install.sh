#!/bin/bash


### Imports ###
[ -f bash_utils.sh ] && echo "Sourcing bash_utils.sh" && . bash_utils.sh
[ -f ~/.bash_profile ] && echo "Sourcing ~/.bash_profile" && . ~/.bash_profile
[ -f ~/.bash_rc ] && echo "Sourcing ~/.bash_rc" && . ~/.bash_rc
### End: Imports ###


# Initialise global 'X_INTERACTIVE'. Defaults to "y".
X_INTERACTIVE=${X_INTERACTIVE:="y"}
echo "X_INTERACTIVE=$X_INTERACTIVE"
echo


### Welcome ###
echo
echo "         @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@ "
echo "         @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@ "
echo "         @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@ "
echo "         @@@@@@@                                                               @@@@@@@ "
echo "         @@@@@@@                                                               @@@@@@@ "
echo "         @@@@@@@                                                               @@@@@@@ "
echo "         @@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@ "
echo "         @@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@ "
echo "         @@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@ "
echo "                       @@@@@@@                                   @@@@@@@               "
echo "                       @@@@@@@                                   @@@@@@@               "
echo "                       @@@@@@@                                   @@@@@@@               "
echo "         @@@@@@@       @@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@       @@@@@@@ "
echo "         @@@@@@@       @@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@       @@@@@@@ "
echo "         @@@@@@@       @@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@       @@@@@@@ "
echo "         @@@@@@@                     @@@@@@@@@@@@@@@@@@@@@                     @@@@@@@ "
echo "         @@@@@@@                     @@@@@@@@@@@@@@@@@@@@@                     @@@@@@@ "
echo "         @@@@@@@                     @@@@@@@@@@@@@@@@@@@@@                     @@@@@@@ "
echo "         @@@@@@@       @@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@       @@@@@@@ "
echo "         @@@@@@@       @@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@       @@@@@@@ "
echo "         @@@@@@@       @@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@       @@@@@@@ "
echo "                       @@@@@@@                                   @@@@@@@               "
echo "                       @@@@@@@                                   @@@@@@@               "
echo "                       @@@@@@@                                   @@@@@@@               "
echo "         @@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@ "
echo "         @@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@ "
echo "         @@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@ "
echo "         @@@@@@@                                                               @@@@@@@ "
echo "         @@@@@@@                                                               @@@@@@@ "
echo "         @@@@@@@                                                               @@@@@@@ "
echo "         @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@ "
echo "         @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@ "
echo "         @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@ "
echo
echo
echo
echo '   /@@@@@@                           /@@@@@@                           /@@             /@@         '
echo '  /@@__  @@                         /@@__  @@                         | @@            | @@         '
echo ' | @@  \__/  /@@@@@@  /@@@@@@/@@@@ | @@  \__//@@   /@@ /@@@@@@@   /@@@@@@@  /@@@@@@  /@@@@@@     '
echo ' |  @@@@@@  |____  @@| @@_  @@_  @@| @@@@   | @@  | @@| @@__  @@ /@@__  @@ /@@__  @@|_  @@_/       '
echo '  \____  @@  /@@@@@@@| @@ \ @@ \ @@| @@_/   | @@  | @@| @@  \ @@| @@  | @@| @@@@@@@@  | @@     '
echo '  /@@  \ @@ /@@__  @@| @@ | @@ | @@| @@     | @@  | @@| @@  | @@| @@  | @@| @@_____/  | @@ /@@    '
echo ' |  @@@@@@/|  @@@@@@@| @@ | @@ | @@| @@     |  @@@@@@/| @@  | @@|  @@@@@@@|  @@@@@@@  |  @@@@/     '
echo '  \______/  \_______/|__/ |__/ |__/|__/      \______/ |__/  |__/ \_______/ \_______/   \___/ '
echo
echo
echo
echo "Hi, and welcome to Samfundet!"
echo
echo "I will provide everything you need to clone, build, and run the project."
echo
echo "I am partly interactive and will at some point depend on manual input from you to complete the installation."
echo "(These steps consists of first time setup of ssh keys etc.)"
echo
echo "If you know that you have already configured what is asked of you, "
echo "you may skip the step (no need to remember, I will mention it again)."
echo
if [ $X_INTERACTIVE == "y" ]; then
    echo "It will prompt for permission before performing any action,"
    echo "although most of them are neccessary to complete the script."
    echo
    echo "Questions annotated with (required) must run to succeed successfully."
fi
echo
do_action "I understand" "echo 'Here we go!'" "y"
### End: Welcome ###


### Requirements ###

# OS (0=yes, 1=no)
[[ "$OSTYPE" == "darwin"* ]] ; IS_MAC=$?
[[ "$OSTYPE" == "linux-gnu"* ]] ; IS_UBUNTU=$?


# Attempt to install requirements first.
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
echo ; echo ; echo ; echo "==============================================================="
if [ $IS_UBUNTU == 0 ]; then
    do_action "Attempt to install requirements (build-essential, procps, curl, file, git, ssh)" "sudo apt update -y ; sudo apt upgrade -y ; sudo apt install -y build-essential procps curl file git ssh" $X_INTERACTIVE
elif [ $IS_MAC == 0 ]; then
    do_action "Attempt to install requirements (curl, git)" "brew install git curl" $X_INTERACTIVE
    do_action "Install xcode-select" "xcode-select --install" $X_INTERACTIVE
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
    echo ; echo ; echo ; echo "==============================================================="
    echo "Homebrew is a packet manager such as 'apt' for Linux."
    do_action "Install Homebrew (required)?" "" $X_INTERACTIVE
    if [ $? == 0 ]; then
        # Non-X_INTERACTIVE install.
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Update PATH and current shell.
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bash_profile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
fi

# Update and upgrade brew if it exists.
echo ; echo ; echo ; echo "==============================================================="
do_action "Update and upgrade Homebrew (required)?" "" $X_INTERACTIVE
if [ $? == 0 ] && [ `which brew` ]; then
    # Update brew.
    echo "Updating and upgrading brew:"
    brew update && brew upgrade && brew upgrade --cask
    echo ; echo "Installing gcc"
    brew install gcc # Recommended by brew.
fi


### docker ###
if [ ! `which docker` ]; then
    echo ; echo ; echo ; echo "==============================================================="
    if [ $IS_UBUNTU == 0 ]; then
        do_action "Install docker (required)?" "" $X_INTERACTIVE
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
        do_action "Install docker (required)?" "brew install docker" $X_INTERACTIVE
    fi
fi


### colima ###
# Replacement for docker-desktop. Only needed for macOS.
# https://github.com/abiosoft/colima
if [ ! `which colima` ] && [ $IS_MAC == 0 ]; then
    echo ; echo ; echo ; echo "==============================================================="
    do_action "Install colima (required unless you have docker-desktop)?" "brew install colima && colima start" $X_INTERACTIVE
fi


### jq ###
# if [ ! `which jq` ]; then
#     echo ; echo ; echo ; echo "==============================================================="
#     if [ $IS_UBUNTU == 0 ]; then
#         do_action "Install jq (required)?" "sudo apt install -y jq" $X_INTERACTIVE
#     elif [ $IS_MAC == 0 ]; then
#         do_action "Install jq (required)?" "brew install jq" $X_INTERACTIVE
#     fi
# fi


### postgresql ###
# if [ ! `which psql` ]; then
#     echo ; echo ; echo ; echo "==============================================================="
#     if [ $IS_UBUNTU == 0 ]; then
#         do_action "Install postgresql (required)?" "sudo apt install -y postgresql libpq-dev && sudo service postgresql restart" $X_INTERACTIVE
#     elif [ $IS_MAC == 0 ]; then
#         do_action "Install postgresql (required)?" "brew install postgresql && brew services restart postgresql" $X_INTERACTIVE
#     fi
# fi


### rbenv ###
# if [ ! `which rbenv` ]; then
#     echo ; echo ; echo ; echo "==============================================================="
#     do_action "Install rbenv (required)?" "" $X_INTERACTIVE
#     if [ $? == 0 ] ; then # If 'yes'.
#         brew install rbenv
#         echo -e 'if command -v rbenv 1>/dev/null 2>&1; then\n eval "$(rbenv init - bash)"\nfi' >> ~/.bash_profile
#         echo -e 'if command -v rbenv 1>/dev/null 2>&1; then\n eval "$(rbenv init - zsh)"\nfi' >> ~/.zsh_profile
#         eval "$(rbenv init - bash)"
#     fi
# fi


### imagemagick ###
# if [ ! -x /usr/local/Cellar/imagemagick ]; then
#     if [ $IS_UBUNTU == 0 ]; then
#         do_action "Install imagemagick (required)?" "sudo apt install imagemagick" $X_INTERACTIVE
#     elif [ $IS_MAC == 0 ]; then
#         do_action "Install imagemagick (required)?" "brew install imagemagick" $X_INTERACTIVE
#     fi
# fi


### graphviz ###
# if [ ! -x /usr/local/Cellar/graphviz ]; then
#     if [ $IS_UBUNTU == 0 ]; then
#         do_action "Install graphviz (required)?" "sudo apt install graphviz" $X_INTERACTIVE
#     elif [ $IS_MAC == 0 ]; then
#         do_action "Install graphviz (required)?" "brew install graphviz" $X_INTERACTIVE
#     fi
# fi


### github-cli ###
if [ ! `which gh` ]; then
    echo ; echo ; echo ; echo "==============================================================="
    do_action "Install github-cli (gh) (required)?" "brew install gh" $X_INTERACTIVE
fi


### Offer to install additional applications to macOS ###
if [ IS_MAC == 0 ]; then
    # Cask packages are macOS only.

    ### google-chrome ###
    echo ; echo ; echo ; echo "==============================================================="
    do_action "Install google-chrome (optional)?" "brew install --cask google-chrome" $X_INTERACTIVE

    ### iterm2 ###
    echo ; echo ; echo ; echo "==============================================================="
    echo "Iterm2 is an improved version of Terminal."
    do_action "Install iterm2 (optional)?" "brew install --cask iterm2" $X_INTERACTIVE


    ### visual-studio-code ###
    echo ; echo ; echo ; echo "==============================================================="
    do_action "Install visual-studio-code (optional)?" "brew install visual-studio-code" $X_INTERACTIVE
fi


### Setup ssh ###
if [ `which gh` ]; then
    echo ; echo ; echo ; echo "==============================================================="
    echo "Make a PAT (Personal Access Token) here: https://github.com/settings/tokens/new"
    echo "Select scopes (repo, read:org, admin:public_key)."
    echo "This token is important. Store it someplace safe, preferably a password manager (Github will never show it again)."
    echo
    do_action "I have created (or already have) a PAT." "" $X_INTERACTIVE

    # Get email.
    # echo ; echo ; echo ; echo "==============================================================="
    # get_var_with_confirm "EMAIL" "Email at github.com: "

    # Create ssh key.
    echo ; echo ; echo ; echo "==============================================================="
    echo "If you already have an ssh key, you should skip."
    do_action "Do you wish to create a new ssh key?" "" "y"
    if [ $? == 0 ]; then
        get_var_with_confirm "EMAIL" "Email at github.com: "
        ssh-keygen -t ed25519 -C $EMAIL
    fi

    # Get private ssh key to use further.
    # echo ; echo ; echo ; echo "==============================================================="
    # shopt -s extglob # Enable enhanced globbing.
    # ls ~/.ssh/!(*.pub) # Show all private keys to user.
    # ls -lad ~/.ssh/*
    # get_var_with_confirm "KEY_PRIV" "Please give me the path to a PRIVATE ssh key: "

    # Add ssh key to github.
    echo ; echo ; echo ; echo "==============================================================="
    # Github will ask to add ssh-key on authentication.
    echo "If you have done this step before, you should skip."
    do_action "Add ssh key to your Github account?" "echo 'Select SSH as preferred method, then use PAT to authenticate.'; gh auth login" "y"
    
    # Add ssh key to ~/ssh/config.
    echo ; echo ; echo ; echo "==============================================================="
    echo "If you have done this step before, you should skip."
    do_action "Add an ssh key to ~/.ssh/config with host (github.com)?" "echo 'I have listed the content in ~/.ssh for you:'; ls -lad ~/.ssh/*" "y"
    if [ $? == 0 ]; then
        get_var_with_confirm "KEY_PRIV" "Please give me the path to a PRIVATE ssh key: "
        echo $'\nHost github.com\n\tPreferredauthentications publickey\n\tIdentityFile '$KEY_PRIV >> ~/.ssh/config
    fi

    # Start ssh-agent.
    echo ; echo ; echo ; echo "==============================================================="
    
    do_action "Start ssh-agent (required)?" "echo 'I have listed the content in ~/.ssh for you:'; ls -lad ~/.ssh/*" "y"
    if [ $? == 0 ]; then
        get_var_with_confirm "KEY_PRIV" "Please give me the path to a PRIVATE ssh key: "
        eval "$(ssh-agent -s)" # Start ssh-agent.
        ssh-add $KEY_PRIV # Add key to ssh-agent session.
    fi
fi


# Clone project.
echo ; echo ; echo ; echo "==============================================================="
# do_action "Clone repo git@github.com:Samfundet/Samfundet.git?" "git clone git@github.com:Samfundet/Samfundet.git" $X_INTERACTIVE
do_action "Clone repo git@github.com:Samfundet/Samfundet.git?" "git clone -b 935-dockerize git@github.com:Samfundet/Samfundet.git" $X_INTERACTIVE
# do_action "Clone repo git@github.com:Samfundet/SamfundetAuth.git?" "git clone git@github.com:Samfundet/SamfundetAuth.git" $X_INTERACTIVE
# do_action "Clone repo git@github.com:Samfundet/SamfundetDomain.git?" "git clone git@github.com:Samfundet/SamfundetDomain.git" $X_INTERACTIVE

### Setup project if cloned. ###
if [ `ls Samfundet/README.md` ] ; then # Simple check if an arbitrary file exists.
    # Some extra steps.
    cd Samfundet
    cp config/database.example.yml config/database.yml
    cp config/local_env.example.yml config/local_env.yml
    cp config/billig.example.yml config/billig.yml
    cp config/secrets.example.yml config/secrets.yml
    # cp .env.example .env
    # cp .vscode/settings.json.default .vscode/settings.json
    # make copy-config-files


    ### ruby ###
    # echo ; echo ; echo ; echo "==============================================================="
    # do_action "Install ruby (required)?" "" $X_INTERACTIVE
    # if [ $? == 0 ] ; then # If 'yes'.
    #     # Install ruby.
    #     # Added flag because of bug: https://github.com/rbenv/ruby-build/discussions/2009
    #     OPENSSL_CFLAGS=-Wno-error=implicit-function-declaration rbenv install # Uses version from '.ruby-version'.
    # fi


    ### bundler ###
    # # Make sure that the correct Bundler version is installed so that we can actually use the 'bundle' command.
    # # gem list returns true or false depending on whether the gem is found with the version provided is installed or not.
    # echo ; echo ; echo ; echo "==============================================================="
    # if [ false == *$(gem list -i 'bundler' -v 1.17.3)* ]; then
    #     gem install bundler:1.17.3 || exit
    # fi


    ### gems ###
    # 'bundle check' checks if the Gemfile is satisfied, i.e. if the gems are cached.
    # If not, install the gems.
    # echo ; echo ; echo ; echo "==============================================================="
    # bundle check || bundle install || exit

    ### vscode ###
    # echo ; echo ; echo ; echo "==============================================================="
    # do_action "Do you wish to configure VSCode?" "" $X_INTERACTIVE
    # if [ $? == 0 ] ; then
    #     echo "VSCode setup (requires that you cloned the project):"
    #     echo
    #     echo "1. Open VSCode"
    #     echo "2. Press CMD+Shift+P"
    #     echo "3. Type 'install code'"
    #     echo "4. Select the alternative 'Shell Command: Install 'code' command in PATH' "
    #     echo
    #     do_action "When this is finished, confirm to continue..." "" $X_INTERACTIVE

    #     # Install default extensions.
    #     echo ; echo ; echo ; echo "==============================================================="
    #     do_action "Install default vscode extensions from .vscode/extensions.json?" "install_extensions .vscode/extensions.json" $X_INTERACTIVE

    #     # Install recommended extensions.
    #     # echo ; echo ; echo ; echo "==============================================================="
    #     # do_action "Install recommended vscode extensions from .vscode/extensions.json.recommended?" "install_extensions .vscode/extensions.json.recommended" $X_INTERACTIVE
        
    # fi

    # Build project.
    echo ; echo ; echo ; echo "==============================================================="
    do_action "Build project?" "" $X_INTERACTIVE
    if [ $? == 0 ]; then
        if [ $IS_UBUNTU == 0 ]; then
            sudo docker compose build
            sudo docker compose run --rm app bundle exec bash -c "rails db:environment:set RAILS_ENV=development; bundle exec rake db:drop db:create db:migrate db:seed"
        elif [ $IS_MAC == 0 ]; then
            # Mac doesn't need to use sudo.
            docker compose build
            docker compose run --rm app bundle exec bash -c "rails db:environment:set RAILS_ENV=development; bundle exec rake db:drop db:create db:migrate db:seed"
        fi
    fi
fi


### Cleanup ###
unset X_INTERACTIVE
unset EMAIL
unset KEY_PRIV


### Final messages ###
echo ; echo ; echo ; echo "==============================================================="
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
echo "    $ docker compose up"
echo
echo "NOTE: See Dockerfile for more useful commands."
echo
do_action "I can also start the project for you if you'd like" "" "y"
if [ $? == 0 ]; then
    if [ $IS_UBUNTU == 0 ]; then
        sudo docker compose up
    elif [ $IS_MAC == 0 ]; then
        # Mac doesn't need to use sudo.
        docker compose up
    fi
fi
