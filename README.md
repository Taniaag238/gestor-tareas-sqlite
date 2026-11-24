# Gestor de tareas con SQLite

Aplicación desarrollada en Flutter para la materia de Programación de Dispositivos Móviles, cuyo objetivo es administrar tareas mediante una base de datos local persistente.

## Objetivo

Implementar las operaciones CRUD utilizando SQLite, conservando la información después de cerrar y volver a abrir la aplicación, sin depender de servidores externos.

## Tecnologías seleccionadas

- Flutter: desarrollo de la aplicación multiplataforma.
- Dart: lenguaje de programación.
- SQLite: almacenamiento local persistente.
- Drift: administración de la base de datos y operaciones CRUD.
- drift_flutter: conexión con SQLite en los diferentes entornos.
- build_runner y drift_dev: generación del código de persistencia.

Se eligió Drift porque permite trabajar con SQLite mediante una misma estructura de código en aplicaciones móviles, de escritorio y web, además de facilitar las consultas asíncronas y el manejo de tipos de datos.

## Diseño de la base de datos

La base de datos contará con una tabla llamada `tareas`.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INTEGER | Llave primaria autoincremental. |
| titulo | TEXT | Título obligatorio de la tarea. |
| completada | INTEGER | Estado de la tarea: 0 pendiente y 1 completada. |

Cada tarea tendrá un identificador único que permitirá realizar operaciones de edición, actualización de estado y eliminación.

## Entornos previstos

- Web: Google Chrome.
- Móvil: Android.
- Escritorio: Windows.

Los datos serán independientes en cada instalación y no se sincronizarán entre dispositivos.

## Ejecución del proyecto

```bash
flutter pub get
flutter run -d chrome --web-port=8080
```

## Verificación inicial

- Ejecución en Chrome: correcta.
- Análisis estático: sin errores, con un aviso informativo.
- Prueba automatizada inicial: aprobada.

## Estado del proyecto

Actualmente se cuenta con la interfaz inicial y el diseño de la base de datos. La implementación de SQLite y las operaciones CRUD se realizarán en las siguientes etapas.