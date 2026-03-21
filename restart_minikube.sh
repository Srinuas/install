#!/bin/bash

echo "Stopping minikube..."
minikube stop

sleep 5

echo "Deleting minikube..."
minikube delete

sleep 10

echo "Starting minikube..."
minikube start --driver=docker --force

echo "Waiting for cluster to be ready..."
sleep 20

echo "Installing ingress-nginx..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.1/deploy/static/provider/cloud/deploy.yaml

echo "Waiting for ingress controller..."
sleep 10

echo "Installing metrics-server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo "Waiting for metrics-server..."
sleep 10

echo "Deploying application..."
kubectl apply -f lib.yml

sleep 20
kubectl get all -n srinu
sleep 4
echo "✅ Done"

