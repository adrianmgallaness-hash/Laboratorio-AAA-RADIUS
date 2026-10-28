#Requires -RunAsAdministrator
param([string]$Directorio = (Join-Path $env:USERPROFILE 'Lab-AAA'))
$ErrorActionPreference = 'Stop'
Import-Module NPS
$privado = Join-Path $Directorio 'privado'
$publico = Join-Path $Directorio 'publico'
New-Item -ItemType Directory -Path $privado,$publico -Force | Out-Null
$original = Join-Path $privado 'NPS-original.xml'
$limpio = Join-Path $publico 'NPS-sanitized.xml'
Export-NpsConfiguration -Path $original
[xml]$documento = Get-Content -LiteralPath $original -Raw
foreach ($nodo in $documento.SelectNodes('//*[not(*)]')) {
    $nombre = $nodo.LocalName + ' ' + $nodo.GetAttribute('name')
    if ($nombre -match '(?i)secret|password|preshared|shared.?key') {
        $nodo.InnerText = 'REDACTED'
    }
}
# OuterXml funciona también cuando InnerText del documento es nulo.
$textoPublico = $documento.OuterXml
foreach ($cliente in Get-NpsRadiusClient) {
    $secreto = [string]$cliente.SharedSecret
    if ($secreto -and ($textoPublico.Contains($secreto) -or
        $textoPublico.Contains([Security.SecurityElement]::Escape($secreto)))) {
        throw 'Se detectó una clave sin eliminar. No publicar el archivo.'
    }
}
$documento.Save($limpio)
Write-Host "Copia pública: $limpio"
Write-Host 'El original contiene secretos: conservarlo privado. Revisar la copia antes de publicarla.'
