import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

import 'package:gestor_tareas_local/main.dart';
import 'package:gestor_tareas_local/data/app_database.dart';

void main() {
  testWidgets('La pantalla inicial se muestra sin errores', (tester) async {
    // CREAR UNA BASE DE DATOS TEMPORAL EN MEMORIA
    final database = AppDatabase.forTesting(NativeDatabase.memory());

    // CERRAR LA BASE DE DATOS AL FINALIZAR LA PRUEBA
    addTearDown(database.close);

    // INICIALIZAR LA APLICACION
    await tester.runAsync(() async {
      await tester.pumpWidget(GestorTareasApp(database: database));

      await database.obtenerTareas();
    });

    await tester.pumpAndSettle();

    // VERIFICAR LOS ELEMENTOS DE LA INTERFAZ
    expect(find.text('Gestor de tareas'), findsOneWidget);
    expect(find.text('Agregar tarea'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
