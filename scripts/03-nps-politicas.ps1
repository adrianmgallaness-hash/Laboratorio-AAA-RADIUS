#Requires -RunAsAdministrator
# Consolidación de los comandos netsh utilizados; no sobrescribe políticas existentes.
$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory
$existentes = (& netsh.exe nps show np) -join "`n"
if ($LASTEXITCODE -ne 0) { throw 'No se pudieron consultar las políticas.' }
foreach ($nivel in 10,5,0) {
    if ($existentes -match [regex]::Escape("AAA_Cisco_Nivel$nivel")) {
        throw "Ya existe AAA_Cisco_Nivel$nivel. Revisar la política existente antes de aplicar."
    }
}
$orden = 1
foreach ($nivel in 10,5,0) {
    $sid = (Get-ADGroup "GG_RADIUS_Nivel$nivel").SID.Value
    # Indicador NPS 01 + Vendor-ID Cisco 00000009 + tipo 01 + longitud + texto.
    $avpair = "shell:priv-lvl=$nivel"
    $longitud = '{0:x2}' -f ([Text.Encoding]::ASCII.GetByteCount($avpair) + 2)
    $vsa = '010000000901' + $longitud + $avpair
    $argumentos = @(
        'nps','add','np', "name=AAA_Cisco_Nivel$nivel", 'state=ENABLE',
        "processingorder=$orden", 'policysource=0',
        'conditionid=0x1fb5', "conditiondata=$sid",
        'profileid=0x100f', 'profiledata=TRUE',
        'profileid=0x1009', 'profiledata=0x1',
        'profileid=0x6', 'profiledata=0x1',
        'profileid=0x1a', "profiledata=$vsa"
    )
    & netsh.exe @argumentos
    if ($LASTEXITCODE -ne 0) { throw "Error al crear la política de nivel $nivel." }
    $orden++
}
& netsh.exe nps show np
