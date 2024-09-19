#!/bin/bash

NAMESPACE="postgres-stolon"

# Delete the namespace if it exists
oc delete namespace $NAMESPACE --ignore-not-found=true

# Wait for the namespace to be deleted
while oc get namespace $NAMESPACE &>/dev/null; do
  echo "Waiting for namespace $NAMESPACE to be deleted..."
  sleep 5
done

# Create the namespace
oc create namespace $NAMESPACE

# Create a Service Account
oc create sa stolon-sa -n $NAMESPACE

# Assign the anyuid Security Context Constraints (SCC) to the service account
oc adm policy add-scc-to-user anyuid -z stolon-sa -n $NAMESPACE

# Apply role and role binding
oc apply -f role.yaml -n $NAMESPACE
oc apply -f role-binding.yaml -n $NAMESPACE

# Create Secrets
oc apply -f secret.yaml -n $NAMESPACE

# Deploy Stolon Keeper
oc apply -f stolon-keeper_new.yaml -n $NAMESPACE
oc apply -f stolon-keeper-service.yaml -n $NAMESPACE

# Deploy Stolon Proxy
oc apply -f stolon-proxy_new.yaml -n $NAMESPACE
oc apply -f stolon-proxy-service.yaml -n $NAMESPACE

# Deploy Stolon Sentinel
oc apply -f stolon-sentinel_new.yaml -n $NAMESPACE
oc apply -f stolon-sentinel-service.yaml -n $NAMESPACE

# Initialize Stolon Cluster
oc apply -f stolonctl-pod.yaml -n $NAMESPACE

# Add a short delay to give the pod time to be created
sleep 5


# Verify Deployment
echo "Deployment completed. Verifying the status of pods and services..."
oc get pods -n $NAMESPACE
oc get services -n $NAMESPACE