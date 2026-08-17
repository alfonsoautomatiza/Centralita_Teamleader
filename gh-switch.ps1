<#
.SYNOPSIS
    Cambiar entre cuentas de GitHub rapido.

.USAGE
    .\gh-switch.ps1 wertyMSD
    .\gh-switch.ps1 PabloMaloES
    .\gh-switch.ps1 status
    .\gh-switch.ps1 list
#>

param(
    [string]$Account
)

if (-not $Account -or $Account -eq "status") {
    gh auth status
    exit 0
}

if ($Account -eq "list") {
    Write-Host "Cuentas configuradas:" -ForegroundColor Yellow
    Write-Host "  wertyMSD      - Cuenta principal" -ForegroundColor Cyan
    Write-Host "  PabloMaloES   - Cuenta secundaria" -ForegroundColor Cyan
    exit 0
}

Write-Host "Cerrando sesion actual..." -ForegroundColor Yellow
gh auth logout --hostname github.com 2>$null

Write-Host "Logueando como $Account ..." -ForegroundColor Cyan
gh auth login --hostname github.com --web --git-protocol https

Write-Host ""
gh auth status
