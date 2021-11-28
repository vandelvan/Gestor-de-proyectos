import 'package:postgres/postgres.dart';
import 'package:gestor_de_proyectos/user.dart';
import 'package:gestor_de_proyectos/project.dart';

var connection = PostgreSQLConnection("", 5432, "postgres",
    username: "postgres", password: "");

open() async {
  if (connection.isClosed) await connection.open();
}

/* METODOS DE USUARIOS */
//Metodo que verifica los datos del login
Future<User> login(user, pass) async {
  List<List<dynamic>> results = await connection.query(
    """select 
      idusuario, 
      username, 
      nombre, 
      idrol, 
      idarea 
    from usuario 
    where username = @user 
    and pass = @pass
    and active = true;""",
    substitutionValues: {
      "user": user,
      "pass": pass,
    },
  );
  int i = 0;
  String u = "";
  String n = "";
  int r = 0;
  int a = 0;
  if (results.isNotEmpty) {
    i = results[0][0];
    u = results[0][1];
    n = results[0][2];
    r = results[0][3];
    a = results[0][4];
  }
  return User(i, u, n, r, a);
}

/* METODOS DE PROYECTOS*/
//metodo para obtener los proyectos
Future<List<Project>> getProyectos(rol, iduser, idarea) async {
  //depende del rol agrega un and al where para traer solo los proyectos correspondientes
  String and = "";
  if (rol == 2) {
    and = "and p.idarea = " + idarea.toString();
  } else if (rol == 3) {
    and = "and p.iduser = " + iduser.toString();
  }
  List<List<dynamic>> results = await connection.query(
    """select 
      p.idproyecto, 
      p.nombre, 
      p.descripcion, 
      u.nombre, 
      a.nombre, 
      p.entrega,
      coalesce(div(count(tc.idtarea),nullif(count(t.idtarea),0)),0)::float as porcentaje
    from proyecto p 
    join usuario u on(p.idusuario = u.idusuario) 
    join area a on (p.idarea = a.idarea)
    left join tarea t on (p.idproyecto = t.idproyecto)
    left join tarea tc on (tc.completo = true)
    where p.active = true""" +
        and +
        """
    group by p.idproyecto, u.nombre , a.nombre;""",
  );
  List<Project> proyectos = [];
  int i = 0;
  String n = "";
  String d = "";
  String c = "";
  String a = "";
  DateTime e = DateTime.now();
  double pc = 0;
  if (results.isNotEmpty) {
    for (var p in results) {
      i = p[0];
      n = p[1];
      d = p[2];
      c = p[3];
      a = p[4];
      e = p[5];
      pc = p[6];
      proyectos.add(Project(i, n, d, c, a, e, pc));
    }
  }
  return proyectos;
}

//metodo para deshabilitar un proyecto
eliminarProyecto(int idp, String user) async {
  await connection.query(
    """update proyecto
    set 
      active = false,
      deleted_by = @user,
      deleted_date = now()
    where idproyecto = @idp""",
    substitutionValues: {
      "idp": idp,
      "user": user,
    },
  );
}
