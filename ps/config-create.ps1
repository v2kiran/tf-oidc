# Gather settings to export
$configToExport = @()
$configToExport += Set-PSFConfig -FullName "MyProject.Build.Repository" -Value "foo" -SimpleExport -PassThru
$configToExport += Set-PSFConfig -FullName "MyProject.Build.Artifactory" -Value "bar" -SimpleExport -PassThru
$configToExport += Set-PSFConfig -FullName "SomeModule.SomeSetting" -Value "1" -SimpleExport -PassThru
$configToExport += Set-PSFConfig -FullName "SomeModule.SomeSetting2" -Value 2 -SimpleExport -PassThru
$configToExport += Set-PSFConfig -FullName "SomeModule2.SomeSetting" -Value "3" -SimpleExport -PassThru
$configToExport += Set-PSFConfig -FullName "SomeModule2.SomeSetting2" -Value $true -SimpleExport -PassThru

# Write the configuration file
$configToExport | Export-PSFConfig -OutPath .\config-test.json


Import-PSFConfig -Path ps/config-test.json -PassThru | Register-PSFConfig
Import-PSFConfig -Path ps/config-test.psd1 -Schema MetaJson -PassThru

Import-PSFConfig -Path ps/object.psd1 -Schema MetaJson
Get-PSFConfigValue -FullName Bartender.Fridge.Size | fl *
Get-PSFConfigValue -FullName Bartender.Fridge.Content


Import-PSFConfig -path .\ps\dynamic.json -PassThru

Get-PSFConfigValue -FullName MyProject.Build.Artifactory | Write-Verbose -Verbose
Get-PSFConfigValue -FullName SomeModule2.SomeSetting | Write-Verbose -Verbose


Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Register-PSFConfig -Module MyProject -Scope UserMandatory

<#
/etc/xdg/PowerShell
#>

Get-PSFConfigValue

# store full objects
Get-Item C:\temp\AdminTools | ConvertTo-PSFClixml
gsv wa* | ConvertTo-PSFClixml



- run: |
bearerToken=${ACTIONS_ID_TOKEN_REQUEST_TOKEN}
runtimeUrl=${ACTIONS_ID_TOKEN_REQUEST_URL}
runtimeUrl="${runtimeUrl}&audience=api://AzureADTokenExchange"
echo ::set-output name=JWTTOKEN::$(curl -H "Authorization: bearer $bearerToken" $runtimeUrl | jq -r ".value")
id: tokenForAAD