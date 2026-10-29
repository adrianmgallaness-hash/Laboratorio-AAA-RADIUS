## Video demostrativo

**Pendiente de grabación y publicación en YouTube.** El enlace se colocará aquí, al inicio del repositorio. La demostración debe durar como máximo 10 minutos e incluir fecha y hora, rostro y voz del autor.

# Laboratorio AAA · RADIUS

Autenticación centralizada con Active Directory y NPS, autorización por niveles en Cisco y acceso local de recuperación.

**Autor:** Adrian Magallanes · **Matrícula:** 2025-2139 · **Práctica:** A2 · **Entorno:** GNS3

## Propósito

Proteger el acceso administrativo a un router y un switch: validar identidades contra Active Directory, asignar privilegios 0, 5 y 10 mediante RADIUS, restringir comandos y conservar acceso local cuando NPS no está disponible. El laboratorio incluye pruebas de consola, AUX, SSH y registros de aceptación y rechazo.

## Topología

### Topología real en GNS3

![Topología real: R1, SW1 y Windows Server](evidencias/imagenes/01-topologia.png)

### Diagrama lógico y direccionamiento

![Diagrama lógico con direccionamiento](docs/diagramas/topologia.svg)

| Equipo | Función | Dirección |
|---|---|---|
| R1 · Cisco c7200 | Router y cliente RADIUS | 10.21.39.129/29 |
| SW1 · Cisco IOSvL2 | Switch y cliente RADIUS | 10.21.39.130/29 |
| DC-2139 · Windows Server 2019 | Active Directory, DNS y NPS | 10.21.39.131/29 |

La red **10.21.39.128/29** utiliza los segmentos **21** y **39** derivados de la matrícula. Dominio: **infra2139.test**. Máscara: **255.255.255.248**.

## Navegación

- [Informe técnico: diseño, configuración, pruebas e incidencias](docs/LABORATORIO.md)
- [Galería de evidencias y matriz de requisitos](evidencias/README.md)
- [Running-configs de R1 y SW1 y exportación NPS](configs/README.md)
- [Scripts y secuencia de implementación](scripts/README.md)
- [Guion de demostración y requisitos de entrega](docs/DEMOSTRACION.md)
- [TXT de entrega A2 — video pendiente](entregables/AdrianMagallanes_2025-2139_A2.txt)

## Control de acceso implementado

| Entrada | Autenticación | Autorización |
|---|---|---|
| Consola y AUX | RADIUS; respaldo local si NPS no responde | Nivel enviado por NPS mediante `shell:priv-lvl` |
| SSH versión 2 | Usuario local `rescate2139` | Nivel 15 del usuario local |
| Elevación `enable` | Secreto administrativo separado | Acceso a nivel 15 |

La frase del enunciado sobre consola y auxiliar se aplica aquí al uso de **RADIUS en esas líneas**. SSH utiliza una lista local independiente. Esta interpretación mantiene el servicio SSH solicitado; no significa que SSH carezca de autenticación.

| Cuenta AD | Grupo | Nivel | Prueba distintiva |
|---|---|---:|---|
| `radius0` | `GG_RADIUS_Nivel0` | 0 | Consulta su nivel; no puede hacer ping ni configurar |
| `radius5` | `GG_RADIUS_Nivel5` | 5 | Puede hacer ping; no puede hacer traceroute ni configurar |
| `radius10` | `GG_RADIUS_Nivel10` | 10 | Tiene traceroute disponible; no puede configurar |

Los permisos se aplican mediante el nivel EXEC devuelto por NPS y las reglas de privilegio de IOS. No se configuró autorización RADIUS por cada comando ni contabilidad de cada comando ejecutado.

## Resultados

- R1 y SW1 alcanzan al servidor con **5/5** respuestas de ping.
- Ambos equipos asignan los niveles **0, 5 y 10** a las cuentas correspondientes.
- `show users` identifica sesiones reales en **consola, AUX y VTY**.
- SSH funciona en ambos sentidos con la cuenta local.
- Los registros muestran **Access-Accept**, `shell:priv-lvl=5` y **Authorization successful**.
- NPS conserva eventos **6272** de aceptación y **6273** de rechazo.
- Con IAS detenido, ambos equipos permiten la recuperación local; IAS se restauró a **Running**.

## Evidencias destacadas

Estas **21 capturas originales** muestran las pruebas principales. La [galería completa de evidencias](evidencias/README.md) conserva todas las imágenes, incluidas la detención y restauración de NPS, las líneas AAA y SSHv2.

### Conectividad y servidor

R1 alcanza al servidor NPS con 5 de 5 respuestas de ping.

![R1 alcanza al servidor NPS con 5 de 5 respuestas de ping.](evidencias/imagenes/02-R1-Conectividad.png)

SW1 tiene su interfaz de administración activa y alcanza al servidor.

![SW1 tiene su interfaz de administración activa y alcanza al servidor.](evidencias/imagenes/03-SW1-Conectividad.png)

DC-2139 utiliza la dirección 10.21.39.131 y el servicio IAS aparece en ejecución.

![DC-2139 utiliza la dirección 10.21.39.131 y el servicio IAS aparece en ejecución.](evidencias/imagenes/04-Servidor-red-NPS.png)

### Active Directory y políticas NPS

