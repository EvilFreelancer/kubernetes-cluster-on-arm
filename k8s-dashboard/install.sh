#!/bin/bash

set -xe

# Install dashboard application
#GITHUB_URL=https://github.com/kubernetes/dashboard/releases
#VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml
kubectl apply -f recommended.yaml -f dashboard.admin-user.yml -f dashboard.admin-user-role.yml

# Enable via ingress
kubectl apply -f dashboard-ingress.yml
