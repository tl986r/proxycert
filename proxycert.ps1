# setup ATT Proxy and ATT hijacked certificate needed for supporting Azure operations
# 
cls 


#region Set Proxy in Environment Variables
Write-Host -ForegroundColor Cyan "Setting HTTP_PROXY to http://sub.proxy.att.com:8080"
$env:HTTP_PROXY="http://sub.proxy.att.com:8080"
[System.Environment]::SetEnvironmentVariable('HTTP_PROXY','http://sub.proxy.att.com:8080',[System.EnvironmentVariableTarget]::User)

Write-Host -ForegroundColor Cyan "Setting HTTPS_PROXY to http://sub.proxy.att.com:8080"
[System.Environment]::SetEnvironmentVariable('HTTPS_PROXY','http://sub.proxy.att.com:8080',[System.EnvironmentVariableTarget]::User)
$env:HTTPS_PROXY="http://sub.proxy.att.com:8080"

Write-Host -ForegroundColor Cyan "Setting NO_PROXY to .att.com,.sbc.com,localhost,127.0.0.1"
[System.Environment]::SetEnvironmentVariable('NO_PROXY','.att.com,.sbc.com,localhost,127.0.0.1',[System.EnvironmentVariableTarget]::User)
$env:NO_PROXY=".att.com,.sbc.com,localhost,127.0.0.1"
#endregion 

#region Install Certificate

if ((Test-Path -Path $env:USERPROFILE\certs) -ne $true) {
    New-Item -Path $env:USERPROFILE\certs -ItemType Directory
}

$localCertPath = "$($env:USERPROFILE)\certs\ATTINTERNALROOTv2.cer"

Write-Host -ForegroundColor Cyan "Attempting to download certificate ATTINTERNALROOTv2-1.cer"
Invoke-WebRequest -Uri http://aaf.it.att.com/ATTINTERNALROOTv2.crt -OutFile $localCertPath -ErrorVariable errGetCert -ErrorAction SilentlyContinue

if ($errGetCert -ne $null) {

$certBase64encoded = @"
-----BEGIN CERTIFICATE----- 
MIIDZTCCAk2gAwIBAgIQHmRivPBZa6JI/z+UpfTAQTANBgkqhkiG9w0BAQsFADBF 
MQswCQYDVQQGEwJVUzEMMAoGA1UECxMDQ1NPMQwwCgYDVQQKEwNBVFQxGjAYBgNV 
BAMTEUFUVElOVEVSTkFMUk9PVHYyMB4XDTE4MTIxNDAyMTYxOVoXDTQzMTIxNDAy 
MjYxOVowRTELMAkGA1UEBhMCVVMxDDAKBgNVBAsTA0NTTzEMMAoGA1UEChMDQVRU 
MRowGAYDVQQDExFBVFRJTlRFUk5BTFJPT1R2MjCCASIwDQYJKoZIhvcNAQEBBQAD 
ggEPADCCAQoCggEBAM9T9g2dmmAaO/CGkAkkyt+tm8WyKprNgMouPeDif2UV7pwY 
2glO8KJSuDjAezXjI7EV2dhpF6AdOMmjcdB/6/vSLi6rDiP9dU3zG/MJhHrEfpgB 
7//mnRRO2V6iScn4RMT537x3y7jJxpJucyir0GGP4bqmqKmKBptzEhmZp1qGypPf 
DZBvZttmkEw1ZrznSw0ksHl/Wh+HWrs1qnCUV1qs2XDIu0uWjRXUgYTxDVYIsJmV 
RWKVsXNUB/06F5gn5RHiTvm8KgYAjul2DB05Y54W6sGmlHJR+lYriQ2jcrea1qIy 
uM0hdf0pi0CbeZ0E6wLuM81mWHNfBDQNfypZnmkCAwEAAaNRME8wCwYDVR0PBAQD 
AgGGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFPqUApWGhGbtU84l74FzLhwm 
6XpMMBAGCSsGAQQBgjcVAQQDAgEAMA0GCSqGSIb3DQEBCwUAA4IBAQBz+JZjQDtn 
q4HmyPEBTjzdCFF2I4l63I7menyNjgxxEVQ+WfODPdsJ4HALwYXoTLVcrcy34rvo 
y67SeUmRDJZh0WHwJNMaaN2LDEl4z7kFljVy0kb3ld2yiy8njXg4kOfMOliC1TSx 
rMC47Dm+gTApNdWTVRVCvtygMctmI8XOE7ZtMLFQhIGx+fY2Y8+rEeQdjvf+Q4N0 
koWdduTK3IJm0VsYHfivf9+AdQ7/1iwbNjQ2J+g1F6Rn2lnCo+w8F0HC9a8FKDt3 
6iL11Lu4y4XK71lMGXquMch4pOhdgl2WMVXkxKxLuoYU8JGjONgWGPpezm7M6BvR 
m2pksIEp9TWv 
-----END CERTIFICATE-----
"@

$certBase64encoded | Out-File -FilePath $localCertPath

}


