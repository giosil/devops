$list_rs = @(kubectl get rs -o jsonpath='{.items[?(@.status.replicas==0)].metadata.name}')

$array_rs = $list_rs -split ' '

foreach ($rs in $array_rs) {
    Write-Host "Delete $rs..."

    kubectl delete rs $rs
}