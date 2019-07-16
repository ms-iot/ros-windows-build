$ACR_NAME = $env:CONTAINER_REGISTRY
az acr repository list -n $ACR_NAME | ConvertFrom-Json | ForEach-Object {
    $repository = $_
    az acr repository show-manifests -n $ACR_NAME --repository $repository | ConvertFrom-Json | ForEach-Object {
        $_ | ForEach-Object {
            $digest = $_.digest
            if(!$_.tags) {
                az acr repository delete --name $ACR_NAME --image $repository@$digest --yes
            }
        }
    }
}
