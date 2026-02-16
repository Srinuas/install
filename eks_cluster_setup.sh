eksctl create cluster --name=EKS-1 --region=us-east-2 --zones=us-east-2a,us-east-2b --without-nodegroup
eksctl utils associate-iam-oidc-provider --region us-east-2 --cluster EKS-1 --approve
eksctl create nodegroup --cluster=EKS-1 --region=us-east-2 --name=node2 --node-type=c7i-flex.large --nodes=2 --nodes-min=2 --nodes-max=4 --node-volume-size=20 --ssh-access --ssh-public-key=mykey --managed --asg-access --external-dns-access --full-ecr-access --appmesh-access --alb-ingress-access
aws eks update-kubeconfig --name EKS-1 --region us-east-2
#eksctl delete cluster --name EKS-1 --region us-east-2
