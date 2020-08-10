import 'package:coop/models/detalleCredito.dart';

class Credito {
  int codigo;
  String estado;
  double monto;
  double interes;
  DateTime fechaRegistro;
  DateTime fechaVencimiento;
  List<DetalleCredito> detalles;

  int get getCodigo => codigo;

  set setCodigo(int codigo) => this.codigo = codigo;

  String get getEstado => estado;

  set setEstado(String estado) => this.estado = estado;

  double get getMonto => monto;

  set setMonto(double monto) => this.monto = monto;

  double get getInteres => interes;

  set setInteres(double interes) => this.interes = interes;

  DateTime get getFechaRegistro => fechaRegistro;

  set setFechaRegistro(DateTime fechaRegistro) =>
      this.fechaRegistro = fechaRegistro;

  DateTime get getFechaVencimiento => fechaVencimiento;

  set setFechaVencimiento(DateTime fechaVencimiento) =>
      this.fechaVencimiento = fechaVencimiento;

  List get getDetalles => detalles;

  set setDetalles(List detalles) => this.detalles = detalles;

  static List<DetalleCredito> listado(lista) {
    List<DetalleCredito> dets = new List();
    for (var item in lista) {
      DetalleCredito det = DetalleCredito.fromJson(item);
      dets.add(det);
    }
    return dets;
  }

  Credito.fromJson(Map<String, dynamic> json)
      : codigo = json['codigoCredito'],
        estado = json['estado'],
        monto = json['monto'],
        interes = json['interes'],
        fechaRegistro =
            DateTime.fromMillisecondsSinceEpoch(json['fechaRegistro']),
        fechaVencimiento =
            DateTime.fromMillisecondsSinceEpoch(json['fechaVencimiento']),
        detalles = listado(json['detalles']);
}
