import 'package:flutter/material.dart';
import 'package:gestor_de_proyectos/connection.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:gestor_de_proyectos/user.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    open();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final _user = TextEditingController();
    final _pass = TextEditingController();
    bool _loading = false;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.location_city,
                  ),
                  Text(
                    "Gestor de proyectos empresarial",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _user,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Usuario',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obligatorio';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _pass,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contraseña',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obligatorio';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              _loading == false
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _loading = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          Future<User> fu = login(_user.text,
                              md5.convert(utf8.encode(_pass.text)).toString());
                          fu.then((User value) {
                            if (value.id == 0) {
                              showDialog(
                                  context: context,
                                  builder: (builder) => const AlertDialog(
                                        title: Text("Datos erroneos"),
                                        content: Text("Verifique sus datos."),
                                      ));
                            } else {
                              Navigator.pushNamed(context, 'home/',
                                  arguments: value);
                            }
                          }).whenComplete(() => setState(() {
                                _loading = false;
                              }));
                        }
                      },
                      child: const Text("Entrar"),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.copyright),
              Text("Jose Ivan Orozco Torrez, 2021"),
            ],
          ),
        ),
      ),
    );
  }
}
