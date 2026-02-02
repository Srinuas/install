#!/bin/bash

# స్క్రిప్ట్ రన్ అవుతున్నప్పుడు ఏమైనా ఎర్రర్ వస్తే వెంటనే ఆగిపోవాలి
set -e

echo "----------------------------------------------------------------"
echo "Starting Jenkins Installation..."
echo "----------------------------------------------------------------"

# 1. సిస్టమ్ అప్‌డేట్ చేయడం
echo "[Step 1] Updating System..."
sudo yum update -y

# 2. Java 21 (Amazon Corretto) ఇన్‌స్టాల్ చేయడం
# Jenkins రన్ అవ్వడానికి Java ముఖ్యం. ఇది ముందుగానే ఇన్‌స్టాల్ చేస్తున్నాం.
echo "[Step 2] Installing Java 21 (Amazon Corretto)..."
sudo yum install java-21-amazon-corretto -y

# Java ఎక్కడ ఇన్‌స్టాల్ అయ్యిందో చెక్ చేయడం
JAVA_PATH=$(readlink -f $(which java) | sed 's:/bin/java::')
echo "Java found at: $JAVA_PATH"

# 3. Jenkins Repository యాడ్ చేయడం
echo "[Step 3] Adding Jenkins Repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/rpm-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2023.key

# 4. Jenkins ఇన్‌స్టాల్ చేయడం
echo "[Step 4] Installing Jenkins..."
sudo yum install jenkins -y

# 5. Java Path ని Jenkinsకి ఆటోమేటిక్‌గా సెట్ చేయడం
# మీరు మాన్యువల్‌గా ఎడిట్ చేయకుండా, ఈ కమాండ్స్ ఆ పని చేస్తాయి.
echo "[Step 5] Configuring Jenkins Java Path..."
sudo mkdir -p /etc/systemd/system/jenkins.service.d/

cat <<EOF | sudo tee /etc/systemd/system/jenkins.service.d/override.conf
[Service]
Environment="JAVA_HOME=$JAVA_PATH"
EOF

# 6. సర్వీస్ స్టార్ట్ చేయడం
echo "[Step 6] Starting Jenkins Service..."
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

# 7. స్టేటస్ చెక్ చేయడం
echo "----------------------------------------------------------------"
echo "Installation Complete!"
sudo systemctl status jenkins --no-pager

echo "----------------------------------------------------------------"
echo "Waiting for Jenkins to generate the admin password (10 seconds)..."
sleep 10

echo "----------------------------------------------------------------"
echo "YOUR INITIAL ADMIN PASSWORD IS:"
echo "----------------------------------------------------------------"
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
else
    echo "Password file not found yet. Please run this command manually later:"
    echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
fi
echo "----------------------------------------------------------------"
