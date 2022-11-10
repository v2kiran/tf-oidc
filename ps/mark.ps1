param($header1,$header2)


Function ConvertTo-Markdown {
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

    Begin {
        $items = @()
        $columns = @{}
    }

    Process {
        ForEach($item in $collection) {
            $items += $item

            $item.PSObject.Properties | ForEach-Object {
                if ($null -ne $_.Value ){
                    if(-not $columns.ContainsKey($_.Name) -or $columns[$_.Name] -lt $_.Value.ToString().Length) {
                        $columns[$_.Name] = $_.Value.ToString().Length
                    }
                }
            }
        }
    }

    End {
        ForEach($key in $($columns.Keys)) {
            $columns[$key] = [Math]::Max($columns[$key], $key.Length)
        }

        $header = @()
        ForEach($key in $columns.Keys) {
            $header += ('{0,-' + $columns[$key] + '}') -f $key
        }
        $header -join ' | '

        $separator = @()
        ForEach($key in $columns.Keys) {
            $separator += '-' * $columns[$key]
        }
        $separator -join ' | '

        ForEach($item in $items) {
            $values = @()
            ForEach($key in $columns.Keys) {
                $values += ('{0,-' + $columns[$key] + '}') -f $item.($key)
            }
            $values -join ' | '
        }
    }
}

$ser = gsv wl* | select Name,DisplayName,Status



$here = @"
| $header1  | $header2 |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |

$($ser | convertto-markdown)


"@

$here

# | Name  | DisplayName | Status |
# $(foreach ($s in $ser)
# {
# `| $s.name `| $s.DisplayName `| $s.Status `|
# })


$here | out-file  $env:GITHUB_STEP_SUMMARY -Append