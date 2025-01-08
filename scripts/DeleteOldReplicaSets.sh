#!/bin/bash

list_rs=$(kubectl get rs -o jsonpath='{.items[?(@.status.replicas==0)].metadata.name}')

for rs in $list_rs; do
  kubectl delete rs $rs
done
