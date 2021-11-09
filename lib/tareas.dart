import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Tareas extends StatefulWidget {
  const Tareas({Key? key}) : super(key: key);

  @override
  _TareasState createState() => _TareasState();
}

class _TareasState extends State<Tareas> {
  String dropdownValue = 'Baja';
  String dropdown2Value = 'Usuario 1';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Proyecto A"),
        ),
        body: ListView(
          children: <Widget>[
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.task_alt),
                    title: const Text('Tarea 1'),
                    subtitle: const Text(
                        'Descripcion de tarea\nUregncia: Baja\nEntrega: 08/11/2021'),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          child: Text("Ver"),
                          value: 0,
                        ),
                        const PopupMenuItem(
                          child: Text("Completar"),
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
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => _dialog());
                        } else if (result == 1) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => _dialog());
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
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => _dialog(),
                    ),
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
                    leading: const Icon(Icons.task_alt),
                    title: const Text(
                      'Tarea 2',
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
                    subtitle: const Text(
                      'Descripcion de tarea\nUregncia: Media\nEntrega: 08/11/2021',
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
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
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => _dialog());
                        } else if (result == 1) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => _dialog());
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
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => _dialog(),
                    ),
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
                    leading: const Icon(Icons.task_alt),
                    title: const Text(
                      'Tarea 3',
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
                    subtitle: const Text(
                      'Descripcion de tarea\nUregncia: Media\nEntrega: 08/11/2021',
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
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
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => _dialog());
                        } else if (result == 1) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => _dialog());
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
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => _dialog(),
                    ),
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
                    leading: const Icon(Icons.task_alt),
                    title: const Text('Tarea 4'),
                    subtitle: const Text(
                        'Descripcion de tarea\nUregncia: Baja\nEntrega: 08/11/2021'),
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
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => _dialog());
                        } else if (result == 1) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => _dialog());
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
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => _dialog(),
                    ),
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
                context: context, builder: (BuildContext context) => _dialog());
          },
          child: const Icon(Icons.add_task),
        ),
      ),
    );
  }

  _dialog() {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(8),
      title: const Text("Nueva Tarea"),
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
                const Text("Urgencia:"),
                DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Baja', 'Media', 'Alta']
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
                const Text("Asignado:"),
                DropdownButton<String>(
                  value: dropdown2Value,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    'Usuario 1',
                    'Usuario 2',
                    'Usuario 3',
                    'Usuario 4'
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
            CheckboxListTile(
              value: false,
              onChanged: null,
              title: Text("Completado"),
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
    );
  }
}
