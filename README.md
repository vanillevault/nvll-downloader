,╔════════ NVLL Downloader ════════╗

Vanille Systems — Minimal Mint / Silent Operator

Versión: 2.0
Autor: Vanille


---

🌿 Descripción

NVLL Downloader es un gestor minimalista para descargar contenido de YouTube directamente desde la terminal.
Soporta audio (MP3) y video (MP4), con interfaz limpia, estilo Vanille Mint y operación silenciosa.

✅ Descarga YouTube sin complicaciones

✅ Multilenguaje: Español / Inglés

✅ Minimalista, portable y elegante

✅ Compatible con Node.js y cURL



---

⚙ Requisitos

Node.js ≥ 18

cURL instalado

mesaedeu.js en la ruta libs/.../mesaedeu.js

Permiso de escritura en la carpeta de descargas (/storage/emulated/0/NVLL por defecto)



---

💾 Instalación

1. Clona o descarga NVLL Downloader.


2. Da permisos al script:



chmod +x nvll-downloader.sh

3. Ejecuta:



./nvll-downloader.sh


---

🖥 Uso

Menú principal

╔════════ NVLL Downloader ════════╗
        Vanille Systems
1) Descargar
2) Idioma
0) Salir

Descargar: Introduce URL de YouTube → selecciona formato MP3 / MP4 → descarga automática.

Idioma: Cambia entre Español o Inglés.

Salir: Cierra el programa.


Ejemplo

Introduce URL: https://www.youtube.com/watch?v=abcd1234
Formato: 1) MP3 | 2) MP4
Procesando…
Descarga finalizada → /storage/emulated/0/NVLL/song.mp3


---

📂 Estructura de carpetas

NVYT/
├─ libs/
│  └─ cxjsglrn/.../mesaedeu.js
├─ node_modules/
├─ nvll-downloader.sh
├─ package.json
└─ package-lock.json


---

⚡ Configuración

Archivo de configuración: ~/.nvll_config

Variable principal: LANG → Idioma actual (es / en)

Guardado automático al cambiar idioma desde el menú



---

╔════════ NVLL DOWNLOADER ════════╗
Vanille Systems — Silent Operator Mode



