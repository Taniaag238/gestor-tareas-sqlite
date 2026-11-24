import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

import 'package:gestor_tareas_local/data/app_database.dart';

void main() {
  late AppDatabase database;

  // CREAR UNA BASE DE DATOS TEMPORAL ANTES DE CADA PRUEBA
  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  // CERRAR LA BASE DE DATOS DESPUES DE CADA PRUEBA
  tearDown(() async {
    await database.close();
  });

  // PRUEBA 1: REGISTRAR Y CONSULTAR TAREAS
  test('Registrar y consultar una tarea', () async {
    final id = await database.insertarTarea('Estudiar SQLite');

    final tareas = await database.obtenerTareas();

    expect(tareas.length, 1);
    expect(tareas.first.id, id);
    expect(tareas.first.titulo, 'Estudiar SQLite');
    expect(tareas.first.completada, false);
  });

  // PRUEBA 2: ACTUALIZAR Y ELIMINAR UNA TAREA
  test('Editar, completar y eliminar una tarea', () async {
    final id = await database.insertarTarea('Tarea original');

    // EDITAR EL TITULO
    await database.actualizarTitulo(id, 'Tarea modificada');

    // CAMBIAR EL ESTADO
    await database.actualizarEstado(id, true);

    final tareas = await database.obtenerTareas();

    expect(tareas.length, 1);
    expect(tareas.first.titulo, 'Tarea modificada');
    expect(tareas.first.completada, true);

    // ELIMINAR LA TAREA
    await database.eliminarTarea(id);

    final tareasRestantes = await database.obtenerTareas();

    expect(tareasRestantes, isEmpty);
  });

  // PRUEBA 3: VALIDAR TITULOS VACIOS
  test('Rechazar títulos vacíos al registrar y editar', () async {
    expect(() => database.insertarTarea(''), throwsArgumentError);

    expect(() => database.insertarTarea('   '), throwsArgumentError);

    final id = await database.insertarTarea('Tarea válida');

    expect(() => database.actualizarTitulo(id, '   '), throwsArgumentError);

    final tareas = await database.obtenerTareas();

    expect(tareas.length, 1);
    expect(tareas.first.titulo, 'Tarea válida');
  });
}