Los usuarios radius0, radius5 y radius10 pertenecen a sus grupos de privilegio.

![Los usuarios radius0, radius5 y radius10 pertenecen a sus grupos de privilegio.](evidencias/imagenes/05-Grupos-AD.png)

Las políticas NPS habilitadas relacionan los grupos con los atributos shell:priv-lvl.

![Las políticas NPS habilitadas relacionan los grupos con los atributos shell:priv-lvl.](evidencias/imagenes/07-NPS-Niveles10-5-completas.jpg)

### Privilegios y restricciones en R1

Nivel 0: consulta de privilegio permitida; ping y configuración bloqueados.

![Nivel 0: consulta de privilegio permitida; ping y configuración bloqueados.](evidencias/imagenes/10-R1-Nivel0.png)

Nivel 5: ping exitoso; traceroute y configuración bloqueados.

![Nivel 5: ping exitoso; traceroute y configuración bloqueados.](evidencias/imagenes/11-R1-Nivel5.png)

Nivel 10: traceroute disponible y configuración bloqueada. Los asteriscos indican que las sondas no recibieron respuesta.

![Nivel 10: traceroute disponible y configuración bloqueada. Los asteriscos indican que las sondas no recibieron respuesta.](evidencias/imagenes/12-R1-Nivel10.png)

### Privilegios y restricciones en SW1

Nivel 0: ping y configuración bloqueados.

![Nivel 0: ping y configuración bloqueados.](evidencias/imagenes/13-SW1-Nivel0.jpg)

Nivel 5: ping exitoso y configuración bloqueada.

![Nivel 5: ping exitoso y configuración bloqueada.](evidencias/imagenes/14-SW1-Nivel5.png)

Nivel 10: ayuda de traceroute disponible y configuración bloqueada. El error final se debe a un destino vacío.

![Nivel 10: ayuda de traceroute disponible y configuración bloqueada. El error final se debe a un destino vacío.](evidencias/imagenes/15-SW1-Nivel10.jpg)

### Acceso por AUX y SSH

R1: sesión actual en aux 0 con el usuario de nivel 5.

![R1: sesión actual en aux 0 con el usuario de nivel 5.](evidencias/imagenes/16-R1-AUX.jpg)

SW1: sesión actual en aux 0 con el usuario de nivel 5.

![SW1: sesión actual en aux 0 con el usuario de nivel 5.](evidencias/imagenes/17-SW1-AUX.jpg)

Conexión SSH desde SW1 hacia R1 con la cuenta local y privilegio 15.

![Conexión SSH desde SW1 hacia R1 con la cuenta local y privilegio 15.](evidencias/imagenes/18-R1-SSH.jpg)

Conexión SSH desde R1 hacia SW1; la sesión VTY identifica el acceso remoto.

![Conexión SSH desde R1 hacia SW1; la sesión VTY identifica el acceso remoto.](evidencias/imagenes/19-SW1-SSH.jpg)

### Registros de autenticación y autorización

R1: respuesta Access-Accept, atributo shell:priv-lvl=5 y autorización EXEC exitosa.

![R1: respuesta Access-Accept, atributo shell:priv-lvl=5 y autorización EXEC exitosa.](evidencias/imagenes/24b-R1-Logs-AAA-RADIUS.jpg)

SW1: respuesta Access-Accept, privilegio 5 y autorización EXEC exitosa.

![SW1: respuesta Access-Accept, privilegio 5 y autorización EXEC exitosa.](evidencias/imagenes/25b-SW1-Logs-AAA-RADIUS.jpg)

NPS: evento 6272 de acceso concedido a radius5 desde SW1.

![NPS: evento 6272 de acceso concedido a radius5 desde SW1.](evidencias/imagenes/26a-NPS-Aceptado-SW1.png)

NPS: evento 6273 de acceso denegado. En esta prueba se introdujo accidentalmente «show privilege» como usuario; se conserva como evidencia de rechazo de credenciales inválidas.

![NPS: evento 6273 de acceso denegado. En esta prueba se introdujo accidentalmente «show privilege» como usuario; se conserva como evidencia de rechazo de credenciales inválidas.](evidencias/imagenes/27-NPS-Rechazado-usuario-inexistente.png)

### Recuperación con usuario local

R1: acceso de rescate2139 por consola con privilegio 15 durante la prueba con IAS detenido.

![R1: acceso de rescate2139 por consola con privilegio 15 durante la prueba con IAS detenido.](evidencias/imagenes/29-R1-Respaldo-local.png)

SW1: acceso de rescate2139 por consola con privilegio 15 durante la misma prueba.

![SW1: acceso de rescate2139 por consola con privilegio 15 durante la misma prueba.](evidencias/imagenes/30-SW1-Respaldo-local.jpg)

## Estado de entrega

La implementación y las pruebas están documentadas. **El video todavía está pendiente** y el TXT contiene ese estado explícito. Este repositorio documenta la infraestructura mostrada: un router, un switch y un servidor. Si se entregan otras infraestructuras, cada una requiere su propio repositorio y video según el enunciado.

Las capturas son resultados originales del laboratorio. Los archivos de configuración reemplazan contraseñas, secretos y hashes por marcadores; las imágenes de IOS y los discos de las máquinas virtuales no se distribuyen.
