# Demostración de seguridad — A2

**Autor:** Adrian Magallanes · **Matrícula:** 2025-2139

## Preparación

Grabar con rostro y voz visibles/audibles. Mostrar fecha y hora al comienzo (`Get-Date` en Windows). Comprobar los relojes de los equipos antes de grabar y declarar cualquier diferencia: los registros conservados no prueban sincronización NTP. Duración máxima: 10 minutos. Evitar mostrar contraseñas escritas o una running-config sin sanitizar.

## Recorrido sugerido (9 minutos y 30 segundos)

| Tiempo | Demostración |
|---|---|
| 0:00–0:40 | Identificación, fecha/hora, propósito y topología |
| 0:40–1:25 | Direccionamiento, conectividad y servicio IAS Running |
| 1:25–2:15 | Grupos y miembros AD; clientes RADIUS y políticas NPS |
| 2:15–4:30 | Niveles 0/5/10 en R1 y SW1, con comandos permitidos y bloqueados |
| 4:30–5:20 | Sesiones AUX en ambos equipos, `show users` y `show privilege` |
| 5:20–6:10 | SSH local, nivel 15 y origen remoto en VTY |
| 6:10–7:15 | Logs AAA/RADIUS y eventos NPS 6272/6273 |
| 7:15–8:45 | IAS detenido, ingreso local en ambos equipos y restauración de IAS |
| 8:45–9:30 | Repositorio, scripts, running-configs y conclusión de la demostración |

Las pantallas deben mostrar pruebas reales. No ejecutar `enable` antes de demostrar las restricciones de una cuenta RADIUS: la elevación cambia el nivel de la sesión. El carácter `#` por sí solo no identifica nivel 15; verificarlo con `show privilege`.

## Prueba de traceroute

Antes de grabar, repetir esta secuencia desde una sesión nueva de `radius10`, sin ejecutar `enable`:

1. Ejecutar `show privilege` y comprobar que indica nivel 10.
2. Desde R1, ejecutar `ping 10.21.39.130` y luego `traceroute 10.21.39.130`.
3. Desde SW1, ejecutar `ping 10.21.39.129` y luego `traceroute 10.21.39.129`.
4. Mostrar `configure terminal` rechazado para conservar la prueba de restricciones.

Se propone como destino el otro equipo Cisco de la misma red. Esta repetición está **pendiente de ejecución**: solo describir una ruta completada si aparece realmente la dirección de destino en el resultado. Introducir cada comando por separado y siempre con la IP; no dejar vacío el destino.

Si las sondas muestran asteriscos, interrumpir con **Ctrl+Mayús+6** y comprobar la conectividad con ping. Para demostrar únicamente el permiso del comando, usar `traceroute ?` y después **Ctrl+U** para limpiar la línea. Explicar que la ayuda acredita disponibilidad del comando y el ping acredita conectividad.

Las capturas originales se conservan: en R1 las sondas no recibieron respuesta y en SW1 el destino vacío produjo un error. Esas imágenes no documentan una ruta completada.

## Explicación del evento NPS rechazado

La captura del evento **6273, motivo 16**, corresponde al cliente **R1 (10.21.39.129)** y al nombre de usuario inexistente **`show privilege`**, introducido accidentalmente. Presentarla como rechazo de credenciales inválidas. No atribuirla a una contraseña incorrecta de `radius5` desde SW1.

Si se graba una nueva prueba con contraseña incorrecta, identificar su propio evento por hora, usuario y cliente RADIUS antes de relacionarlo con el intento.

## Publicación y entrega

1. Subir el video a YouTube con acceso para el docente.
2. Sustituir el aviso inicial del README por el enlace real del video.
3. Completar `entregables/AdrianMagallanes_2025-2139_A2.txt` con ese mismo enlace.
4. Revisar que los enlaces abran y que el video no exceda 10 minutos.

El nombre del TXT conserva la matrícula proporcionada: `2025-2139`. El trabajo y la demostración son individuales.
