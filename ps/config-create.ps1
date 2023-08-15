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

Import-PSFConfig -Path ps/config-test.json | Register-PSFConfig

Get-PSFConfigValue -FullName MyProject.Build.Artifactory | Write-Verbose -Verbose

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Register-PSFConfig -Module MyProject -Scope SystemDefault