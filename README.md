# 🛡️ Bloqueador de Dominios Maliciosos

Script en Bash diseñado para bloquear automáticamente sitios web maliciosos, adictivos o no deseados desde Linux, basado en listas públicas y control manual por el usuario.

---

## 🚀 Características

- ✅ Bloqueo de cientos de dominios maliciosos con lista pública (StevenBlack).
- ✅ Añade dominios manualmente (como facebook.com, tiktok.com, etc.).
- ✅ Permite desbloquear dominios fácilmente.
- ✅ Agenda su ejecución automática (inicio del sistema, diario, semanal, mensual o cron personalizado).
- ✅ Interfaz en terminal limpia y con submenús organizados.
- ✅ Muestra los dominios bloqueados manualmente al iniciar.

---

## 📥 Requisitos

- Sistema operativo Linux.
- Bash.
- Permisos de administrador (`sudo` o root).
- Conexión a internet para descargar la lista pública.

---

## 🛠️ Instalación

1. Clona el repositorio:
   ```bash
   git clone https://github.com/pspedomex/bloqueador-dominios.git
   cd bloqueador-dominios

2. Da permisos de ejecución al script
   chmod +x bloqueador_webs_con_agendado.sh
   
3. Ejecuta el script como superusuario
   sudo ./bloqueador_webs_con_agendado.sh

📚 Basado en:
Lista pública de dominios maliciosos: StevenBlack/hosts

🙌 Contribuciones
¡Se aceptan contribuciones! Puedes:

Reportar errores.

Proponer mejoras.

Traducir el script.

Crear una versión gráfica (GUI).

Abre un "Issue" o envía un "Pull Request" desde tu cuenta.

