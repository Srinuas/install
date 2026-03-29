export KOPS_STATE_STORE=s3://srinu.ns
kops delete cluster --name srinu.k8s.local --yes
