# Configuraciones capturadas del laboratorio

- [R1-running-config.sanitized.cfg](R1-running-config.sanitized.cfg): salida original de `show running-config` enviada por el estudiante después de guardar con resultado `[OK]`; recuperada de esa transcripción.
- [R1-startup-config.sanitized.cfg](R1-startup-config.sanitized.cfg): startup-config guardada y recuperada desde GNS3.
- [SW1-running-config.sanitized.cfg](SW1-running-config.sanitized.cfg): running-config enviada por el estudiante después de guardar en NVRAM, con el cambio HTTP/HTTPS posterior confirmado e incorporado como se detalla abajo.
- [NPS-sanitized.xml](NPS-sanitized.xml): exportación real de NPS recibida desde DC-2139. Contiene clientes y políticas; los campos sensibles fueron sustituidos por `REDACTED`. No contiene las cuentas de Active Directory.

Los marcadores <ENABLE_SECRET>, <LOCAL_USER_SECRET> y <RADIUS_SHARED_SECRET> sustituyen secretos y hashes. Deben reemplazarse por valores privados para recrear el laboratorio.

SW1: HTTP y HTTPS administrativos desactivados. Cambio confirmado por el estudiante con show running-config y guardado con resultado [OK]. La copia incorpora ese cambio verificado.

Estos archivos públicos son documentación. No pegarlos literalmente sin reemplazar los marcadores. El XML sanitizado no se debe importar como respaldo operativo: carece de los secretos originales. Para reproducir las políticas se incluyen scripts que obtienen los SID del dominio de destino.

