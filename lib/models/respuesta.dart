import 'package:coop/models/credito.dart';
import 'package:coop/models/cuenta.dart';

class Respuesta {
  int codigo;
  String descripcion;
  Cuenta cuenta;
  List<Credito> creditos;

 int get getCodigo => codigo;

 set setCodigo(int codigo) => this.codigo = codigo;

 String get getDescripcion => descripcion;

 set setDescripcion(String descripcion) => this.descripcion = descripcion;

 Cuenta get getCuenta => cuenta;

  set setCuenta(Cuenta cuenta) => this.cuenta = cuenta;

 List get getCreditos => creditos;

 set setCreditos(List<Credito> creditos) => this.creditos = creditos;

}
