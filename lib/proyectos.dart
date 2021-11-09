import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        body: ListView(
          children: <Widget>[
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.bar_chart),
                    title: const Text('Proyecto A'),
                    subtitle: const Text(
                        'Descripcion de proyecto\nArea: Programacion\nCliente: John Doe\nEntrega: 05/11/2021'),
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
                        if (result == 0) {
                          Navigator.pushNamed(
                            context,
                            'tareas/',
                          );
                        } else if (result == 1) {
                          Navigator.pushNamed(
                            context,
                            'tareas/',
                          );
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
                                      Text(
                                        'Esta accion es irreversible',
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
                  const Text("50% completo"),
                  LinearProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                    value: 0.5,
                  ),
                ],
              ),
            ),
            const Divider(),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.bar_chart),
                    title: const Text('Proyecto dos'),
                    subtitle: const Text(
                        'Descripcion de proyecto\nArea: Programacion\nCliente: John Doe\nEntrega: 05/11/2021'),
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
                        if (result == 0) {
                          Navigator.pushNamed(
                            context,
                            'tareas/',
                          );
                        } else if (result == 1) {
                          Navigator.pushNamed(
                            context,
                            'tareas/',
                          );
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
                                      Text(
                                        'Esta accion es irreversible',
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
                  const Text("80% completo"),
                  LinearProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                    value: 0.8,
                  ),
                ],
              ),
            ),
            const Divider(),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.bar_chart),
                    title: const Text('Proyecto B'),
                    subtitle: const Text(
                        'Descripcion de proyecto\nArea: Programacion\nCliente: John Doe\nEntrega: 05/11/2021'),
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
                        if (result == 0) {
                          Navigator.pushNamed(
                            context,
                            'tareas/',
                          );
                        } else if (result == 1) {
                          Navigator.pushNamed(
                            context,
                            'tareas/',
                          );
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
                                      Text(
                                        'Esta accion es irreversible',
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
                  const Text("0% completo"),
                  LinearProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                    value: 0.0,
                  ),
                ],
              ),
            ),
            const Divider(),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.bar_chart),
                    title: const Text('Proyecto C'),
                    subtitle: const Text(
                        'Descripcion de proyecto\nArea: Programacion\nCliente: John Doe\nEntrega: 05/11/2021'),
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
                        if (result == 0) {
                          Navigator.pushNamed(
                            context,
                            'tareas/',
                          );
                        } else if (result == 1) {
                          Navigator.pushNamed(
                            context,
                            'tareas/',
                          );
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
                                      Text(
                                        'Esta accion es irreversible',
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
                  const Text("10% completo"),
                  LinearProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                    value: 0.1,
                  ),
                ],
              ),
            ),
            const Divider(),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.bar_chart),
                    title: const Text('Proyecto D'),
                    subtitle: const Text(
                        'Descripcion de proyecto\nArea: Programacion\nCliente: John Doe\nEntrega: 05/11/2021'),
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
                        if (result == 0) {
                          Navigator.pushNamed(
                            context,
                            'tareas/',
                          );
                        } else if (result == 1) {
                          Navigator.pushNamed(
                            context,
                            'tareas/',
                          );
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
                                      Text(
                                        'Esta accion es irreversible',
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
                  const Text("30% completo"),
                  LinearProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                    value: 0.3,
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => SimpleDialog(
                contentPadding: const EdgeInsets.all(8),
                title: const Text("Nuevo Proyecto"),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nombre',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const TextField(
                        decoration: InputDecoration(
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
                          const Text("Fecha de entrega:"),
                          IconButton(
                            onPressed: () => showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1999),
                              lastDate: DateTime(2030),
                            ),
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
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
          },
          child: const Icon(
            Icons.add_chart,
          ),
        ),
      ),
    );
  }
}
