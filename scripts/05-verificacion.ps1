#Requires -RunAsAdministrator
# Consultas de evidencia; no altera el servicio IAS.
Import-Module ActiveDirectory
hostname
Get-Date
Get-NetIPConfiguration
Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias,IPAddress,PrefixLength
Get-WindowsFeature AD-Domain-Services,DNS,NPAS
Get-Service IAS
Get-NpsRadiusClient | Select-Object Name,Address,Enabled
foreach ($nivel in 0,5,10) {
    Get-ADGroupMember "GG_RADIUS_Nivel$nivel" |
        Select-Object @{Name='Grupo';Expression={"GG_RADIUS_Nivel$nivel"}},SamAccountName
}
& netsh.exe nps show np
& auditpol.exe /get '/subcategory:{0CCE9243-69AE-11D9-BED3-505054503030}'
Get-WinEvent -FilterHashtable @{LogName='Security';Id=6272,6273} -MaxEvents 4 |
    Format-List TimeCreated,Id,Message
Get-NetFirewallRule -Name 'LAB-AAA-RADIUS-In' | Get-NetFirewallPortFilter
# Prueba manual de recuperación (ejecutar por etapas, con sesión administrativa abierta):
# Stop-Service IAS; Get-Service IAS
# Entrar por consola con la cuenta LOCAL en R1 y SW1. Capturar show privilege/show users.
# Start-Service IAS; Get-Service IAS
