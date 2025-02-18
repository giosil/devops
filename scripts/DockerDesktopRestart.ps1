# Globals

$global:tool_root = $PSScriptRoot
$global:tool_name = $MyInvocation.MyCommand.Name
$global:tool_logf = "${global:tool_root}\${global:tool_name}.log"
$global:tool_chkf = "${global:tool_root}\${global:tool_name}_Check.log"
$global:tool_regf = "${global:tool_root}\${global:tool_name}_Registry.log"
$global:tool_peri = 5
$global:tool_arg0 = $args[0]

# Functions

function Tool-Init {
    if ([string]::IsNullOrEmpty($global:tool_root)) {
        $global:tool_root = "C:\tools"
    }
    if ([string]::IsNullOrEmpty($global:tool_name)) {
        $global:tool_name = "Tool"
    }
    if ([int]::TryParse($global:tool_arg0, [ref]$global:tool_peri)) {
        Write-Host "Setted period: $global:tool_peri"
    }
    else {
        $global:tool_peri = 5
    }
    $global:tool_logf = "${global:tool_root}\${global:tool_name}.log"
    $global:tool_chkf = "${global:tool_root}\${global:tool_name}_Check.log"
    $global:tool_regf = "${global:tool_root}\${global:tool_name}_Registry.log"
}

function Tool-Sleep {
    Tool-Log "Sleep 5 seconds..."
    Start-Sleep -Seconds 5
}

function Tool-Sleep-Period {
    Tool-Log "Sleep $global:tool_peri minutes..."
    Start-Sleep -Seconds ($global:tool_peri * 60)
}

function Tool-Delete-Log {
    Remove-Item -Path $global:tool_logf -Force -ErrorAction SilentlyContinue
}

function Tool-Log {
    param (
        [string] $message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $global:tool_logf -Value "${timestamp} - ${message}"
    Write-Host "${timestamp} - ${message}"
}

function Tool-Registry {
    param (
        [string] $message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $global:tool_regf -Value "${timestamp} - ${message}"
}

function Tool-Stop-Docker {
    # Tool-Log "Shutdown Docker..."
    # Start-Process -FilePath "C:\Program Files\Docker\Docker\DockerCli.exe" -ArgumentList "-Shutdown"

    Tool-Log "Stop Docker Desktop process..."
    Stop-Process -Name "Docker Desktop" -Force -ErrorAction SilentlyContinue

    Tool-Log "Stop com.docker processes..."
    Stop-Process -Name "com.docker.backend" -Force -ErrorAction SilentlyContinue
    Stop-Process -Name "com.docker.build" -Force -ErrorAction SilentlyContinue
    Stop-Process -Name "com.docker.dev-envs" -Force -ErrorAction SilentlyContinue

    Tool-Sleep

    Tool-Log "Clean Docker logs..."
    Remove-Item -Path "$HOME\AppData\Local\Docker\log\host\*" -Force
    Remove-Item -Path "$HOME\AppData\Local\Docker\log\vm\**" -Force

    Tool-Log "WSL shutdown..."
    try {
        wsl --shutdown
    }
    catch {
        Tool-Log "Exception: $($_.Exception.Message)"
    }
}

function Tool-Start-Docker {
    Tool-Log "Start Docker..."
    Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe"
}

# Procedure

Tool-Init

while($true) {
    
    Tool-Delete-Log

    # In some cases this command hangs.
    # docker ps > $global:tool_chkf

    # It is preferable to check kubernetes (with timeout)
    kubectl cluster-info > $global:tool_chkf

    if ($LASTEXITCODE -eq 0) {
        Tool-Log "Check exit code: $LASTEXITCODE"

        if ($global:tool_arg0 -eq 'force') {

            Tool-Log "Force restart..."

            Tool-Stop-Docker

            Tool-Start-Docker

            Tool-Registry "Docker restarted (forced)"

            exit 0
        }
    } 
    else {
        Tool-Log "Check exit code: $LASTEXITCODE"

        Tool-Stop-Docker

        Tool-Start-Docker

        Tool-Registry "Docker restarted"
    }

    Tool-Sleep-Period

    $HH = (Get-Date).Hour

    $MM = (Get-Date).Minute

    $HHMM = $HH * 100 + $MM

    if ($HHMM -ge 230 -and $HHMM -lt 235) {

        Tool-Log "Extra maintenance actions at $HHMM..."

        $ActScript = Join-Path -Path $PSScriptRoot -ChildPath "DeleteOldReplicaSets.ps1"

        Tool-Log "Execute $ActScript..."

        . $ActScript

        $ActScript = Join-Path -Path $PSScriptRoot -ChildPath "DeleteOldSecrets.ps1"

        Tool-Log "Execute $ActScript..."

        . $ActScript

    }
}
