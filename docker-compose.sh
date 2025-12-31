# Download the current stable release of Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Apply executable permissions
sudo chmod +x /usr/local/bin/docker-compose
# Create a symbolic link
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Install using pip (Python package manager)
sudo yum install docker python3-pip -y
sudo pip3 install docker-compose
systemctl start docker

#check version
sudo docker-compose --version
sudo systemctl status docker
