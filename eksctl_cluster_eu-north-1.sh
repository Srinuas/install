eksctl create cluster --name=Srinu_EKS --region=eu-north-1 --zones=eu-north-1a,eu-north-1b --without-nodegroup
eksctl utils associate-iam-oidc-provider --region eu-north-1 --cluster Srinu_EKS --approve
eksctl create nodegroup --cluster=Srinu_EKS --region=eu-north-1 --name=Srinu_node --node-type=c7i-flex.large --nodes=2 --nodes-min=2 --nodes-max=4 --node-volume-size=20 --ssh-access --ssh-public-key=pem --managed --asg-access --external-dns-access --full-ecr-access --appmesh-access --alb-ingress-access
aws eks update-kubeconfig --name Srinu_EKS --region eu-north-1
#eksctl delete cluster --name Srinu_EKS --region eu-north-1
