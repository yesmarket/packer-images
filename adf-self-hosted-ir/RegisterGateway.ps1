param(
    [string]
    $authKey
)

function Validate-Input([string]$key)
{
    if ([string]::IsNullOrEmpty($key))
    {
        throw "Microsoft Integration Runtime Auth key is empty"
    }
}

function Register-Gateway([string]$key)
{
    $cmd = Get-CmdFilePath

    Write-Host "Start to register Microsoft Integration Runtime with key: $key."
    $process = Start-Process $cmd "-k $key" -Wait -PassThru -NoNewWindow
    if ($process.ExitCode -ne 0)
    {
        $exitcode = $process.ExitCode
        throw "Exit code: $exitcode - Failed to register Microsoft Integration Runtime"
    }
    Write-Host "Succeed to register Microsoft Integration Runtime."
}

function Get-CmdFilePath()
{
    $filePath = Get-ItemPropertyValue "hklm:\Software\Microsoft\DataTransfer\DataManagementGateway\ConfigurationManager" "DiacmdPath"
    if ([string]::IsNullOrEmpty($filePath))
    {
        throw "Get-InstalledFilePath: Cannot find installed File Path"
    }

    return (Split-Path -Parent $filePath) + "\dmgcmd.exe"
}

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    Break
}

Validate-Input $authKey

Register-Gateway $authKey
