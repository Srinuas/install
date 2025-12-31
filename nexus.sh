sudo yum update -y
sudo yum install wget -y
sudo yum install java-17-amazon-corretto-jmods -y
cd /opt
sudo wget https://download.sonatype.com/nexus/3/nexus-3.79.1-04-linux-x86_64.tar.gz
sudo tar -xvf nexus-3.79.1-04-linux-x86_64.tar.gz
sudo mv nexus-3.79.1-04 nexus
sudo adduser nexus
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype*
su - nexus
cd /opt/nexus/bin/
./nexus start
