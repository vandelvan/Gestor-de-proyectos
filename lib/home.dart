import 'package:flutter/material.dart';
import 'package:gestor_de_proyectos/proyectos.dart';
import 'package:gestor_de_proyectos/tareas_general.dart';
import 'package:gestor_de_proyectos/user.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _pags = const [Proyectos(), TareasGeneral()];
  int _i = 0;
  void _cambpag(int index) {
    setState(() {
      _i = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _user = ModalRoute.of(context)!.settings.arguments as User;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
            bottomNavigationBar: _user.rol == 1
                ? BottomNavigationBar(
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.bar_chart),
                        label: "Proyectos",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.task_alt),
                        label: "Tareas",
                      ),
                    ],
                    currentIndex: _i,
                    onTap: _cambpag,
                  )
                : null,
            appBar: AppBar(
              title: Text("Lista de ${_i == 0 ? 'Proyectos' : 'tareas'}"),
              leading: IconButton(
                icon: const Icon(
                  Icons.person,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'usuarios/');
                },
              ),
            ),
            body: _pags.elementAt(_i)),
      ),
    );
  }
}
