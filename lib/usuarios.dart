import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestor_de_proyectos/area.dart';
import 'package:gestor_de_proyectos/connection.dart';
import 'package:gestor_de_proyectos/login.dart';
import 'package:gestor_de_proyectos/user.dart';
import 'package:intl/intl.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({Key? key}) : super(key: key);

  @override
  _UsuariosState createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  final GlobalKey<FormState> _formUsuario = GlobalKey<FormState>();
  final GlobalKey<FormState> _formSelf = GlobalKey<FormState>();
  final GlobalKey<FormState> _formArea = GlobalKey<FormState>();
  List<Area> areas = [];
  List<Area> roles = [];
  int lastU = 0;
  int lastC = 0;
  int lastA = 0;
  String dropdownValue = 'Empleado';
  String dropdown2Value = 'Area 1';
  @override
  Widget build(BuildContext context) {
    getAreas().then((value) => areas = value);
    getRoles().then((value) => roles = value);
    getLastUsuario().then((value) => lastU = value);
    getLastCliente().then((value) => lastC = value);
    getLastArea().then((value) => lastA = value);
    final _user = ModalRoute.of(context)!.settings.arguments as User;
    final _name = TextEditingController(text: _user.nombre);
    final _pass = TextEditingController();
    final _correo = TextEditingController(text: _user.correo);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nombre de usuario"),
        ),
        body: Column(
          children: [
            Form(
              key: _formSelf,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _name,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obligatorio';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre de usuario',
                    ),
                    initialValue: _user.username,
                    enabled: false,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _correo,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obligatorio';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Correo',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _pass,
                    decoration: const InputDecoration(
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
                            MaterialPageRoute(
                              builder: (BuildContext context) => const LogIn(),
                            ),
                            (Route route) => false,
                          );
                        },
                        child: const Text("Cerrar sesión"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.redAccent)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formSelf.currentState!.validate()) {
                            editarUsuario(
                                _user.id,
                                _name.text,
                                _user.username,
                                md5.convert(utf8.encode(_pass.text)).toString(),
                                _correo.text,
                                _user.area,
                                _user.rol,
                                _user.rol,
                                _user.nombre);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Guardado con exito"),
                                  content: const Text(
                                      "Por favor vuelva a iniciar sesión"),
                                  actions: [
                                    TextButton(
                                      child: const Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const LogIn(),
                                          ),
                                          (Route route) => false,
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text("Guardar Cambios"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 10,
            ),
            if (_user.rol == 1)
              FutureBuilder(
                  future: getUsuarios(_user.id),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<User>> _snapusuarios) {
                    if (_snapusuarios.hasData) {
                      List<User> _usuarios = _snapusuarios.data!;
                      return Expanded(
                        child: ListView.builder(
                            itemCount: _usuarios.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.person),
                                      title: Text(_usuarios[i].nombre),
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
                                        onSelected: (result) async {
                                          if (result == 0) {
                                            await _userDialog(
                                                _usuarios[i], _user.nombre);
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text('Si'),
                                                      onPressed: () {
                                                        eliminarUsuario(
                                                            _usuarios[i].id,
                                                            _usuarios[i].rol,
                                                            _user.nombre);
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
                                      ),
                                      onTap: () async {
                                        await _userDialog(
                                            _usuarios[i], _user.nombre);
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    } else if (_snapusuarios.hasError) {
                      return Column(
                        children: <Widget>[
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${_snapusuarios.error}'),
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
                  })
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "areas",
              onPressed: () async {
                await _areaDialog(_user.nombre);
                setState(() {});
              },
              child: const Icon(
                Icons.group_add,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            FloatingActionButton(
              heroTag: "usuarios",
              onPressed: () async {
                await _userDialog(User(0, "", "", "", 2, 1), _user.nombre);
                setState(() {});
              },
              child: const Icon(
                Icons.person_add,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _areaDialog(String _uname) {
    final _nom = TextEditingController();
    bool _validn = true;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              contentPadding: const EdgeInsets.all(8),
              title: const Text("Nueva Area"),
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
                          "ID: ${lastA + 1}",
                        ),
                        Text(
                          "Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                        ),
                      ],
                    ),
                    Form(
                      key: _formArea,
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
                          Center(
                            child: _validn
                                ? null
                                : const Text("Nombre de area invalido!"),
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
                                onPressed: () async {
                                  if (_formArea.currentState!.validate()) {
                                    bool v = false;
                                    await validArea(_nom.text)
                                        .then((value) => v = value);
                                    if (v) {
                                      crearArea(_nom.text, _uname);
                                      Navigator.pop(context, true);
                                    } else {
                                      setState(() {
                                        _validn = false;
                                      });
                                    }
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

  _userDialog(User usuario, String _uname) {
    String _id = "";
    int _area = usuario.area;
    int _rol = usuario.rol;
    final _nom = TextEditingController(text: usuario.nombre);
    final _username = TextEditingController(text: usuario.username);
    final _correo = TextEditingController(text: usuario.correo);
    final _pass = TextEditingController();
    bool _validun = true;
    String _modo = "";
    if (usuario.id == 0) {
      _modo = "Nuevo";
      _rol == 3 ? _id = (lastC + 1).toString() : _id = (lastU + 1).toString();
    } else {
      _modo = "Editar";
      _id = usuario.id.toString();
    }
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              contentPadding: const EdgeInsets.all(8),
              title: Text("$_modo Usuario"),
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
                      key: _formUsuario,
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
                            controller: _username,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nombre de usuario',
                            ),
                            enabled: usuario.id == 0 ? true : false,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _correo,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Correo',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _pass,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Contraseña',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("Rol:"),
                              DropdownButton<int>(
                                value: _rol,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    _rol = newValue!;
                                    if (usuario.id == 0) {
                                      _rol == 3
                                          ? _id = (lastC + 1).toString()
                                          : _id = (lastU + 1).toString();
                                    }
                                  });
                                },
                                items: roles
                                    .map<DropdownMenuItem<int>>((Area value) {
                                  return DropdownMenuItem<int>(
                                    value: value.id,
                                    child: Text(value.nombre),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          if (_rol != 3)
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
                          Center(
                            child: _validun
                                ? null
                                : const Text("Nombre de usuario invalido!"),
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
                                onPressed: () async {
                                  if (_formUsuario.currentState!.validate()) {
                                    if (usuario.id == 0) {
                                      bool v = false;
                                      await validUsuario(_username.text)
                                          .then((value) => v = value);
                                      if (v) {
                                        crearUsuario(
                                            _nom.text,
                                            _username.text,
                                            md5
                                                .convert(
                                                    utf8.encode(_pass.text))
                                                .toString(),
                                            _correo.text,
                                            _area,
                                            _rol,
                                            _uname);
                                        Navigator.pop(context, true);
                                      } else {
                                        setState(() {
                                          _validun = false;
                                        });
                                      }
                                    } else {
                                      editarUsuario(
                                          int.parse(_id),
                                          _nom.text,
                                          _username.text,
                                          md5
                                              .convert(utf8.encode(_pass.text))
                                              .toString(),
                                          _correo.text,
                                          _area,
                                          _rol,
                                          usuario.rol,
                                          _uname);
                                      Navigator.pop(context, true);
                                    }
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
