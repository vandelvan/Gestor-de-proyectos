class Task {
  int idtarea = 0;
  String nombre = "";
  String descripcion = "";
  int idurgencia = 0;
  String urgencia = "";
  String color = "";
  DateTime entrega = DateTime.now();
  Task(i, n, d, iu, u, cu, e) {
    idtarea = i;
    nombre = n;
    descripcion = d;
    idurgencia = iu;
    urgencia = u;
    color = cu;
    entrega = e;
  }
}
