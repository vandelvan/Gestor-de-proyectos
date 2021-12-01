import 'package:gestor_de_proyectos/area.dart';
import 'package:gestor_de_proyectos/cliente.dart';
import 'package:gestor_de_proyectos/task.dart';
import 'package:gestor_de_proyectos/urgencia.dart';
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
      correo,
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
  String c = "";
  int r = 0;
  int a = 0;
  if (results.isNotEmpty) {
    i = results[0][0];
    u = results[0][1];
    n = results[0][2];
    c = results[0][3];
    r = results[0][4];
    a = results[0][5];
  } else {
    results = await connection.query(
      """select 
      idcliente, 
      username,
      nombre,
      correo,
      3,
      0
    from cliente 
    where username = @user 
    and pass = @pass
    and active = true;""",
      substitutionValues: {
        "user": user,
        "pass": pass,
      },
    );

    if (results.isNotEmpty) {
      i = results[0][0];
      u = results[0][1];
      n = results[0][2];
      c = results[0][3];
      r = results[0][4];
      a = results[0][5];
    }
  }
  return User(i, u, n, c, r, a);
}

/* METODOS DE PROYECTOS*/
//metodo que obtiene la lista de clientes
Future<List<Cliente>> getClientes() async {
  List<List<dynamic>> results = await connection.query(
    """select 
      idcliente,
      nombre
    from cliente
    where active = true;""",
  );
  List<Cliente> clientes = [];
  int i = 0;
  String n = "";
  if (results.isNotEmpty) {
    for (var c in results) {
      i = c[0];
      n = c[1];
      clientes.add(Cliente(i, n));
    }
  }
  return clientes;
}

//metodo que obtiene la lista de areas
Future<List<Area>> getAreas() async {
  List<List<dynamic>> results = await connection.query(
    """select 
      idarea,
      nombre
    from area
    where active = true;""",
  );
  List<Area> areas = [];
  int i = 0;
  String n = "";
  if (results.isNotEmpty) {
    for (var a in results) {
      i = a[0];
      n = a[1];
      areas.add(Area(i, n));
    }
  }
  return areas;
}

//metodo para obtener los proyectos
Future<List<Project>> getProyectos(rol, iduser, idarea) async {
  //depende del rol agrega un and al where para traer solo los proyectos correspondientes
  String and = "";
  if (rol == 2) {
    and = "and p.idarea = " + idarea.toString();
  } else if (rol == 3) {
    and = "and p.idcliente = " + iduser.toString();
  }
  List<List<dynamic>> results = await connection.query(
    """select 
      p.idproyecto, 
      p.nombre, 
      p.descripcion, 
      c.idcliente,
      c.nombre,
      a.idarea,
      a.nombre, 
      p.entrega,
      coalesce(div(count(tc.idtarea),nullif(count(t.idtarea),0)),0)::float as porcentaje
    from proyecto p 
    join cliente c on(p.idcliente = c.idcliente) 
    join area a on (p.idarea = a.idarea)
    left join tarea t on (p.idproyecto = t.idproyecto)
    left join tarea tc on (tc.completo = true)
    where p.active = true """ +
        and +
        """
    group by p.idproyecto, c.idcliente , a.idarea;""",
  );
  List<Project> proyectos = [];
  int i = 0;
  String n = "";
  String d = "";
  int ic = 0;
  String c = "";
  int ia = 0;
  String a = "";
  DateTime e = DateTime.now();
  double pc = 0;
  if (results.isNotEmpty) {
    for (var p in results) {
      i = p[0];
      n = p[1];
      d = p[2];
      ic = p[3];
      c = p[4];
      ia = p[5];
      a = p[6];
      e = p[7];
      pc = p[8];
      proyectos.add(Project(i, n, d, ic, c, ia, a, e, pc));
    }
  }
  return proyectos;
}

//metodo para crear un proyecto
crearProyecto(String nom, String desc, int area, int cliente, DateTime entrega,
    String usuario) async {
  await connection.query(
    """insert into proyecto 
      (nombre, descripcion, idarea, idcliente, entrega, created_by)
      values
      (@nom, @desc, @area, @cliente, @entrega, @usuario);""",
    substitutionValues: {
      "nom": nom,
      "desc": desc,
      "area": area,
      "cliente": cliente,
      "entrega": entrega,
      "usuario": usuario,
    },
  );
}

