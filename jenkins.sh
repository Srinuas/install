sudo yum update –y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum install java-17-amazon-corretto -y
sudo yum install jenkins git -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status Jenkins
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl status Jenkins
sudo systemctl status docker
