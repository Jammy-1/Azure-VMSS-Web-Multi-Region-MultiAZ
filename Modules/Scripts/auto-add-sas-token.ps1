param(
    [string]$Repo,
    [string]$SecretName,
    [string]$StorageAccount,
    [string]$ContainerName
)

# SP Credentials
$clientId       = $env:AZURE_CLIENT_ID
$clientSecret   = $env:AZURE_CLIENT_SECRET
$tenantId       = $env:AZURE_TENANT_ID
$subscriptionId = $env:AZURE_SUBSCRIPTION_ID

if (-not ($clientId -and $clientSecret -and $tenantId -and $subscriptionId)) {
    throw "Missing SP Credentials In GitHub."
}

# SP Azure Auth
Write-Host "Authenticating Azure Credentials..."
az login --service-principal -u $clientId -p $clientSecret --tenant $tenantId | Out-Null
az account set --subscription $subscriptionId

# Confirm Container Exists
$containerExists = az storage container exists `
    --account-name $StorageAccount `
    --name $ContainerName `
    --query "exists" `
    --output tsv

if ($containerExists -ne "true") {
    Write-Host "Container '$ContainerName' Does Not Exist. Creating..."
    az storage container create --name $ContainerName --account-name $StorageAccount | Out-Null
}

# Generate SAS Token
$expiry = (Get-Date).AddYears(1).ToString("yyyy-MM-dd")
$sasToken = az storage container generate-sas `
    --account-name $StorageAccount `
    --name $ContainerName `
    --permissions rwl `
    --expiry $expiry `
    --https-only `
    --auth-mode login `
    --output tsv

if (-not $sasToken) { throw "Failed To Generate SAS token" }

Write-Host "SAS Token Generated Successfully"

# Upload SAS Token to GitHub
$secretExists = gh secret list --repo $Repo | Select-String -Pattern $SecretName

if ($secretExists) {
    Write-Host "Secret '$SecretName' Already Exists. Skipping Upload."
} else {
    gh secret set $SecretName --repo $Repo --body ($sasToken.Trim())
    Write-Host "SAS Token Uploaded To GitHub Secrets Successfully"
}
