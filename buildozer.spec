
[app]
title = CataractApp
package.name = cataractapp
package.domain = org.example        # cámbialo a tu dominio inverso
source.dir = .

target = android

#versión de la app
version = 0.1

# Archivos que se incluyen en el APK
source.include_exts = py,kv,png,jpg,atlas

# Dependencias Python.  Ajusta versiones si lo deseas.
requirements = python3,kivy==2.3.0,kivymd==1.2.0

orientation = portrait
fullscreen = 0

# Permisos que necesitaremos a futuro
android.permissions = CAMERA, WRITE_EXTERNAL_STORAGE, READ_EXTERNAL_STORAGE
