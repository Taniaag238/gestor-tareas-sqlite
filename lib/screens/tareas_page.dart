import 'package:flutter/material.dart';

import '../models/tarea.dart';
import '../data/app_database.dart';

class TareasPage extends StatefulWidget {
  final AppDatabase database;

  const TareasPage({super.key, required this.database});

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final TextEditingController _tituloController = TextEditingController();

  List<Tarea> _tareas = [];

  @override
  void initState() {
    super.initState();

    // CONSULTAR LAS TAREAS AL INICIAR LA APLICACION
    _cargarTareas();
  }

  // RECUPERAR LAS TAREAS ALMACENADAS EN SQLITE
  Future<void> _cargarTareas() async {
    try {
      final tareas = await widget.database.obtenerTareas();

      if (!mounted) return;

      setState(() {
        _tareas = tareas;
      });
    } catch (e) {
      if (!mounted) return;

      _pendiente('Error al consultar las tareas: $e');
    }
  }

  // REGISTRAR UNA NUEVA TAREA
  Future<void> _agregarTarea() async {
    final titulo = _tituloController.text.trim();

    // VALIDAR QUE EL TITULO NO ESTE VACIO
    if (titulo.isEmpty) {
      _pendiente('El título no puede estar vacío.');
      return;
    }

    try {
      // GUARDAR LA TAREA EN SQLITE
      await widget.database.insertarTarea(titulo);

      if (!mounted) return;

      // LIMPIAR EL CAMPO DE TEXTO
      _tituloController.clear();

      // ACTUALIZAR LA LISTA DE TAREAS
      await _cargarTareas();

      if (!mounted) return;

      _pendiente('Tarea registrada correctamente.');
    } catch (e) {
      if (!mounted) return;

      _pendiente('Error al registrar la tarea: $e');
    }
  }

  // PENDIENTE: ACTUALIZAR EL ESTADO DE LA TAREA
  void _alternarCompletada(Tarea tarea, bool completada) {
    _pendiente('Implementar actualización de tarea');
  }

  // PENDIENTE: EDITAR EL TITULO DE LA TAREA
  void _editarTarea(Tarea tarea) {
    _pendiente('Implementar edición de título');
  }

  // PENDIENTE: ELIMINAR UNA TAREA
  void _eliminarTarea(Tarea tarea) {
    _pendiente('Implementar eliminación de tarea');
  }

  // MOSTRAR MENSAJES AL USUARIO
  void _pendiente(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de tareas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Nueva tarea',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _agregarTarea,
              icon: const Icon(Icons.add),
              label: const Text('Agregar tarea'),
            ),
            const SizedBox(height: 12),
            const Text('Mis tareas', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(
              child: _tareas.isEmpty
                  ? const Center(child: Text('Todavía no hay tareas guardadas'))
                  : ListView.builder(
                      itemCount: _tareas.length,
                      itemBuilder: (context, index) {
                        final tarea = _tareas[index];

                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: tarea.completada,
                              onChanged: (valor) {
                                if (valor != null) {
                                  _alternarCompletada(tarea, valor);
                                }
                              },
                            ),
                            title: Text(tarea.titulo),
                            subtitle: Text('ID: ${tarea.id}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Editar',
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editarTarea(tarea),
                                ),
                                IconButton(
                                  tooltip: 'Eliminar',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _eliminarTarea(tarea),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
