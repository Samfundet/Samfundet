user=$(whoami)

sudo apt-get update
sudo apt-get install graphviz
sudo apt-get install imagemagick
sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm
sudo usermod -a -G rvm user
sudo reboot