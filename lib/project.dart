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
  Project(this.id, this.nombre, this.desc, this.idcliente, this.client,
      this.idarea, this.area, this.entrega, this.porcentaje);
}
