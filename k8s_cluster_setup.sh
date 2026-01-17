# check the details before execute
# 
export KOPS_STATE_STORE=s3://srinu.as
kops create cluster --name srinu.k8s.local --zones us-east-2a,us-east-2b,us-east-2c --master-size c7i-flex.large --master-count 1 --master-volume-size 25 --node-size t3.micro --node-count 2 --node-volume-size 20 --image ami-0f5fcdfbd140e4ab7
kops update cluster --name srinu.k8s.local --yes --admin
