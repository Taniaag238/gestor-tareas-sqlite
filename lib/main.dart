import 'dart:async';

import 'package:flutter/material.dart';

import 'data/app_database.dart';
import 'screens/tareas_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // CREAR LA INSTANCIA DE LA BASE DE DATOS
  final database = AppDatabase();

  runApp(GestorTareasApp(database: database));
}

class GestorTareasApp extends StatefulWidget {
  final AppDatabase database;

  const GestorTareasApp({super.key, required this.database});

  @override
  State<GestorTareasApp> createState() => _GestorTareasAppState();
}

class _GestorTareasAppState extends State<GestorTareasApp> {
  // LIBERAR LA CONEXION A SQLITE AL DESTRUIR EL WIDGET
  @override
  void dispose() {
    unawaited(widget.database.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: TareasPage(database: widget.database),
    );
  }
}
