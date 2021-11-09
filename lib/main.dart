import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestor_de_proyectos/login.dart';
import 'package:gestor_de_proyectos/proyectos.dart';
import 'package:gestor_de_proyectos/tareas.dart';
import 'package:gestor_de_proyectos/usuarios.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestor de proyectos',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      initialRoute: '/',
      routes: {
        '/': (context) => const LogIn(),
        'proyectos/': (context) => const Proyectos(),
        'tareas/': (context) => const Tareas(),
        'usuarios/': (context) => const Usuarios(),
      },
    );
  }
}
