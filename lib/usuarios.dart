import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestor_de_proyectos/login.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({Key? key}) : super(key: key);

  @override
  _UsuariosState createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  String dropdownValue = 'Empleado';
  String dropdown2Value = 'Area 1';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nombre de usuario"),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
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
                labelText: 'Nombre de usuario',
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Correo',
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      // the new route
                      MaterialPageRoute(
                        builder: (BuildContext context) => const LogIn(),
                      ),

                      // this function should return true when we're done removing routes
                      // but because we want to remove all other screens, we make it
                      // always return false
                      (Route route) => false,
                    );
                  },
                  child: const Text("Salir"),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: const Text("Guardar"),
                ),
              ],
            ),
            const Divider(
              thickness: 10,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Usuario 2'),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                child: Text("Editar"),
                                value: 0,
                              ),
                              const PopupMenuItem(
                                child: Text(
                                  "Eliminar",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                value: 1,
                              ),
                            ],
                            onSelected: (result) {
                              if (result == 0) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _dialog());
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
                          leading: const Icon(Icons.person),
                          title: const Text('Usuario 3'),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                child: Text("Editar"),
                                value: 0,
                              ),
                              const PopupMenuItem(
                                child: Text(
                                  "Eliminar",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                value: 1,
                              ),
                            ],
                            onSelected: (result) {
                              if (result == 0) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _dialog());
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
                          leading: const Icon(Icons.person),
                          title: const Text('Usuario 4'),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                child: Text("Editar"),
                                value: 0,
                              ),
                              const PopupMenuItem(
                                child: Text(
                                  "Eliminar",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                value: 1,
                              ),
                            ],
                            onSelected: (result) {
                              if (result == 0) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _dialog());
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
                          leading: const Icon(Icons.person),
                          title: const Text('Usuario 5'),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                child: Text("Editar"),
                                value: 0,
                              ),
                              const PopupMenuItem(
                                child: Text(
                                  "Eliminar",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                value: 1,
                              ),
                            ],
                            onSelected: (result) {
                              if (result == 0) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _dialog());
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
                          leading: const Icon(Icons.person),
                          title: const Text('Usuario 6'),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                child: Text("Editar"),
                                value: 0,
                              ),
                              const PopupMenuItem(
                                child: Text(
                                  "Eliminar",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                value: 1,
                              ),
                            ],
                            onSelected: (result) {
                              if (result == 0) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _dialog());
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
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context, builder: (BuildContext context) => _dialog());
          },
          child: const Icon(
            Icons.person_add,
          ),
        ),
      ),
    );
  }

  _dialog() {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(8),
      title: const Text("Editar Usuario"),
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
                labelText: 'Nombre de usuario',
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Correo',
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Rol:"),
                DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Administrador', 'Empleado', 'Cliente']
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
                const Text("Area:"),
                DropdownButton<String>(
                  value: dropdown2Value,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Area 1', 'Area 2', 'Area 3', 'Area 4']
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
