import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestor_de_proyectos/urgencia.dart';
import 'package:gestor_de_proyectos/user.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import 'cliente.dart';
import 'connection.dart';
import 'task.dart';

class TArgs {
  final User user;
  final int pid;
  final int idu;
  final String nombre;
  TArgs(this.user, this.pid, this.idu, this.nombre);
}

class Tareas extends StatefulWidget {
  const Tareas({Key? key}) : super(key: key);

  @override
  _TareasState createState() => _TareasState();
}

class _TareasState extends State<Tareas> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int pid = 0;
  List<Cliente> empleados = [];
  List<Urgencia> urgencias = [];
  List<Task> tareas = [];
  int last = 0;
  @override
  Widget build(BuildContext context) {
    TArgs _args = ModalRoute.of(context)!.settings.arguments as TArgs;
    pid = _args.pid;
    int idu = _args.idu;
    User _user = _args.user;
    getEmpleados().then((value) => empleados = value);
    getUrgencias().then((value) => urgencias = value);
    getTareasGeneral(pid, 0).then((value) => tareas = value);
    getLastTarea().then((value) => last = value);
    return FutureBuilder(
        future: getTareas(pid, idu),
        builder: (BuildContext context, AsyncSnapshot<List<Task>> _snaptareas) {
          if (_snaptareas.hasData) {
            List<Task> _tareas = _snaptareas.data!;
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(_args.nombre),
                ),
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
                                  subtitle: Text.rich(
                                    TextSpan(
                                      style: _tareas[i].completado
                                          ? const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            )
                                          : null,
                                      text: _tareas[i].descripcion +
                                          '\nEntrega: ' +
                                          DateFormat('dd/MM/yyyy').format(
                                            _tareas[i].entrega,
                                          ) +
                                          '\nUrgencia: ',
                                      children: [
                                        TextSpan(
                                          text: _tareas[i].urgencia,
                                          style: TextStyle(
                                            color: Color(
                                              int.parse(
                                                (_tareas[i].color),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: _user.rol != 3
                                      ? PopupMenuButton(
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              child: Text("Ver"),
                                              value: 1,
                                            ),
                                            PopupMenuItem(
                                              child: _tareas[i].completado
                                                  ? const Text(
                                                      "Marcar incompleta")
                                                  : const Text(
                                                      "Marcar completada"),
                                              value: 2,
                                            ),
                                            if (_user.rol == 1 && idu == 0)
                                              const PopupMenuItem(
                                                child: Text("Editar"),
                                                value: 3,
                                              ),
                                            if (_user.rol == 1 && idu == 0)
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

                                              await getTareasGeneral(pid, 0)
                                                  .then((value) =>
                                                      tareas = value);
                                              setState(() {});
                                            } else if (result == 2) {
                                              await checkTarea(
                                                  _tareas[i].idtareap,
                                                  !_tareas[i].completado,
                                                  _user.nombre);
                                              setState(() {});
                                            } else if (result == 3) {
                                              await _taskDialog(
                                                  _tareas[i], _user.nombre, 3);

                                              await getTareasGeneral(pid, 0)
                                                  .then((value) =>
                                                      tareas = value);
                                              setState(() {});
                                            } else {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Esta seguro?'),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: const <
                                                            Widget>[
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
                                                          eliminarTarea(
                                                              _tareas[i]
                                                                  .idtareap,
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
                                  onTap: () async {
                                    _taskDialog(_tareas[i], _user.nombre, 2);

                                    await getTareasGeneral(pid, 0)
                                        .then((value) => tareas = value);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text("No hay tareas aqu??..."),
                      ),
                floatingActionButton: _user.rol == 1 && idu == 0
                    ? FloatingActionButton(
                        onPressed: () async {
                          await _taskDialog(
                              Task(tareas.first.idtarea, 0, "", "", 1, "", "",
                                  DateTime.now(), false, []),
                              _user.nombre,
                              1);
                          await getTareasGeneral(pid, 0)
                              .then((value) => tareas = value);
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.add_task,
                        ),
                      )
                    : null,
              ),
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
    if (tareas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero deben existir tareas'),
        ),
      );
      return;
    }
    String _id = "";
    int _tarea = tarea.idtarea;
    int _urgencia = tarea.idurgencia;
    List<Cliente> _empleadosL = [];
    for (var i in empleados) {
      for (var j in tarea.asignados) {
        if (i.id == j.id) _empleadosL.add(i);
      }
    }
    DateTime _entrega = tarea.entrega;
    bool _completo = tarea.completado;
    String _modo = "";
    if (_mode == 1) {
      _modo = "Nueva";
      _id = (last + 1).toString();
    } else {
      if (_mode == 3) {
        _modo = "Editar";
      }
      _id = tarea.idtareap.toString();
      await getTareasGeneral(pid, tarea.idtarea)
          .then((value) => tareas = value);
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("Tarea:"),
                              DropdownButton<int>(
                                value: _tarea,
                                onChanged: (int? newValue) {
                                  _mode == 2
                                      ? null
                                      : setState(() {
                                          _tarea = newValue!;
                                        });
                                },
                                items: tareas
                                    .map<DropdownMenuItem<int>>((Task value) {
                                  return DropdownMenuItem<int>(
                                    value: value.idtarea,
                                    child: Text(value.nombre),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("Urgencia:"),
                              DropdownButton<int>(
                                value: _urgencia,
                                onChanged: (int? newValue) {
                                  _mode == 2
                                      ? null
                                      : setState(() {
                                          _urgencia = newValue!;
                                        });
                                },
                                items: urgencias.map<DropdownMenuItem<int>>(
                                    (Urgencia value) {
                                  return DropdownMenuItem<int>(
                                    value: value.id,
                                    child: Text(value.nombre),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const Text("Asignados:"),
                          MultiSelectDialogField<Cliente?>(
                            title: const Text("Asignados"),
                            searchable: true,
                            items: empleados
                                .map((e) => MultiSelectItem(e, e.nombre))
                                .toList(),
                            listType: MultiSelectListType.CHIP,
                            onConfirm: (values) {
                              _mode == 2
                                  ? null
                                  : setState(() {
                                      _empleadosL = values.cast<Cliente>();
                                    });
                            },
                            initialValue: _empleadosL,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                  "Fecha de entrega: ${DateFormat('dd/MM/yyyy').format(_entrega)}"),
                              IconButton(
                                onPressed: () => _mode == 2
                                    ? null
                                    : showDatePicker(
                                        context: context,
                                        initialDate: tarea.entrega,
                                        firstDate: DateTime(1999),
                                        lastDate: DateTime(2099),
                                      ).then((value) => setState(() {
                                          _entrega = value!;
                                        })),
                                icon: const Icon(Icons.calendar_today),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: const Text("Completo: "),
                            value: _completo,
                            onChanged: (v) {
                              _mode == 2
                                  ? null
                                  : setState(() {
                                      _completo = v!;
                                    });
                            },
                          ),
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
                                      crearTarea(
                                        int.parse(_id),
                                        _tarea,
                                        pid,
                                        _urgencia,
                                        _entrega,
                                        _completo,
                                        _usuario,
                                        _empleadosL,
                                      );
                                    } else if (_mode == 2) {
                                    } else {
                                      editarTarea(
                                          int.parse(_id),
                                          _tarea,
                                          _urgencia,
                                          _entrega,
                                          _completo,
                                          _usuario,
                                          _empleadosL,
                                          tarea.asignados);
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
