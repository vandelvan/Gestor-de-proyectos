class Project {
  int id = 0;
  String nombre = "";
  String desc = "";
  int idcliente = 0;
  String client = "";
  int idarea = 0;
  String area = "";
  DateTime entrega = DateTime.now();
  double porcentaje = 0;
  Project(i, n, d, ic, c, ia, a, e, p) {
    id = i;
    nombre = n;
    desc = d;
    idcliente = ic;
    client = c;
    idarea = ia;
    area = a;
    entrega = e;
    porcentaje = p;
  }
}
