
# Gestor de tareas con SQLite

## Descripción
Aplicación desarrollada en Flutter para gestionar tareas mediante una base de datos local SQLite, utilizando Drift para facilitar las operaciones de almacenamiento y consulta.

La aplicación permite registrar, consultar, editar, completar y eliminar tareas, conservando la información después de cerrar y volver a abrir la aplicación.

## Funcionalidades
- Registro de nuevas tareas.
- Consulta de tareas almacenadas.
- Edición del título de una tarea.
- Cambio de estado entre pendiente y completada.
- Eliminación de tareas con confirmación.
- Validación de títulos vacíos.
- Persistencia local de los datos.
- Manejo de errores mediante mensajes al usuario.

## Tecnologías utilizadas
- Flutter.
- Dart.
- SQLite.
- Drift.
- Drift Flutter.
- WebAssembly para la ejecución web.
- Git y GitHub.

## Estructura del proyecto
    lib/
    ├── data/
    │   ├── app_database.dart
    │   └── app_database.g.dart
    ├── models/
    │   └── tarea.dart
    ├── screens/
    │   └── tareas_page.dart
    └── main.dart

    test/
    ├── database_test.dart
    └── widget_test.dart

    web/
    ├── drift_worker.js
    └── sqlite3.wasm

## Modelo de datos
La base de datos contiene una tabla denominada `tareas`.
| Campo | Tipo | Descripción |
|---|---|---|
| id | INTEGER | Identificador único autoincremental. |
| titulo | TEXT | Título de la tarea. |
| completada | BOOLEAN | Estado de la tarea. Por defecto, falso. |

## INSTALACION Y EJECUCION

### Requisitos
- Flutter SDK.
- Dart SDK.
- Git.
- Google Chrome para Web.
- Visual Studio con desarrollo de escritorio en C++ para Windows.
- Android SDK y un dispositivo o emulador para Android.

### Instalar dependencias
    flutter pub get

### Generar archivos de Drift (si es necesario)
    dart run build_runner build --delete-conflicting-outputs

### Ejecutar en Web
    flutter run -d chrome --web-port=8080

Para comprobar la persistencia utilizando el perfil habitual del navegador:
    flutter run -d web-server --web-port=8080 --web-hostname=localhost

Abrir http://localhost:8080 en el navegador.

### Ejecutar en Windows
    flutter run -d windows

### Ejecutar en Android
Conectar un dispositivo Android o iniciar un emulador.
    flutter devices
    flutter run -d ID_DEL_DISPOSITIVO

## Operaciones CRUD
| Operación | Método |
|---|---|
| CREATE | insertarTarea() |
| READ | obtenerTareas() |
| UPDATE | actualizarTitulo() |
| UPDATE | actualizarEstado() |
| DELETE | eliminarTarea() |

## Pruebas automatizadas
Para ejecutar el análisis estático y las pruebas:
    flutter analyze
    flutter test

Se realizaron cuatro pruebas automatizadas:
1. Verificación de la interfaz inicial.
2. Registro y consulta de tareas.
3. Actualización y eliminación de tareas.
4. Validación de títulos vacíos.

Resultado: cuatro pruebas aprobadas correctamente.

## Verificación por plataforma
| Plataforma | CRUD | Persistencia |
|---|---|---|
| Web (Chrome) | Verificado | Verificada |
| Escritorio (Windows) | Verificado | Verificada |
| Móvil (Android) | Pendiente | Pendiente |

La verificación en Android se encuentra pendiente debido a la falta temporal de un dispositivo compatible.

Cada plataforma utiliza su propio almacenamiento local, por lo que los datos no se sincronizan entre dispositivos.

## Documentación y evidencias
- [Reporte de la práctica (PDF)](docs/Reporte_SQLite.pdf)
- [Evidencias de funcionamiento](docs/evidencias/)

## Referencias
- Flutter: https://docs.flutter.dev/
- Dart: https://dart.dev/
- Drift: https://drift.simonbinder.eu/
- SQLite: https://www.sqlite.org/

## Autor
- Nombre: TANIA PAOLA GARCIA MEZA
- ID: 456829
- Materia: Programación de Dispositivos Móviles
- Universidad Autónoma de Aguascalientes
