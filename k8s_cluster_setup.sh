# install kops
# check the version is same on website
# https://kops.sigs.k8s.io/getting_started/install/
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/kops

# install kubectl
# check the version is same on website
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/
# eu-north-1

export KOPS_STATE_STORE=s3://srinu.ns
kops create cluster --name srinu.k8s.local --zones eu-north-1a,eu-north-1b,eu-north-1c --master-size c7i-flex.large --master-count 1 --master-volume-size 25 --node-size c7i-flex.large --node-count 2 --node-volume-size 20 --image ami-0974a2c5ddf10f442
kops update cluster --name srinu.k8s.local --yes --admin

# export KOPS_STATE_STORE=s3://srinu.ns
# kops delete cluster --name srinu.k8s.local --yes
#
#export KOPS_STATE_STORE=s3://srinu.as
#kops create cluster --name srinuas.k8s.local --zones us-east-2a,us-east-2b,us-east-2c --master-size m7i-flex.large --master-count 1 --master-volume-size 25 --node-size c7i-flex.large --node-count 2 --node-volume-size 20 --image ami-0f5fcdfbd140e4ab7
#kops update cluster --name srinuas.k8s.local --yes --admin

#export KOPS_STATE_STORE=s3://srinu.as
#kops delete cluster --name srinuas.k8s.local --yes

#Must specify --yes to apply changes

#Cluster configuration has been created.

#Suggestions:
 #* list clusters with: kops get cluster
 #* edit this cluster with: kops edit cluster srinu.k8s.local
 #* edit your node instance group: kops edit ig --name=srinu.k8s.local nodes-us-east-2a
 #* edit your control-plane instance group: kops edit ig --name=srinu.k8s.local control-plane-us-east-2a

#Finally configure your cluster with: kops update cluster --name srinu.k8s.local --yes --admin

#Cluster is starting.  It should be ready in a few minutes.

#Suggestions:
 #* validate cluster: kops validate cluster --wait 10m
 #* list nodes: kubectl get nodes --show-labels
 #* ssh to a control-plane node: ssh -i ~/.ssh/id_rsa ubuntu@
 #* the ubuntu user is specific to Ubuntu. If not using Ubuntu please use the appropriate user based on your OS.

#helm install prometheus prometheus-community/prometheus --namespace prometheus --set alertmanager.persistentVolume.storageClass="gp2" --set server.persistentVolume.storageClass="gp2"

#helm install grafana grafana/grafana --namespace grafana --set persistence.storageClassName="gp2" --set persistence.enabled=true --set adminPassword='Anna@ewww!' --set  service.type=LoadBalancer


