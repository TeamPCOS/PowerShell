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
        # Username
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
            $Global:D9Creds = Get-Credential -Message 'Enter Service ID credentials.'

            $Valid = $PrincipalContext.ValidateCredentials($D9Creds.UserName,$D9Creds.GetNetworkCredential().Password)

            If (!$Valid) {
                Write-Host "Authetication for $($D9Creds.Username) failed." -ForegroundColor Red
            }

        } While (!$Valid)

    }
    End
    {
        Write-Host "Credentials for $($D9Creds.UserName) successfully set to `$D9Creds object." -ForegroundColor Green
    }
}
