import 'package:flutter/material.dart';

import 'data/app_database.dart';
import 'screens/tareas_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // INICIALIZAR LA BASE DE DATOS
  final database = AppDatabase();

  // INICIAR LA APLICACION
  runApp(GestorTareasApp(database: database));
}

class GestorTareasApp extends StatelessWidget {
  final AppDatabase database;

  const GestorTareasApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),

      // PROPORCIONAR LA BASE DE DATOS A LA PANTALLA
      home: TareasPage(database: database),
    );
  }
}
