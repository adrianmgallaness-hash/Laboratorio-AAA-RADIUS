# Puerto serie AUX de Dynamips verificado en el laboratorio.
$puttyLaboratorio = 'C:\Program Files\PuTTY\putty.exe'
Start-Process -FilePath $puttyLaboratorio -ArgumentList @('-telnet','192.168.85.182','-P','5004','-title','R1 - AUX - Prueba AAA')
