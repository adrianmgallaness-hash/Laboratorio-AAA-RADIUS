## Video demostrativo

**Pendiente de grabación y publicación en YouTube.** El enlace se colocará aquí, al inicio del repositorio. La demostración debe durar como máximo 10 minutos e incluir fecha y hora, rostro y voz del autor.

# Laboratorio AAA · RADIUS

Autenticación centralizada con Active Directory y NPS, autorización por niveles en Cisco y acceso local de recuperación.

**Autor:** Adrian Magallanes · **Matrícula:** 2025-2139 · **Práctica:** A2 · **Entorno:** GNS3

## Propósito

Proteger el acceso administrativo a un router y un switch: validar identidades contra Active Directory, asignar privilegios 0, 5 y 10 mediante RADIUS, restringir comandos y conservar acceso local cuando NPS no está disponible. El laboratorio incluye pruebas de consola, AUX, SSH y registros de aceptación y rechazo.

## Topología

![Diagrama lógico con direccionamiento](docs/diagramas/topologia.svg)

<details>
<summary>Ver la topología real en GNS3</summary>

![Topología real](evidencias/imagenes/01-topologia.png)

</details>

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

## Estado de entrega

La implementación y las pruebas están documentadas. **El video todavía está pendiente** y el TXT contiene ese estado explícito. Este repositorio documenta la infraestructura mostrada: un router, un switch y un servidor. Si se entregan otras infraestructuras, cada una requiere su propio repositorio y video según el enunciado.

Las capturas son resultados originales del laboratorio. Los archivos de configuración reemplazan contraseñas, secretos y hashes por marcadores; las imágenes de IOS y los discos de las máquinas virtuales no se distribuyen.
