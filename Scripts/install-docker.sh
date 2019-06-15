# ./docker-install.sh
# apt update
apt-get update && sudo apt-get -y upgrade
apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
# apt update
apt-get update && sudo apt-get -y upgrade
apt-cache policy docker-ce
apt install -y docker-ce
systemctl status docker --no-pager
docker info
