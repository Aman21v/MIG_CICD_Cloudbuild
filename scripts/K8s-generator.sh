#!/bin/bash

ENV=$1
DOCKER_IMAGE=$2

cat << EOF >> Deployment.yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: core-webservices-deployment-$ENV
  labels:
    app: core-webservices-$ENV
spec:
  replicas: 2
  selector:
    matchLabels:
      app: core-webservices-$ENV
  template:
    metadata:
      labels:
        app: core-webservices-$ENV
    spec:
      containers:
        - name: core-webservices-$ENV
          image: $DOCKER_IMAGE
          ports:
            - containerPort: 8080
#          readinessProbe:
#            httpGet:
#              path: /healthz
#              port: 8080
#            initialDelaySeconds: 10
#            periodSeconds: 10
#          livenessProbe:
#            httpGet:
#              path: /healthz
#              port: 8080
#            initialDelaySeconds: 10
#            periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: core-webservices-$ENV
spec:
  type: LoadBalancer
  ports:
    - port : 8080
      targetPort: 8080
      protocol: TCP
  selector:
    app: core-webservices-$ENV
EOF
