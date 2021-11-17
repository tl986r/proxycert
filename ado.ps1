# Setup new ADO repo activities

Write-Host -ForegroundColor Green "Installing azcli extension for ado if not installed"
$extado=`az extension show -n azure-devops`
if ($extado -eq $null) { az extension add -n azure-devops }

az login
$subscriptionID = Read-Host -Prompt 'What is your subscription ID (example xxxx-xxxx-xxxx-xxxx): '
az account set -s $subscriptionID
az account show
Write-Host -ForegroundColor Green "Please verify if we are on the right account."
Read-Host "Press any [ENTER] to continue..."

Write-Host -ForegroundColor Cyan "Create $env:USERPROFILE\Documents\ado_repo if it doesn't exist"
if ((Test-Path -Path $env:USERPROFILE\Documents\ado_repo) -ne $true) {
    New-Item -Path $env:USERPROFILE\Documents\ado_repo -ItemType Directory
}

$regionName = Read-Host -Prompt 'Which region do you want to deploy to (example westus2): '
$adoOrgUrl = Read-Host -Prompt 'What is your ADO Org URL (example https://dev.azure.com/ACC-Azure-06): '
$adoProjectName = Read-Host -Prompt 'What is your ADO project name (example 25899-vSPAM): '

$gitObj = az repos create --name "f5-$regionName" --org "$adoOrgUrl" --project "$adoProjectName" | ConvertFrom-Json

# git clone $gitObj.remoteUrl
cd $env:USERPROFILE\Documents\ado_repo\f5-$regionName
# copy source\.README.md $env:USERPROFILE\Documents\ado_repo\f5-$regionName
# copy source\.gitignore $env:USERPROFILE\Documents\ado_repo\f5-$regionName
# copy -rf srouce\att_mvm\* $env:USERPROFILE\Documents\ado_repo\f5-$regionName
