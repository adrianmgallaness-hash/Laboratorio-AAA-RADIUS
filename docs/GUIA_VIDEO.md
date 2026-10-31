# Guía práctica para grabar el video — A2

**Autor:** Adrian Magallanes  
**Matrícula:** 2025-2139  
**Duración objetivo:** 8 a 9 minutos. Máximo permitido: 10 minutos.

> Usa esta guía como apoyo, pero explica con tus propias palabras y muestra únicamente resultados reales de tu laboratorio. No muestres ni pronuncies contraseñas, secretos RADIUS, hashes ni llaves privadas.

## Antes de grabar

- Activa cámara y micrófono. Tu rostro debe verse durante la demostración y tu voz debe escucharse.
- Prepara tres ventanas: GNS3, consola de R1/SW1 y Windows Server.
- En Windows PowerShell deja listo `Get-Date`.
- Comprueba que el servicio NPS esté activo: `Get-Service IAS`.
- Ten abiertas las sesiones que usarás, pero comienza las demostraciones de privilegios desde una sesión nueva para que se vea el inicio de sesión.
- Pon el video en 1080p o una resolución donde se lean los comandos.
- Mantén el total por debajo de 10 minutos. No hagas una configuración larga en vivo: muestra la verificación y explica el resultado.

## Guion de grabación

### 0:00–0:40 — Presentación, identidad y hora

Muestra tu rostro y di, con tus palabras:

> Soy Adrian Magallanes, matrícula 2025-2139. Esta es mi práctica A2 de Seguridad de Redes: autenticación, autorización y contabilidad con AAA, RADIUS, Active Directory y NPS.

En PowerShell ejecuta:

```powershell
Get-Date
```

Explica que el video demuestra una topología individual formada por R1, SW1 y el servidor DC-2139.

### 0:40–1:15 — Topología e IP

Muestra GNS3. Señala:

- R1 — `10.21.39.129/29`
- SW1 (VLAN 1) — `10.21.39.130/29`
- DC-2139 / NPS — `10.21.39.131/29`
- Red — `10.21.39.128/29`

Di que la red se derivó de los segmentos 21 y 39 de la matrícula.

### 1:15–1:45 — Servidor, AD y NPS

En Windows PowerShell ejecuta:

```powershell
Get-Service IAS
Import-Module ActiveDirectory
foreach ($nivel in 0, 5, 10) {
  $grupo = Get-ADGroup "GG_RADIUS_Nivel$nivel"
  Get-ADGroupMember $grupo |
    Select-Object @{Name="Grupo";Expression={$grupo.Name}},SamAccountName
}
Get-NpsRadiusClient | Select-Object Name,Address,Enabled | Format-Table -AutoSize
```

Explica brevemente:

- IAS/NPS aparece **Running**.
- Los grupos son Nivel 0, 5 y 10.
- R1 y SW1 están registrados como clientes RADIUS.

### 1:45–3:30 — Niveles de privilegio

Hazlo primero en R1 y luego de forma breve en SW1. No ejecutes `enable` antes de mostrar las restricciones.

**Nivel 0:** inicia sesión con el usuario de nivel 0. Después:

```text
show privilege
ping 10.21.39.131
configure terminal
```

Explica: tiene nivel 0, puede consultar su nivel, pero no puede hacer ping ni configurar.

**Nivel 5:** inicia sesión nueva con el usuario de nivel 5. Después:

```text
show privilege
ping 10.21.39.131
configure terminal
```

Explica: puede hacer ping, pero configurar está bloqueado.

**Nivel 10:** inicia sesión nueva con el usuario de nivel 10. Después:

```text
show privilege
traceroute ?
configure terminal
```

Explica: el comando traceroute está disponible en nivel 10, mientras que el modo de configuración continúa bloqueado.

> El símbolo `#` no prueba por sí solo que tengas privilegio 15. La evidencia válida es la salida de `show privilege`.

### 3:30–4:15 — Prueba limpia de traceroute

Para intentar una ruta real, usa una sesión nueva de nivel 10, sin `enable`:

**Desde R1**

```text
show privilege
ping 10.21.39.130
traceroute 10.21.39.130
```