Write-Host -ForegroundColor Cyan "Installing ATTINTERNALROOTv2.cer Certificate in Root store (CurrentUser)"
Import-Certificate -FilePath $env:USERPROFILE\certs\ATTINTERNALROOTv2.cer -CertStoreLocation Cert:\CurrentUser\Root

#endregion

#region Configure ATTINTERNALROOTv2 Certificate
<#
# Issuer: CN=ATTINTERNALROOTv2, O=ATT, OU=CSO, C=US
# Subject: CN=ATTINTERNALROOTv2, O=ATT, OU=CSO, C=US
-----BEGIN CERTIFICATE----- 
MIIDZTCCAk2gAwIBAgIQHmRivPBZa6JI/z+UpfTAQTANBgkqhkiG9w0BAQsFADBF 
MQswCQYDVQQGEwJVUzEMMAoGA1UECxMDQ1NPMQwwCgYDVQQKEwNBVFQxGjAYBgNV 
BAMTEUFUVElOVEVSTkFMUk9PVHYyMB4XDTE4MTIxNDAyMTYxOVoXDTQzMTIxNDAy 
MjYxOVowRTELMAkGA1UEBhMCVVMxDDAKBgNVBAsTA0NTTzEMMAoGA1UEChMDQVRU 
MRowGAYDVQQDExFBVFRJTlRFUk5BTFJPT1R2MjCCASIwDQYJKoZIhvcNAQEBBQAD 
ggEPADCCAQoCggEBAM9T9g2dmmAaO/CGkAkkyt+tm8WyKprNgMouPeDif2UV7pwY 
2glO8KJSuDjAezXjI7EV2dhpF6AdOMmjcdB/6/vSLi6rDiP9dU3zG/MJhHrEfpgB 
7//mnRRO2V6iScn4RMT537x3y7jJxpJucyir0GGP4bqmqKmKBptzEhmZp1qGypPf 
DZBvZttmkEw1ZrznSw0ksHl/Wh+HWrs1qnCUV1qs2XDIu0uWjRXUgYTxDVYIsJmV 
RWKVsXNUB/06F5gn5RHiTvm8KgYAjul2DB05Y54W6sGmlHJR+lYriQ2jcrea1qIy 
uM0hdf0pi0CbeZ0E6wLuM81mWHNfBDQNfypZnmkCAwEAAaNRME8wCwYDVR0PBAQD 
AgGGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFPqUApWGhGbtU84l74FzLhwm 
6XpMMBAGCSsGAQQBgjcVAQQDAgEAMA0GCSqGSIb3DQEBCwUAA4IBAQBz+JZjQDtn 
q4HmyPEBTjzdCFF2I4l63I7menyNjgxxEVQ+WfODPdsJ4HALwYXoTLVcrcy34rvo 
y67SeUmRDJZh0WHwJNMaaN2LDEl4z7kFljVy0kb3ld2yiy8njXg4kOfMOliC1TSx 
rMC47Dm+gTApNdWTVRVCvtygMctmI8XOE7ZtMLFQhIGx+fY2Y8+rEeQdjvf+Q4N0 
koWdduTK3IJm0VsYHfivf9+AdQ7/1iwbNjQ2J+g1F6Rn2lnCo+w8F0HC9a8FKDt3 
6iL11Lu4y4XK71lMGXquMch4pOhdgl2WMVXkxKxLuoYU8JGjONgWGPpezm7M6BvR 
m2pksIEp9TWv 
-----END CERTIFICATE-----
#>

$certName = "ATTINTERNALROOTv2"
$certThumbprint = "6B990AFE1E6C591706E8432C4CF614C6C223BB33" 
Write-Host -ForegroundColor Cyan "Getting Certicate inside Root store $certName ($certThumbprint)"

# $cert = Get-ChildItem Cert:\CurrentUser\Root | ? { $_.Thumbprint -eq $certThumbprint }
$cert = Get-ChildItem Cert:\CurrentUser\Root\$certThumbprint
Write-Host $cert

# Write-Host -ForegroundColor Green "Please verify certificate details"
# Read-Host "Press any [ENTER] to continue..."

# Export certificate temporary to be able to copy Base64 encoded later.
Export-Certificate -Cert $cert -FilePath "$($env:USERPROFILE)\Documents\$certName-DER.cer" -Type CERT -NoClobber
certutil -encode "$($env:USERPROFILE)\Documents\$certName-DER.cer" "$($env:USERPROFILE)\Documents\$certName.cer"

