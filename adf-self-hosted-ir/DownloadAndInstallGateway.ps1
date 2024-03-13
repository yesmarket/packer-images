function Create-Path()
{
    If(!(test-path -PathType container "C:\temp"))
    {
        New-Item -ItemType Directory -Path "C:\temp"
    }
}

function Download-Installer([string] $url)
{
    Write-Host "Starting ADF self-hosted IR download from $url"
    
    $process = Invoke-WebRequest $url -OutFile "C:\temp\IntegrationRuntime.msi"
    if ($process.ExitCode -ne 0 -and !([string]::IsNullOrEmpty($process.ExitCode)))
    {
        $exitcode = $process.ExitCode
        throw "Exit code: $exitcode - Failed to download ADF self-hosted IR"
    }

    Write-Host "Completed ADF self-hosted IR download"
}

function Install-Gateway()
{
    # uninstall any existing gateway
    UnInstall-Gateway

    Write-Host "Starting ADF self-hosted IR installation"
    
    $process = Start-Process "msiexec.exe" "/i C:\temp\IntegrationRuntime.msi /quiet /passive" -Wait -PassThru
    if ($process.ExitCode -ne 0)
    {
        $exitcode = $process.ExitCode
        throw "Exit code: $exitcode - Failed to install ADF self-hosted IR"
    }
    Start-Sleep -Seconds 30	

    Write-Host "Completed ADF self-hosted IR installation"
}

function Check-WhetherGatewayInstalled([string]$name)
{
    $installedSoftwares = Get-ChildItem "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    foreach ($installedSoftware in $installedSoftwares)
    {
        $displayName = $installedSoftware.GetValue("DisplayName")
        if($DisplayName -eq "$name Preview" -or  $DisplayName -eq "$name")
        {
            return $true
        }
    }

    return $false
}

function UnInstall-Gateway()
{
    $installed = $false
    if (Check-WhetherGatewayInstalled("Microsoft Integration Runtime"))
    {
        [void](Get-WmiObject -Class Win32_Product -Filter "Name='Microsoft Integration Runtime Preview' or Name='Microsoft Integration Runtime'" -ComputerName $env:COMPUTERNAME).Uninstall()
        $installed = $true
    }

    if ($installed -eq $false)
    {
        Write-Host "ADF self-hosted IR is not installed."
        return
    }

    Write-Host "ADF self-hosted IR has been uninstalled from this machine."
}

function Delete-Installer()
{
    $process = Remove-Item -Path "C:\temp\IntegrationRuntime.msi"
    if ($process.ExitCode -ne 0 -and !([string]::IsNullOrEmpty($process.ExitCode)))
    {
        $exitcode = $process.ExitCode
        throw "Exit code: $exitcode - Failed to delete ADF self-hosted IR installer"
    }

    Write-Host "Deleted ADF self-hosted IR installer"
}

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    Break
}

Create-Path
Download-Installer $Env:url
Install-Gateway
Delete-Installer
