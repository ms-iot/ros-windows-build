$ACR_NAME = $env:CONTAINER_REGISTRY
az acr repository list -n $ACR_NAME | ConvertFrom-Json | ForEach-Object {
    # Azure CLI returns a JSON string with a array [...] as the root, and in such case
    # ConverFrom-Json returns a 2-D array and we should iterate the inner one to get the correct values.
    $_ | ForEach-Object {
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
}
