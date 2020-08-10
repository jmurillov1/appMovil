import 'package:coop/models/cliente.dart';

class Cuenta {
  String numero;
  DateTime fechaRegistro;
  double saldo;
  Cliente cliente;

  String get getNumero => numero;

  set setNumero(String numero) => this.numero = numero;

  DateTime get getFechaRegistro => fechaRegistro;

  set setFechaRegistro(DateTime fechaRegistro) => this.fechaRegistro = fechaRegistro;

  double get getSaldo => saldo;

  set setSaldo(double saldo) => this.saldo = saldo;

  Cliente get getCliente => cliente;

  set setCliente(Cliente cliente) => this.cliente = cliente;

  Cuenta.fromJson(Map<String, dynamic> json)
      : numero = json['numeroCuentaDeAhorro'],
        fechaRegistro =
            DateTime.fromMillisecondsSinceEpoch(json['fechaDeRegistro']),
        saldo = json['saldoCuentaDeAhorro'],
        cliente = Cliente.fromJson(json['cliente']);
}
