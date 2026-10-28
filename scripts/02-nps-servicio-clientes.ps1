#Requires -RunAsAdministrator
$ErrorActionPreference = 'Stop'
$instalacion = Install-WindowsFeature NPAS -IncludeManagementTools
if (-not $instalacion.Success) { throw 'No se pudo instalar NPAS.' }
Import-Module NPS
& netsh.exe nps add registeredserver infra2139.test DC-2139
if ($LASTEXITCODE -ne 0) { throw 'No se pudo registrar NPS en Active Directory.' }
Set-Service IAS -StartupType Automatic
Start-Service IAS

$clientes = @(
    @{Name='R1'; Address='10.21.39.129'},
    @{Name='SW1'; Address='10.21.39.130'}
)
foreach ($cliente in $clientes) {
    $actual = Get-NpsRadiusClient | Where-Object Name -eq $cliente.Name
    if ($actual) {
        if ($actual.Address -ne $cliente.Address -or -not $actual.Enabled) {
            throw "Revisar cliente existente $($cliente.Name): dirección o estado diferente."
        }
        continue
    }
    $claveSegura = Read-Host "Secreto RADIUS para $($cliente.Name)" -AsSecureString
    $puntero = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($claveSegura)
    try {
        $claveTexto = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($puntero)
        New-NpsRadiusClient -Name $cliente.Name -Address $cliente.Address -SharedSecret $claveTexto | Out-Null
    } finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($puntero)
        Remove-Variable claveTexto,claveSegura -ErrorAction SilentlyContinue
    }
}

if (-not (Get-NetFirewallRule -Name 'LAB-AAA-RADIUS-In' -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name 'LAB-AAA-RADIUS-In' `
        -DisplayName 'Laboratorio AAA - RADIUS desde R1 y SW1' `
        -Direction Inbound -Action Allow -Protocol UDP -LocalAddress 10.21.39.131 `
        -LocalPort 1812,1813 -RemoteAddress 10.21.39.129,10.21.39.130 -Profile Any | Out-Null
}
& auditpol.exe /set '/subcategory:{0CCE9243-69AE-11D9-BED3-505054503030}' /success:enable /failure:enable
if ($LASTEXITCODE -ne 0) { throw 'No se pudo habilitar la auditoría NPS.' }
Get-Service IAS
Get-NpsRadiusClient | Select-Object Name,Address,Enabled
