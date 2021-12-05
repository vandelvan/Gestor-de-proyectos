import 'package:gestor_de_proyectos/cliente.dart';

class Task {
  int idtarea = 0;
  int idtareap = 0;
  String nombre = "";
  String descripcion = "";
  int idurgencia = 0;
  String urgencia = "";
  String color = "";
  DateTime entrega = DateTime.now();
  bool completado = false;
  List<Cliente> asignados = [];
  Task(
      this.idtarea,
      this.idtareap,
      this.nombre,
      this.descripcion,
      this.idurgencia,
      this.urgencia,
      this.color,
      this.entrega,
      this.completado,
      this.asignados);
}
