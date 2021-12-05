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
  if (rol == 3) {
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
      coalesce (count(CASE WHEN t.completo THEN 1 END)/nullif(count(t.idtarea),0)::float,0)  as porcentaje
    from proyecto p 
    join cliente c on(p.idcliente = c.idcliente) 
    join area a on (p.idarea = a.idarea)
    left join proyecto_tarea t on (p.idproyecto = t.idproyecto and t.active = true)
    where p.active = true """ +
        and +
        """
    group by p.idproyecto, c.idcliente , a.idarea
    order by porcentaje;""",
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

//metodo para obtener el ultimo id de la tabla tarea
Future<int> getLastProyecto() async {
  List<List<dynamic>> results = await connection.query("""
  select coalesce (max(idproyecto),0) from proyecto;
  """);
  if (results.isNotEmpty) {
    return results[0][0];
  }
  return 0;
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
  List<Cliente> empleados = [];
  int i = 0;
  String n = "";
  if (results.isNotEmpty) {
    for (var c in results) {
      i = c[0];
      n = c[1];
      empleados.add(Cliente(i, n));
    }
  }
  return empleados;
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

//metodo para obtener las tareas (generales)
Future<List<Task>> getTareasGeneral() async {
  List<List<dynamic>> results = await connection.query(
    """select 
      t.idtarea,
      t.nombre,
      t.descripcion
    from tarea t
    where t.active = true;""",
  );
  List<Task> tareas = [];
  int i = 0;
  int ip = 0;
  String n = "";
  String d = "";
  int iu = 0;
  String u = "";
  String c = "";
  DateTime e = DateTime.now();
  bool done = false;
  List<Cliente> asig = [];
  if (results.isNotEmpty) {
    for (var t in results) {
      i = t[0];
      n = t[1];
      d = t[2];
      tareas.add(Task(i, ip, n, d, iu, u, c, e, done, asig));
    }
  }
  return tareas;
}

//metodo para obtener las tareas (por proyecto)
Future<List<Task>> getTareas(int idp) async {
  List<List<dynamic>> results = await connection.query(
    """select 
      t.idtarea,
      pt.idproyecto_tarea,
      t.nombre,
      t.descripcion,
      u.idurgencia,
      u.nombre,
      u.color,
      pt.entrega,
      pt.completo
    from tarea t
	join proyecto_tarea pt on (pt.idtarea = t.idtarea)
    join urgencia u on (u.idurgencia = pt.idurgencia)
    where pt.idproyecto = @idp and pt.active = true
    order by u.idurgencia desc, pt.completo;""",
    substitutionValues: {"idp": idp},
  );
  List<Task> tareas = [];
  int i = 0;
  int ip = 0;
  String n = "";
  String d = "";
  int iu = 0;
  String u = "";
  String c = "";
  DateTime e = DateTime.now();
  bool done = false;
  List<Cliente> asig = [];
  if (results.isNotEmpty) {
    for (var t in results) {
      i = t[0];
      ip = t[1];
      n = t[2];
      d = t[3];
      iu = t[4];
      u = t[5];
      c = t[6];
      e = t[7];
      done = t[8];
      asig = await getAsignados(ip);
      tareas.add(Task(i, ip, n, d, iu, u, c, e, done, asig));
    }
  }
  return tareas;
}

//metodo para obtener asignados actuales a tarea existente
Future<List<Cliente>> getAsignados(int idt) async {
  List<List<dynamic>> results = await connection.query(
    """  select 
      u.idusuario,
      u.nombre
    from usuario u
    inner join usuario_tarea ut on (u.idusuario = ut.idusuario)
    where ut.idtarea = @idt and ut.active = true;""",
    substitutionValues: {
      "idt": idt,
    },
  );
  List<Cliente> asignados = [];
  int i = 0;
  String n = "";
  if (results.isNotEmpty) {
    for (var c in results) {
      i = c[0];
      n = c[1];
      asignados.add(Cliente(i, n));
    }
  }
  return asignados;
}

//metodo para crear una tarea (general)
crearTareaGeneral(int idt, String nom, String desc, String usuario) async {
  await connection.query(
    """insert into tarea 
      (nombre, descripcion, created_by)
      values
      (@nom, @desc, @usuario);""",
    substitutionValues: {
      "nom": nom,
      "desc": desc,
      "usuario": usuario,
    },
  );
}

//metodo para crear una tarea (por proyecto)
crearTarea(int idpt, int idt, int idp, int urgencia, DateTime entrega,
    bool completado, String usuario, List<Cliente> asignados) async {
  await connection.query(
    """insert into proyecto_tarea 
      (idproyecto, idtarea, idurgencia, entrega, completo, created_by)
      values
      (@idp, @idt, @urg, @entrega, @check, @usuario);""",
    substitutionValues: {
      "idt": idt,
      "idp": idp,
      "urg": urgencia,
      "entrega": entrega,
      "check": completado,
      "usuario": usuario,
    },
  );
  for (var a in asignados) {
    await connection.query(
      """
    insert into usuario_tarea
    (idusuario,idtarea,created_by)
    values
    (@ida,@idt,@usuario);""",
      substitutionValues: {"idt": idpt, "ida": a.id, "usuario": usuario},
    );
  }
}

//metodo para editar una tarea (general)
editarTareaGeneral(int idt, String nom, String desc, String usuario) async {
  await connection.query(
    """update tarea
    set 
      nombre = @nom,
      descripcion = @desc,
      edited_by = @usuario,
      edited_date = now()
    where idtarea = @idt""",
    substitutionValues: {
      "nom": nom,
      "desc": desc,
      "idt": idt,
      "usuario": usuario,
    },
  );
}

//metodo para editar una tarea (por proyecto)
editarTarea(int idpt, int idt, int urgencia, DateTime entrega, bool completado,
    String usuario, List<Cliente> asignados, List<Cliente> previos) async {
  await connection.query(
    """update proyecto_tarea
    set 
      idtarea = @idt,
      idurgencia = @urg,
      entrega = @entrega,
      completo = @check,
      edited_by = @usuario,
      edited_date = now()
    where idproyecto_tarea = @idpt""",
    substitutionValues: {
      "idt": idt,
      "urg": urgencia,
      "entrega": entrega,
      "check": completado,
      "usuario": usuario,
      "idpt": idpt,
    },
  );
  if (previos != asignados) {
    bool encontrado = false;
    for (var a in asignados) {
      previos.firstWhere((e) {
        if (e.id == a.id) encontrado = true;
        return e.id == a.id;
      }, orElse: () {
        encontrado = false;
        return Cliente(0, "");
      });
      if (!encontrado) {
        await connection.query(
          """
          insert into usuario_tarea
          (idusuario,idtarea,created_by)
          values
          (@ida,@idt,@usuario);""",
          substitutionValues: {"idt": idpt, "ida": a.id, "usuario": usuario},
        );
      }
    }
    for (var a in previos) {
      asignados.firstWhere((e) {
        if (e.id == a.id) encontrado = true;
        return e.id == a.id;
      }, orElse: () {
        encontrado = false;
        return Cliente(0, "");
      });
      if (!encontrado) {
        await connection.query(
          """
          update usuario_tarea
          set
          active = false,
          deleted_date = now(),
          deleted_by = @usuario
          where idtarea = @idt and idusuario = @ida;""",
          substitutionValues: {"idt": idpt, "ida": a.id, "usuario": usuario},
        );
      }
    }
  }
}

checkTarea(int idt, bool check, String usuario) async {
  await connection.query(
    """update proyecto_tarea
    set 
      completo = @check,
      edited_by = @usuario,
      edited_date = now()
    where idproyecto_tarea = @idt""",
    substitutionValues: {
      "idt": idt,
      "check": check,
      "usuario": usuario,
    },
  );
}

//metodo para deshabilitar una tarea (general)
eliminarTareaGeneral(int idt, String user) async {
  await connection.query(
    """update tarea
    set 
      active = false,
      deleted_by = @user,
      deleted_date = now()
    where idtarea = @idt;""",
    substitutionValues: {
      "idt": idt,
      "user": user,
    },
  );

  await connection.query(
    """update proyecto_tarea
    set 
      active = false,
      deleted_by = @user,
      deleted_date = now()
    where idtarea = @idt;""",
    substitutionValues: {
      "idt": idt,
      "user": user,
    },
  );
}

//metodo para deshabilitar una tarea (por proyecto)
eliminarTarea(int idpt, String user) async {
  await connection.query(
    """update proyecto_tarea
    set 
      active = false,
      deleted_by = @user,
      deleted_date = now()
    where idproyecto_tarea = @idpt;""",
    substitutionValues: {
      "idpt": idpt,
      "user": user,
    },
  );
}

//metodo para obtener el ultimo id de la tabla proyecto_tarea
Future<int> getLastTarea() async {
  List<List<dynamic>> results = await connection.query("""
  select coalesce (max(idproyecto_tarea),0) from proyecto_tarea;
  """);
  if (results.isNotEmpty) {
    return results[0][0];
  }
  return 0;
}

//metodo para obtener el ultimo id de la tabla tarea
Future<int> getLastTareaGeneral() async {
  List<List<dynamic>> results = await connection.query("""
  select coalesce (max(idtarea),0) from tarea;
  """);
  if (results.isNotEmpty) {
    return results[0][0];
  }
  return 0;
}
