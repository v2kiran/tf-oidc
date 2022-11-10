param($header1, $header2)


# Set-PSRepository -Name psgallery -InstallationPolicy Trusted
# Install-Module FormatMarkdownTable
# Import-Module FormatMarkdownTable
Function ConvertTo-Markdown
{
    [CmdletBinding()]
    [OutputType([string])]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [PSObject[]]$collection
    )

    Begin
    {
        $items = @()
        $columns = @{}
    }

    Process
    {
        ForEach ($item in $collection)
        {
            $items += $item

            $item.PSObject.Properties | ForEach-Object {
                if ($null -ne $_.Value )
                {
                    if (-not $columns.ContainsKey($_.Name) -or $columns[$_.Name] -lt $_.Value.ToString().Length)
                    {
                        $columns[$_.Name] = $_.Value.ToString().Length
                    }
                }
            }
        }
    }

    End
    {
        ForEach ($key in $($columns.Keys))
        {
            $columns[$key] = [Math]::Max($columns[$key], $key.Length)
        }

        $header = @()
        ForEach ($key in $columns.Keys)
        {
            $header += ('{0,-' + $columns[$key] + '}') -f $key
        }
        $header -join ' | '

        $separator = @()
        ForEach ($key in $columns.Keys)
        {
            $separator += '-' * $columns[$key]
        }
        $separator -join ' | '

        ForEach ($item in $items)
        {
            $values = @()
            ForEach ($key in $columns.Keys)
            {
                $values += ('{0,-' + $columns[$key] + '}') -f $item.($key)
            }
            $values -join ' | '
        }
    }
}


$ser = @"
[
  {
    "Name": "WlanSvc",
    "DisplayName": "WLAN AutoConfig",
    "Status": 4
  },
  {
    "Name": "wlidsvc",
    "DisplayName": "Microsoft Account Sign-in Assistant",
    "Status": 4
  },
  {
    "Name": "wlpasvc",
    "DisplayName": "Local Profile Assistant Service",
    "Status": 1
  }
]
"@


$here = @"
| $header1  | $header2 |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |
"@


$s1 = $ser | ConvertFrom-Json
$n = @"
| Name  | DisplayName | Status |
$(foreach ($s in $s1 )
{

"|{0}|{1}|{2}`n" -f  $s.name, $s.DisplayName, $s.Status
})

"@
$n

# $($ser | ConvertFrom-Json | fml -HideStandardOutput -ShowMarkdown)
$n | Out-File $env:GITHUB_STEP_SUMMARY -Append
