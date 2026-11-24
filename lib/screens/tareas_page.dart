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

    // CONSULTAR LAS TAREAS AL INICIAR
    _cargarTareas();
  }

  // READ: CONSULTAR LAS TAREAS ALMACENADAS
  Future<bool> _cargarTareas() async {
    try {
      final tareas = await widget.database.obtenerTareas();

      if (!mounted) return false;

      setState(() {
        _tareas = tareas;
      });

      return true;
    } catch (e) {
      if (!mounted) return false;

      _mostrarMensaje('Error al consultar las tareas: $e');

      return false;
    }
  }

  // CREATE: REGISTRAR UNA NUEVA TAREA
  Future<void> _agregarTarea() async {
    final titulo = _tituloController.text.trim();

    if (titulo.isEmpty) {
      _mostrarMensaje('El título no puede estar vacío.');
      return;
    }

    try {
      await widget.database.insertarTarea(titulo);

      if (!mounted) return;

      _tituloController.clear();

      final actualizado = await _cargarTareas();

      if (!mounted || !actualizado) return;

      _mostrarMensaje('Tarea registrada correctamente.');
    } catch (e) {
      if (!mounted) return;

      _mostrarMensaje('Error al registrar la tarea: $e');
    }
  }

  // UPDATE: CAMBIAR EL ESTADO DE UNA TAREA
  Future<void> _alternarCompletada(Tarea tarea, bool completada) async {
    try {
      final filas = await widget.database.actualizarEstado(
        tarea.id,
        completada,
      );

      if (!mounted) return;

      if (filas == 0) {
        _mostrarMensaje('No se encontró la tarea.');
        await _cargarTareas();
        return;
      }

      final actualizado = await _cargarTareas();

      if (!mounted || !actualizado) return;

      _mostrarMensaje(
        completada
            ? 'Tarea marcada como completada.'
            : 'Tarea marcada como pendiente.',
      );
    } catch (e) {
      if (!mounted) return;

      _mostrarMensaje('Error al actualizar la tarea: $e');
    }
  }

  // UPDATE: EDITAR EL TITULO DE UNA TAREA
  Future<void> _editarTarea(Tarea tarea) async {
    String nuevoTitulo = tarea.titulo;
    final formKey = GlobalKey<FormState>();

    final titulo = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar tarea'),
          content: Form(
            key: formKey,
            child: TextFormField(
              initialValue: tarea.titulo,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Título de la tarea',
                border: OutlineInputBorder(),
              ),
              onChanged: (valor) {
                nuevoTitulo = valor;
              },
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'El título no puede estar vacío.';
                }

                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, nuevoTitulo.trim());
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (titulo == null || !mounted) return;

    try {
      final filas = await widget.database.actualizarTitulo(tarea.id, titulo);

      if (!mounted) return;

      if (filas == 0) {
        _mostrarMensaje('No se encontró la tarea.');
        await _cargarTareas();
        return;
      }

      final actualizado = await _cargarTareas();

      if (!mounted || !actualizado) return;

      _mostrarMensaje('Tarea actualizada correctamente.');
    } catch (e) {
      if (!mounted) return;

      _mostrarMensaje('Error al editar la tarea: $e');
    }
  }

  // DELETE: ELIMINAR UNA TAREA
  Future<void> _eliminarTarea(Tarea tarea) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar tarea'),
          content: Text('¿Deseas eliminar la tarea "${tarea.titulo}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    try {
      final filas = await widget.database.eliminarTarea(tarea.id);

      if (!mounted) return;

      if (filas == 0) {
        _mostrarMensaje('No se encontró la tarea.');
        await _cargarTareas();
        return;
      }

      final actualizado = await _cargarTareas();

      if (!mounted || !actualizado) return;

      _mostrarMensaje('Tarea eliminada correctamente.');
    } catch (e) {
      if (!mounted) return;

      _mostrarMensaje('Error al eliminar la tarea: $e');
    }
  }

  // MOSTRAR MENSAJES AL USUARIO
  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
  }

  // LIBERAR LOS RECURSOS DEL CONTROLADOR
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
                            title: Text(
                              tarea.titulo,
                              style: TextStyle(
                                decoration: tarea.completada
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text(
                              'ID: ${tarea.id} - '
                              '${tarea.completada ? "Completada" : "Pendiente"}',
                            ),
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
