class Project {
  int id = 0;
  String nombre = "";
  String desc = "";
  String client = "";
  String area = "";
  DateTime entrega = DateTime.now();
  double porcentaje = 0;
  Project(i, n, d, c, a, e, p) {
    id = i;
    nombre = n;
    desc = d;
    client = c;
    area = a;
    entrega = e;
    porcentaje = p;
  }
}