//metodo para editar un proyecto
editarProyecto(int idp, String nom, String desc, int area, int cliente,
    DateTime entrega, String usuario) async {
  await connection.query(
    """update proyecto
    set 
      nombre = @nom,
      descripcion = @desc,
      idarea = @area,
      idcliente = @cliente,
      entrega = @entrega,
      edited_by = @usuario,
      edited_date = now()
    where idproyecto = @idp""",
    substitutionValues: {
      "nom": nom,
      "desc": desc,
      "area": area,
      "cliente": cliente,
      "entrega": entrega,
      "usuario": usuario,
      "idp": idp,
    },
  );
}

//metodo para deshabilitar un proyecto
eliminarProyecto(int idp, String user) async {
  await connection.query(
    """update proyecto
    set 
      active = false,
      deleted_by = @user,
      deleted_date = now()
    where idproyecto = @idp;""",
    substitutionValues: {
      "idp": idp,
      "user": user,
    },
  );
}

/* METODOS DE TAREAS */

//metodo que obtiene la lista de empleados
Future<List<Cliente>> getEmpleados() async {
  List<List<dynamic>> results = await connection.query(
    """select 
      idusuario,
      nombre
    from usuario
    where active = true;""",
  );
  List<Cliente> clientes = [];
  int i = 0;
  String n = "";
  if (results.isNotEmpty) {
    for (var c in results) {
      i = c[0];
      n = c[1];
      clientes.add(Cliente(i, n));
    }
  }
  return clientes;
}

//metodo que obtiene la lista de urgencias
Future<List<Urgencia>> getUrgencias() async {
  List<List<dynamic>> results = await connection.query(
    """select 
      idurgencia,
      nombre,
      color
    from urgencia
    where active = true;""",
  );
  List<Urgencia> urgencias = [];
  int i = 0;
  String n = "";
  String c = "";
  if (results.isNotEmpty) {
    for (var u in results) {
      i = u[0];
      n = u[1];
      c = u[2];
      urgencias.add(Urgencia(i, n, c));
    }
  }
  return urgencias;
}

//metodo para obtener las tareas
Future<List<Task>> getTareas(int idp) async {
  List<List<dynamic>> results = await connection.query(
    """select 
      t.idtarea,
      t.nombre,
      t.descripcion,
      u.idurgencia,
      u.nombre,
      u.color,
      t.entrega
    from tarea t
    join urgencia u on (u.idurgencia = t.idurgencia)
    where t.idproyecto = @idp and t.active = true;""",
    substitutionValues: {"idp": idp},
  );
  List<Task> tareas = [];
  int i = 0;
  String n = "";
  String d = "";
  int iu = 0;
  String u = "";
  String c = "";
  DateTime e = DateTime.now();
  if (results.isNotEmpty) {
    for (var t in results) {
      i = t[0];
      n = t[1];
      d = t[2];
      iu = t[3];
      u = t[4];
      c = t[5];
      e = t[6];
      tareas.add(Task(i, n, d, iu, u, c, e));
    }
  }
  return tareas;
}

//metodo para crear un proyecto
crearTarea(String nom, String desc, int area, int cliente, DateTime entrega,
    String usuario) async {
  await connection.query(
    """insert into proyecto 
      (nombre, descripcion, idarea, idcliente, entrega, created_by)
      values
      (@nom, @desc, @area, @cliente, @entrega, @usuario);""",
    substitutionValues: {
      "nom": nom,
      "desc": desc,
      "area": area,
      "cliente": cliente,
      "entrega": entrega,
      "usuario": usuario,
    },
  );
}

//metodo para editar un proyecto
editarTarea(int idp, String nom, String desc, int area, int cliente,
    DateTime entrega, String usuario) async {
  await connection.query(
    """update proyecto
    set 
      nombre = @nom,
      descripcion = @desc,
      idarea = @area,
      idcliente = @cliente,
      entrega = @entrega,
      edited_by = @usuario,
      edited_date = now()
    where idproyecto = @idp""",
    substitutionValues: {
      "nom": nom,
      "desc": desc,
      "area": area,
      "cliente": cliente,
      "entrega": entrega,
      "usuario": usuario,
      "idp": idp,
    },
  );
}

//metodo para deshabilitar un proyecto
eliminarTarea(int idp, String user) async {
  await connection.query(
    """update proyecto
    set 
      active = false,
      deleted_by = @user,
      deleted_date = now()
    where idproyecto = @idp;""",
    substitutionValues: {
      "idp": idp,
      "user": user,
    },
  );
}
