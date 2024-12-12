$log_file = "C:\tools\DockerDesktopRestart.log"
Remove-Item -Path $log_file -Force -ErrorAction SilentlyContinue

function _log($msg) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $log_file -Value "$timestamp - $msg"
    Write-Output "$timestamp - $msg"
}

docker ps > "C:\tools\DockerPs.log"
if ($LASTEXITCODE -eq 0) {
    _log "Docker ps ha restituito $LASTEXITCODE"
    Exit
} 
else {
    _log "Docker ps ha restituito $LASTEXITCODE"
}

_log "Stop-Process Docker Desktop..."
Stop-Process -Name "Docker Desktop" -Force -ErrorAction SilentlyContinue

_log "Wait 10 seconds..."
Start-Sleep -Seconds 10

_log "Stop other docker processes..."

Stop-Process -Name "com.docker.backend" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "com.docker.build" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "com.docker.dev-envs" -Force -ErrorAction SilentlyContinue

_log "Wait 10 seconds..."
Start-Sleep -Seconds 10

_log "Remove docker log files..."
Remove-Item -Path "C:\Users\silvestris.admin\AppData\Local\Docker\log\host\*" -Force
Remove-Item -Path "C:\Users\silvestris.admin\AppData\Local\Docker\log\vm\**" -Force

_log "WSL shutdown..."
try {
    wsl --shutdown
}
catch {
    _log "Errore: $($_.Exception.Message)"
}

_log "Start-Process Docker Desktop..."
Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe"

_log "Task completed..."