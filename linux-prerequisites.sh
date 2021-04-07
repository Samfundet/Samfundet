#Check for updates
sudo apt-get update
sudo apt-get upgrade

#Some requirements to install beforehand
sudo apt-get install graphviz
sudo apt-get install imagemagick
sudo apt-get install nodejs

#Prerequisits for installing rvm (ruby version manager)
sudo add-apt-repository universe
sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get install rvm

#Adding the user to the rvm group
user=$(whoami)
sudo usermod -a -G rvm $user
