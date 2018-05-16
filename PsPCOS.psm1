 <#
.Synopsis
   Creates a global credential object ($D9Creds) with the user's Service ID credentials.
.DESCRIPTION
   Creates a global credential object with the user's Service ID credentials. Cmdlet 
   accepts Username parameter and attempts to authenticate to the same domain as current
   Windows user.
.EXAMPLE
   Set-D9Creds
.EXAMPLE
   Set-D9Creds -Username US\<username>
#>
function Set-D9Creds
{
    [Alias('D9')]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Username
    )

    Begin
    {
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement

        $PrincipalContext = New-Object System.DirectoryServices.AccountManagement.PrincipalContext Domain,US

    }
    Process
    {
        Do {
            $Global:D9Creds = Get-Credential -Message 'Enter Service ID credentials.' -UserName $Username

            If ($D9Creds)
            {
                $Valid = $PrincipalContext.ValidateCredentials($D9Creds.UserName,$D9Creds.GetNetworkCredential().Password)

                If (!$Valid) {
                    Write-Host "Authetication for $($D9Creds.Username) failed." -ForegroundColor Red
                }
            }

        } While (!$Valid -and $D9Creds -ne $null)

    }
    End
    {
        Write-Host "Credentials for $($D9Creds.UserName) successfully set to `$D9Creds object." -ForegroundColor Green
    }
}

　
filter ConvertTo-KMG {
<#
.SYNOPSIS
Converts byte counts to Byte\KB\MB\GB\TB\PB format
.DESCRIPTION
Accepts an [int64] byte count, and converts to Byte\KB\MB\GB\TB\PB format
with decimal precision of 2
.EXAMPLE
3000 | convertto-kmg
#>

$bytecount = $_
switch ([math]::truncate([math]::log($bytecount,1024))) 
{
    0 {"$bytecount Bytes"}
    1 {"{0:n2} KB" -f ($bytecount / 1kb)}
    2 {"{0:n2} MB" -f ($bytecount / 1mb)}
    3 {"{0:n2} GB" -f ($bytecount / 1gb)}
    4 {"{0:n2} TB" -f ($bytecount / 1tb)}
    default {"{0:n2} PB" -f ($bytecount / 1pb)}
}
} 