**Desde SW1**

```text
show privilege
ping 10.21.39.129
traceroute 10.21.39.129
```

Solo afirma que la ruta fue completada si en la salida aparece el destino. Si salen `* * *`, interrúmpelo con **Ctrl+Mayús+6** y, si hace falta, `x`. Di que el ping ya demuestra conectividad y `traceroute ?` demuestra la disponibilidad del comando. No dejes el destino vacío.

### 4:15–5:00 — Consola y AUX con RADIUS

Muestra en R1 y SW1 una sesión de consola y otra AUX autenticadas con una cuenta RADIUS. En cada uno ejecuta:

```text
show privilege
show users
```

Explica que `con 0` representa consola, `aux 0` representa el puerto auxiliar y el asterisco identifica la sesión actual.

### 5:00–5:40 — SSH seguro y usuario local

Desde un equipo Cisco, abre una sesión SSH hacia el otro usando la cuenta **local de rescate**. Si se requiere compatibilidad de cifrado entre estas imágenes, usa la sintaxis que ya probaste:

```text
ssh -v 2 -c aes128-cbc -l rescate2139 10.21.39.129
```

o, en el sentido inverso:

```text
ssh -v 2 -c aes128-cbc -l rescate2139 10.21.39.130
```

Después muestra:

```text
show privilege
show users
show ip ssh
```

Explica que VTY acepta solamente SSH y usa la lista local independiente; consola y AUX usan RADIUS con respaldo local.

### 5:40–6:35 — Logs AAA/RADIUS

En R1 o SW1, con privilegio administrativo, ejecuta:

```text
show logging | include LOGIN|AAA|RADIUS|AUTH
```

Muestra también que los diagnósticos están habilitados temporalmente:

```text
show debugging
```

Explica que ves autenticaciones correctas, autenticaciones rechazadas y el intercambio RADIUS. Después de grabar, desactiva los diagnósticos para no dejar ruido:

```text
undebug all
```

### 6:35–7:15 — Eventos NPS

En PowerShell ejecuta:

```powershell
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=6272,6273} -MaxEvents 4 |
  Format-List TimeCreated,Id,Message
```

Explica:

- **6272**: NPS concedió acceso.
- **6273**: NPS denegó acceso.

No atribuyas el evento 6273 guardado a una contraseña incorrecta de `radius5` desde SW1. Esa captura pertenece a R1 y al usuario inexistente `show privilege`, escrito accidentalmente; es evidencia válida de rechazo de credenciales inválidas.

### 7:15–8:00 — Respaldo local cuando NPS no responde

Muestra en Windows:

```powershell
Stop-Service IAS
Get-Service IAS
```

En R1 y SW1 muestra que puedes acceder con el usuario local de rescate y ejecutar:

```text
show privilege
show users
```

Después restaura inmediatamente el servicio:

```powershell
Start-Service IAS
Get-Service IAS
```

Explica que el respaldo local evita perder la administración cuando el servidor RADIUS deja de responder.

### 8:00–8:40 — Repositorio y cierre

Abre el repositorio de GitHub y enseña:

- README: propósito, topología y evidencias.
- `configs/`: running-configs sanitizados y exportación NPS.
- `scripts/`: scripts utilizados.
- `evidencias/`: capturas y matriz de requisitos.
- `docs/`: informe y guía de demostración.

Cierra con una frase propia parecida a:

> Se verificó la autenticación centralizada contra NPS, autorización por niveles, acceso de consola y AUX, SSH local, registros de seguridad y respaldo local ante la indisponibilidad de NPS.

## Lista final antes de subir

- [ ] Mi cara aparece y mi voz se escucha.
- [ ] Mostré hora y fecha.
- [ ] El video dura menos de 10 minutos.
- [ ] No se ven contraseñas, secretos, hashes ni llaves privadas.
- [ ] El video fue subido a YouTube con acceso para el docente.
- [ ] Reemplacé el aviso inicial del README por el enlace de YouTube.
- [ ] Añadí el mismo enlace al archivo `AdrianMagallanes_2025-2139_A2.txt`.
