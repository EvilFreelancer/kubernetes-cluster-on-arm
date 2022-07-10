#!/bin/bash

kubectl port-forward $(kubectl get pods --namespace=kube-system --selector "app.kubernetes.io/name=traefik" --output=name) 9000:9000 --namespace=kube-system
