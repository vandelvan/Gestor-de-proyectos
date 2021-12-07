import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestor_de_proyectos/user.dart';
import 'package:intl/intl.dart';

import 'connection.dart';
import 'task.dart';

class TareasGeneral extends StatefulWidget {
  const TareasGeneral({Key? key}) : super(key: key);

  @override
  _TareasGeneralState createState() => _TareasGeneralState();
}

class _TareasGeneralState extends State<TareasGeneral> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int last = 0;
  @override
  Widget build(BuildContext context) {
    User _user = ModalRoute.of(context)!.settings.arguments as User;
    getLastTareaGeneral().then((value) => last = value);
    return FutureBuilder(
        future: getTareasGeneral(0, 0),
        builder: (BuildContext context, AsyncSnapshot<List<Task>> _snaptareas) {
          if (_snaptareas.hasData) {
            List<Task> _tareas = _snaptareas.data!;
            return Scaffold(
              body: _tareas.isNotEmpty
                  ? ListView.builder(
                      itemCount: _tareas.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.task_alt),
                                title: Text(_tareas[i].nombre),
                                subtitle: Text(_tareas[i].descripcion),
                                trailing: _user.rol != 3
                                    ? PopupMenuButton(
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            child: Text("Ver"),
                                            value: 1,
                                          ),
                                          if (_user.rol == 1)
                                            const PopupMenuItem(
                                              child: Text("Editar"),
                                              value: 3,
                                            ),
                                          if (_user.rol == 1)
                                            const PopupMenuItem(
                                              child: Text(
                                                "Eliminar",
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                              value: 4,
                                            ),
                                        ],
                                        onSelected: (result) async {
                                          if (result == 1) {
                                            await _taskDialog(
                                                _tareas[i], _user.nombre, 2);

                                            setState(() {});
                                          } else if (result == 2) {
                                          } else if (result == 3) {
                                            await _taskDialog(
                                                _tareas[i], _user.nombre, 3);

                                            setState(() {});
                                          } else {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Esta seguro?'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: const <Widget>[
                                                        Icon(
                                                          Icons.warning,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Center(
                                                            child: Text(
                                                              'Esta accion es irreversible',
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('No'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text('Si'),
                                                      onPressed: () {
                                                        eliminarTareaGeneral(
                                                            _tareas[i].idtarea,
                                                            _user.username);
                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      )
                                    : null,
                                onTap: () =>
                                    _taskDialog(_tareas[i], _user.nombre, 2),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text("No hay tareas aquí..."),
                    ),
              floatingActionButton: _user.rol == 1
                  ? FloatingActionButton(
                      onPressed: () async {
                        await _taskDialog(
                            Task(0, 0, "", "", 1, "", "", DateTime.now(), false,
                                []),
                            _user.nombre,
                            1);
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.add_task,
                      ),
                    )
                  : null,
            );
          } else if (_snaptareas.hasError) {
            return Column(
              children: <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${_snaptareas.error}'),
                ),
              ],
            );
          } else {
            return const Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
            );
          }
        });
  }

  _taskDialog(Task tarea, String _usuario, int _mode) async {
    String _id = "";
    final _nom = TextEditingController(text: tarea.nombre);
    final _desc = TextEditingController(text: tarea.descripcion);
    String _modo = "";
    if (_mode == 1) {
      _modo = "Nueva";
      _id = (last + 1).toString();
    } else {
      if (_mode == 3) {
        _modo = "Editar";
      }
      _id = tarea.idtarea.toString();
    }
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              contentPadding: const EdgeInsets.all(8),
              title: Text("$_modo Tarea"),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "ID: $_id",
                        ),
                        Text(
                          "Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 10),
                          TextFormField(
                            enabled: _mode == 2 ? false : true,
                            controller: _nom,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nombre',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            enabled: _mode == 2 ? false : true,
                            controller: _desc,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Descripcion',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (_mode == 1) {
                                      crearTareaGeneral(
                                        int.parse(_id),
                                        _nom.text,
                                        _desc.text,
                                        _usuario,
                                      );
                                    } else if (_mode == 2) {
                                    } else {
                                      editarTareaGeneral(tarea.idtarea,
                                          _nom.text, _desc.text, _usuario);
                                    }
                                    Navigator.pop(context, true);
                                  }
                                },
                                child: const Text("Guardar"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
