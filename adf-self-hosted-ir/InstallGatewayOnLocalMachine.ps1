function Get-Path()
{
    $path = "C:\temp"
    If(!(test-path -PathType container $path))
    {
        New-Item -ItemType Directory -Path $path
    }

    $outFile = "$path\IntegrationRuntime.msi"

    return $outFile
}

function Download-Installer([string] $url, [string] $path)
{
    Write-Host "Starting ADF self-hosted IR download"

    $process = Invoke-WebRequest $url -OutFile $path
    if ($process.ExitCode -ne 0)
    {
        throw "Failed to download ADF self-hosted IR. Exit code: $($process.ExitCode)"
    }

    Write-Host "Completed ADF self-hosted IR download"
}

function Install-Gateway([string] $path)
{
    # uninstall any existing gateway
    UnInstall-Gateway

    Write-Host "Starting ADF self-hosted IR installation"
    
    $process = Start-Process "msiexec.exe" "/i $path /quiet /passive" -Wait -PassThru
    if ($process.ExitCode -ne 0)
    {
        throw "Failed to install ADF self-hosted IR. msiexec exit code: $($process.ExitCode)"
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

    if (Check-WhetherGatewayInstalled("Microsoft Integration Runtime"))
    {
        [void](Get-WmiObject -Class Win32_Product -Filter "Name='Microsoft Integration Runtime Preview' or Name='Microsoft Integration Runtime'" -ComputerName $env:COMPUTERNAME).Uninstall()
        $installed = $true
    }

    if ($installed -eq $false)
    {
        Write-Host "Microsoft Integration Runtime is not installed."
        return
    }

    Write-Host "Microsoft Integration Runtime has been uninstalled from this machine."
}

function Delete-Installer([string] $path)
{
    $process = Remove-Item -Path $path
    if ($process.ExitCode -ne 0)
    {
        throw "Failed to delete ADF self-hosted IR installer. msiexec exit code: $($process.ExitCode)"
    }

    Write-Host "Deleted ADF self-hosted IR installer"
}


If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    Break
}

$path = Get-Path()
Download-Installer $Env:url $path
Install-Gateway $path
Delete-Installer $path
