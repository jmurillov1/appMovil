class Transferencia {
  String cedula;
  String cuenta;
  double monto;

  String get getCedula => cedula;

  set setCedula(String cedula) => this.cedula = cedula;

  String get getCuenta => cuenta;

  set setCuenta(String cuenta) => this.cuenta = cuenta;

  double get getMonto => monto;

  set setMonto(double monto) => this.monto = monto;

  Map<String, dynamic> toJson() => {
        'cedula': cedula,
        'cuentaDeAhorro': cuenta,
        'monto': monto,
      };
}
