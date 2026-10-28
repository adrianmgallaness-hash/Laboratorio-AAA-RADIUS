# Scripts del laboratorio

Los comandos ejecutados durante el laboratorio se consolidan aquí para su consulta y reproducción. Las versiones `.ps1` organizan esos pasos y solicitan los secretos en tiempo de ejecución; no se volvieron a ejecutar contra el dominio al preparar el repositorio.

## Secuencia

| Archivo | Dónde | Función |
|---|---|---|
| [01-ad-usuarios.ps1](01-ad-usuarios.ps1) | DC-2139, PowerShell administrador | Crear los grupos y las cuentas de prueba |
| [02-nps-servicio-clientes.ps1](02-nps-servicio-clientes.ps1) | DC-2139, PowerShell administrador | NPS, registro AD, clientes y firewall/auditoría |
| [03-nps-politicas.ps1](03-nps-politicas.ps1) | DC-2139, PowerShell administrador | Crear políticas para los niveles 10/5/0 |
| [04-exportar-nps.ps1](04-exportar-nps.ps1) | DC-2139, PowerShell administrador | Exportación privada y copia pública sin secretos |
| [05-verificacion.ps1](05-verificacion.ps1) | DC-2139, PowerShell administrador | Consultar AD, NPS, firewall y eventos |
| [R1-configuracion.cli](R1-configuracion.cli) | Consola local R1 | Bloques de configuración documentados |
| [SW1-configuracion.cli](SW1-configuracion.cli) | Consola local SW1 | Bloques de configuración documentados |
| [pruebas-ios.cli](pruebas-ios.cli) | R1/SW1 | Comandos para pruebas y captura de registros |
| [abrir-aux-r1.ps1](abrir-aux-r1.ps1) | PC anfitrión | Abrir AUX R1 por el puerto del emulador |
| [abrir-aux-sw1.ps1](abrir-aux-sw1.ps1) | PC anfitrión | Abrir AUX SW1 por el segundo puerto serie |

## Condiciones de uso

El dominio `infra2139.test` y los roles AD DS/DNS ya existían en DC-2139. Estos scripts no crean un bosque nuevo ni eliminan el dominio existente. Configurar primero las IP de la tabla del informe. Utilizar una sesión administrativa y mantener acceso por consola durante los cambios AAA.

Los `.cli` son secuencias para pegar por bloques, no programas ejecutables. Reemplazar `<ENABLE_SECRET>`, `<LOCAL_USER_SECRET>` y `<RADIUS_SHARED_SECRET>` por valores privados antes de aplicarlos. La clave compartida debe coincidir entre cada cliente Cisco y su entrada NPS.

La creación de claves RSA es un paso de puesta en marcha; no regenerarlas innecesariamente en un equipo ya configurado. Las listas AAA se definen antes de aplicarlas a las líneas. Conservar los secretos fuera del repositorio.

El script de políticas se detiene si encuentra una política con el mismo nombre; no modifica silenciosamente una política existente. La codificación VSA se basa en los valores verificados en la exportación de este laboratorio.

## Puertos AUX de GNS3

- R1/Dynamips: puerto AUX TCP **5004** en la GNS3 VM.
- SW1/QEMU: se añadió `-serial telnet:192.168.85.182:5010,server,nowait` a las opciones adicionales. El puerto principal sigue siendo consola; el segundo se verificó como `aux 0` con `show users`.
- La GNS3 VM tenía dirección **192.168.85.182** durante las pruebas. Ajustar esa dirección si cambia en otro equipo.

Estos puertos son accesos a líneas serie del emulador. La administración SSH dentro del laboratorio usa las direcciones **10.21.39.129/130** y las líneas VTY.
