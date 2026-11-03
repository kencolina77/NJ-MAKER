# NJ MAKER — 3D Print & Design (Proyecto Oficial Flutter)

Este paquete contiene el código fuente completo en **Flutter (Dart)** de la aplicación móvil de **NJ MAKER**, con:
- **Logotipo vectorial `NJLogoPainter`** dibujado nativamente con el degradado oficial Cian (`#00B4D8`) → Azul (`#3B82F6`) → Púrpura (`#9333EA`).
- **Catálogo 3D Interactivo** con cambio de filamento y material (PLA+, PETG, ABS, Resina 8K) en tiempo real.
- **Cotizador Slicer 3D** con vista previa de capas laminadas, cálculo de gramos, horas y diseño CAD.
- **Carrito de Pedidos** con generación de orden lista para enviar por WhatsApp.
- **Flujo de GitHub Actions (`build_apk.yml`)** preconfigurado para compilar el archivo `.APK` en la nube gratis sin necesitar instalar Android Studio.

---

## Cómo obtener e instalar el archivo `.APK` en tu teléfono Android

### Opción A: Compilar el `.APK` en la nube sin instalar nada en tu PC (GitHub Actions)
1. Crea un repositorio en tu cuenta de GitHub y sube todos los archivos de este `.ZIP`.
2. Ve a la pestaña **Actions** de tu repositorio y ejecuta el flujo **"Build NJ MAKER Android APK"**.
3. En 2 minutos aparecerá para descargar el archivo **`app-release.apk`** listo para instalar en tu teléfono.

### Opción B: Compilar desde tu computadora con Flutter
```bash
flutter create . --project-name nj_maker_app --org com.njmaker.app
flutter pub get
flutter build apk --release
```
El instalador quedará en: `build/app/outputs/flutter-apk/app-release.apk`.
