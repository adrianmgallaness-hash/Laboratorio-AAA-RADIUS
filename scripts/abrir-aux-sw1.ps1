# Abre el segundo puerto serie de SW1 en el entorno actual del laboratorio.
# En QEMU se agregó: -serial telnet:192.168.85.182:5010,server,nowait
$puttyLaboratorio = 'C:\Program Files\PuTTY\putty.exe'
Start-Process -FilePath $puttyLaboratorio -ArgumentList @('-telnet', '192.168.85.182', '-P', '5010', '-title', 'SW1 - AUX - Prueba AAA')