Remove-Item -Path "$($env:USERPROFILE)\Documents\$certName-DER.cer"

$certContent = Get-Content "$($env:USERPROFILE)\Documents\$certName.cer"

$certComment=@"

# Issuer: $($cert.Issuer)
# Subject: $($cert.Subject)
"@

Write-Host -ForegroundColor Cyan "The following will be added to each file bellow and will be open automatically. Please verify file is updated correctly and close it."
$certComment
$certContent

Write-Host -ForegroundColor Cyan "Updating file: C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\Lib\site-packages\websocket\cacert.pem"
$cacertPath="C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\Lib\site-packages\websocket\cacert.pem"
Add-Content $cacertPath $certComment
Add-Content $cacertPath $certContent
# Review Changes prompt
#& $cacertPath
#Read-Host "Press any key to continue..."

Write-Host -ForegroundColor Cyan "Updating file: C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\Lib\site-packages\certifi\cacert.pem"
$cacertPath="C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\Lib\site-packages\certifi\cacert.pem"
Add-Content $cacertPath $certComment
Add-Content $cacertPath $certContent
# Review Changes prompt
#& $cacertPath
#Read-Host "Press any key to continue..."

Write-Host -ForegroundColor Cyan "Updating file: C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\Lib\site-packages\pip\_vendor\certifi\cacert.pem"
$cacertPath="C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\Lib\site-packages\pip\_vendor\certifi\cacert.pem"
Add-Content $cacertPath $certComment
Add-Content $cacertPath $certContent
# Review Changes prompt
#& $cacertPath
#Read-Host "Press any key to continue..."

Remove-Item -Path "$($env:USERPROFILE)\Documents\$certName.cer"
#endregion

#region Setting Git Global variables
Write-Host -ForegroundColor Green "Git configuration to use certificate and proxy setting."
Write-Host -ForegroundColor Cyan "Setting Git Configuration (optional). Only continue if Git is installed."
$ans = Read-Host "Press [Y] key to continue Git Setup"

if ($ans -ieq 'Y') {

    Write-Host -ForegroundColor Cyan "Setting Git HTTP Proxy settings: git config --global http.proxy $($env:HTTP_PROXY)"
    git config --global http.proxy $env:HTTP_PROXY

    Write-Host -ForegroundColor Cyan "Setting Git HTTPS Proxy settings: git config --global https.proxy $($env:HTTPS_PROXY)"
    git config --global https.proxy $env:HTTPS_PROXY

    Write-Host -ForegroundColor Cyan "Setting Git sslCAInfo settings: git config --global http.sslCAInfo $localCertPath"
    git config --global http.sslCAInfo $localCertPath
    
    Write-Host -ForegroundColor Cyan "Setting Git to use Windows settings: git config --global http.sslbackend=schannel"
    git config --global http.sslbackend=schannel
}

#endregion

cd $env:USERPROFILE\Documents\ado_repo
Write-Host -ForegroundColor Cyan "Setup completed!"


# # Setup new ADO repo activities
# az login
# $subscriptionID = Read-Host -Prompt 'What is your subscription ID (example xxxx-xxxx-xxxx-xxxx): '
# az account set -s $subscriptionID
# az account show
# Write-Host -ForegroundColor Green "Please verify for the correct subscription "
# Read-Host "Press any [ENTER] to continue..."

# Write-Host -ForegroundColor Cyan "Create $env:USERPROFILE\Documents\ado_repo if it doesn't exist"
# if ((Test-Path -Path $env:USERPROFILE\Documents\ado_repo) -ne $true) {
#     New-Item -Path $env:USERPROFILE\Documents\ado_repo -ItemType Directory
# }

# $regionName = Read-Host -Prompt 'Which region do you want to deploy to (example westus2): '
# $adoOrgUrl = Read-Host -Prompt 'What is your ADO Org URL (example https://dev.azure.com/ACC-Azure-06): '
# $adoProjectName = Read-Host -Prompt 'What is your ADO project name (example 25899-vSPAM): '

# $gitObj = az repos create --name "f5-$regionName" --org "$adoOrgUrl" --project "$adoProjectName" | ConvertFrom-Json

# # git clone $gitObj.remoteUrl
# cd $env:USERPROFILE\Documents\ado_repo\f5-$regionName
# # copy source\.README.md $env:USERPROFILE\Documents\ado_repo\f5-$regionName
# # copy source\.gitignore $env:USERPROFILE\Documents\ado_repo\f5-$regionName
# # copy -rf srouce\att_mvm\* $env:USERPROFILE\Documents\ado_repo\f5-$regionName
