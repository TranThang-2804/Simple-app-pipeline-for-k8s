#!/bin/bash
export IMAGE_TAG=$(cat tagnamefile)
sudo yq eval ".deployment.tag = \"$IMAGE_TAG\"" -i ./k8s-manifest-for-simple-java-app/charts/helm-demo/values.yaml
export HELM_VERSION=$(echo 1.5.`date +%s`)
sudo yq eval ".version = \"$HELM_VERSION\"" -i ./k8s-manifest-for-simple-java-app/charts/helm-demo/Chart.yaml

cd ./k8s-manifest-for-simple-java-app
git add .
git commit -m "update by pipeline"
git push origin main