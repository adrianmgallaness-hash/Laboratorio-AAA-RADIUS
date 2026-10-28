#Requires -RunAsAdministrator
# Requiere el dominio infra2139.test ya configurado.
$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory
$rutaUsuarios = 'CN=Users,DC=infra2139,DC=test'
foreach ($nivel in 0, 5, 10) {
    $nombreGrupo = "GG_RADIUS_Nivel$nivel"
    if (-not (Get-ADGroup -Filter "SamAccountName -eq '$nombreGrupo'")) {
        New-ADGroup -Name $nombreGrupo -SamAccountName $nombreGrupo `
            -GroupScope Global -GroupCategory Security -Path $rutaUsuarios `
            -Description "Acceso administrativo de red: nivel $nivel"
    }
    $usuario = "radius$nivel"
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$usuario'")) {
        $claveUsuario = Read-Host "Contraseña para $usuario" -AsSecureString
        New-ADUser -Name $usuario -SamAccountName $usuario `
            -UserPrincipalName "$usuario@infra2139.test" -Path $rutaUsuarios `
            -AccountPassword $claveUsuario -Enabled $true -ChangePasswordAtLogon $false `
            -Description "Prueba RADIUS de nivel $nivel"
        Remove-Variable claveUsuario
    }
    Add-ADGroupMember -Identity $nombreGrupo -Members $usuario
}
foreach ($nivel in 0, 5, 10) {
    Get-ADGroupMember "GG_RADIUS_Nivel$nivel" |
        Select-Object @{Name='Nivel';Expression={$nivel}}, SamAccountName
}
