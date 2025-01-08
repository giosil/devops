$list_sc = @(kubectl get secrets -o jsonpath='{range .items[*]}{@.metadata.name}#{@.type} {end}')

$array_sc = $list_sc -split ' '

foreach ($sc in $array_sc) {
  if ($sc -like "*#helm.sh/release*") {
    $sc_name = $sc.Split('#')[0]
    
    Write-Host "Delete $sc_name..."
    
    kubectl delete secret $sc_name
  }
}
