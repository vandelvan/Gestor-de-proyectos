import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestor_de_proyectos/area.dart';
import 'package:gestor_de_proyectos/cliente.dart';
import 'package:gestor_de_proyectos/tareas.dart';
import 'package:intl/intl.dart';
import 'package:gestor_de_proyectos/connection.dart';
import 'package:gestor_de_proyectos/project.dart';
import 'package:gestor_de_proyectos/user.dart';

class Proyectos extends StatefulWidget {
  const Proyectos({Key? key}) : super(key: key);

  @override
  _ProyectosState createState() => _ProyectosState();
}

class _ProyectosState extends State<Proyectos> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Cliente> clientes = [];
  List<Area> areas = [];
  int last = 0;
  @override
  Widget build(BuildContext context) {
    getClientes().then((value) => clientes = value);
    getAreas().then((value) => areas = value);
    final _user = ModalRoute.of(context)!.settings.arguments as User;
    getLastProyecto().then((value) => last = value);
    return WillPopScope(
      onWillPop: () async => false,
      child: FutureBuilder(
          future: getProyectos(_user.rol, _user.id, _user.area),
          builder: (BuildContext context,
              AsyncSnapshot<List<Project>> _snapproyectos) {
            if (_snapproyectos.hasData) {
              List<Project> _proyectos = _snapproyectos.data!;
              return _proyectos.isNotEmpty
                  ? Scaffold(
                      floatingActionButton: _user.rol == 1
                          ? FloatingActionButton(
                              onPressed: () async {
                                await _projDialog(
                                    Project(
                                        0,
                                        "",
                                        "",
                                        clientes.first.id,
                                        "",
                                        areas.first.id,
                                        "",
                                        DateTime.now(),
                                        0.0),
                                    _user.nombre);
                                setState(() {});
                              },
                              child: const Icon(Icons.add_chart),
                            )
                          : null,
                      body: ListView.builder(
                        itemCount: _proyectos.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.bar_chart),
                                  title: Text(_proyectos[i].nombre),
                                  subtitle: Text(_proyectos[i].desc +
                                      '\nArea: ' +
                                      _proyectos[i].area +
                                      '\nCliente: ' +
                                      _proyectos[i].client +
                                      '\nEntrega: ' +
                                      DateFormat('dd/MM/yyyy')
                                          .format(_proyectos[i].entrega)),
                                  trailing: _user.rol == 1
                                      ? PopupMenuButton(
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              child: Text("Ver"),
                                              value: 1,
                                            ),
                                            const PopupMenuItem(
                                              child: Text("Editar"),
                                              value: 2,
                                            ),
                                            const PopupMenuItem(
                                              child: Text(
                                                "Eliminar",
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                              value: 3,
                                            ),
                                          ],
                                          onSelected: (result) async {
                                            if (result == 1) {
                                              Navigator.pushNamed(
                                                      context, 'tareas/',
                                                      arguments: TArgs(
                                                          _user,
                                                          _proyectos[i].id,
                                                          0,
                                                          _proyectos[i].nombre))
                                                  .then((value) {
                                                setState(() {});
                                              });
                                            } else if (result == 2) {
                                              await _projDialog(
                                                  _proyectos[i], _user.nombre);

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
                                                          eliminarProyecto(
                                                              _proyectos[i].id,
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
                                  onTap: () => Navigator.pushNamed(
                                          context, 'tareas/',
                                          arguments: TArgs(
                                              _user,
                                              _proyectos[i].id,
                                              0,
                                              _proyectos[i].nombre))
                                      .then((value) {
                                    setState(() {});
                                  }),
                                ),
                                Text(
                                    "${(_proyectos[i].porcentaje * 100).toInt().toString()}% completo"),
                                LinearProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  value: _proyectos[i].porcentaje,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text("No hay proyectos aquí..."),
                    );
            } else if (_snapproyectos.hasError) {
              return Column(
                children: <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${_snapproyectos.error}'),
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
          }),
    );
  }

  _projDialog(Project proyecto, String _usuario) {
    String _id = "";
    int _area = proyecto.idarea;
    int _cliente = proyecto.idcliente;
    DateTime _entrega = proyecto.entrega;
    final _nom = TextEditingController(text: proyecto.nombre);
    final _desc = TextEditingController(text: proyecto.desc);
    String _modo = "";
    if (proyecto.id == 0) {
      _modo = "Nuevo";
      _id = (last + 1).toString();
    } else {
      _modo = "Editar";
      _id = proyecto.id.toString();
    }
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              contentPadding: const EdgeInsets.all(8),
              title: Text("$_modo Proyecto"),
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
                            controller: _desc,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Descripcion',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("Area:"),
                              DropdownButton<int>(
                                value: _area,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    _area = newValue!;
                                  });
                                },
                                items: areas
                                    .map<DropdownMenuItem<int>>((Area value) {
                                  return DropdownMenuItem<int>(
                                    value: value.id,
                                    child: Text(value.nombre),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("Cliente:"),
                              DropdownButton<int>(
                                value: _cliente,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    _cliente = newValue!;
                                  });
                                },
                                items: clientes.map<DropdownMenuItem<int>>(
                                    (Cliente value) {
                                  return DropdownMenuItem<int>(
                                    value: value.id,
                                    child: Text(value.nombre),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                  "Fecha de entrega: ${DateFormat('dd/MM/yyyy').format(_entrega)}"),
                              IconButton(
                                onPressed: () => showDatePicker(
                                  context: context,
                                  initialDate: proyecto.entrega,
                                  firstDate: DateTime(1999),
                                  lastDate: DateTime(2099),
                                ).then((value) => setState(() {
                                      _entrega = value!;
                                    })),
                                icon: const Icon(Icons.calendar_today),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (proyecto.id == 0) {
                                      crearProyecto(_nom.text, _desc.text,
                                          _area, _cliente, _entrega, _usuario);
                                    } else {
                                      editarProyecto(
                                          proyecto.id,
                                          _nom.text,
                                          _desc.text,
                                          _area,
                                          _cliente,
                                          _entrega,
                                          _usuario);
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
