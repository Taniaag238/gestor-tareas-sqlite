import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/tarea.dart';

part 'app_database.g.dart';

// DEFINICION DE LA TABLA DE TAREAS
@DataClassName('TareaRegistro')
class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get titulo => text()();

  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}

// CONFIGURACION DE LA BASE DE DATOS
@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        driftDatabase(
          name: 'gestor_tareas',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  // CONSTRUCTOR PARA PRUEBAS AUTOMATIZADAS
  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  // REGISTRAR UNA NUEVA TAREA
  Future<int> insertarTarea(String titulo) {
    final tituloLimpio = titulo.trim();

    // VALIDAR QUE EL TITULO NO ESTE VACIO
    if (tituloLimpio.isEmpty) {
      throw ArgumentError('El título no puede estar vacío.');
    }

    return into(tareas).insert(TareasCompanion.insert(titulo: tituloLimpio));
  }

  // CONSULTAR LAS TAREAS ALMACENADAS
  Future<List<Tarea>> obtenerTareas() async {
    final registros = await select(tareas).get();

    return registros.map((registro) {
      return Tarea(
        id: registro.id,
        titulo: registro.titulo,
        completada: registro.completada,
      );
    }).toList();
  }
}
