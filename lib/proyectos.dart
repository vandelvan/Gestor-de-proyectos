import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  String dropdownValue = 'Area1';
  String dropdown2Value = 'Cliente1';
  @override
  Widget build(BuildContext context) {
    final _user = ModalRoute.of(context)!.settings.arguments as User;
    return FutureBuilder(
        future: getProyectos(_user.rol, _user.id, _user.area),
        builder: (BuildContext context,
            AsyncSnapshot<List<Project>> _snapproyectos) {
          if (_snapproyectos.hasData) {
            List<Project> _proyectos = _snapproyectos.data!;
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("Lista de Proyectos"),
                  leading: IconButton(
                    icon: const Icon(
                      Icons.person,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'usuarios/');
                    },
                  ),
                ),
                body: _proyectos.isNotEmpty
                    ? ListView.builder(
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
                                  trailing: PopupMenuButton(
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
                                    onSelected: (result) {
                                      if (result == 1) {
                                        Navigator.pushNamed(
                                          context,
                                          'tareas/',
                                        );
                                      } else if (result == 2) {
                                        _projDialog(_proyectos[i]);
                                      } else {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Esta seguro?'),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: const <Widget>[
                                                    Icon(
                                                      Icons.warning,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
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
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Si'),
                                                  onPressed: () {
                                                    eliminarProyecto(
                                                        _proyectos[i].id,
                                                        _user.username);
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    'tareas/',
                                  ),
                                ),
                                Text(
                                    "${(_proyectos[i].porcentaje.toInt() * 100).toString()}% completo"),
                                LinearProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  value: _proyectos[i].porcentaje,
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text("No hay proyectos aquí..."),
                      ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _projDialog(
                        Project(0, "", "", "", "", DateTime.now(), 0.0));
                  },
                  child: const Icon(
                    Icons.add_chart,
                  ),
                ),
              ),
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
        });
  }

  _projDialog(Project proyecto) {
    String _modo = "";
    if (proyecto.id == 0) {
      _modo = "Nuevo";
    } else {
      _modo = "Editar";
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
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
                    "ID: ${proyecto.id.toString()}",
                  ),
                  Text(
                    "Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: proyecto.nombre,
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
                initialValue: proyecto.desc,
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
                  DropdownButton<String>(
                    value: dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['Area1', 'Area2', 'Area3', 'Area4']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Cliente:"),
                  DropdownButton<String>(
                    value: dropdown2Value,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>[
                      'Cliente1',
                      'Cliente2',
                      'Cliente3',
                      'Cliente4'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      "Fecha de entrega: ${DateFormat('dd/MM/yyyy').format(proyecto.entrega)}"),
                  IconButton(
                    onPressed: () => showDatePicker(
                      context: context,
                      initialDate: proyecto.entrega,
                      firstDate: DateTime(1999),
                      lastDate: DateTime(2099),
                    ),
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
                    onPressed: () {},
                    child: const Text("Guardar"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
