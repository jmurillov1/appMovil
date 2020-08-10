class DetalleCredito {
  int codigo;
  int numCuota;
  double interes;
  double monto;
  double saldo;
  double cuota;
  DateTime fechaPago;
  String estado;

  int get getCodigo => codigo;

  set setCodigo(int codigo) => this.codigo = codigo;

  int get getNumCuota => numCuota;

  set setNumCuota(int numCuota) => this.numCuota = numCuota;

  double get getInteres => interes;

  set setInteres(double interes) => this.interes = interes;

  double get getMonto => monto;

  set setMonto(double monto) => this.monto = monto;

  double get getSaldo => saldo;

  set setSaldo(double saldo) => this.saldo = saldo;

  double get getCuota => cuota;

  set setCuota(double cuota) => this.cuota = cuota;

  String get getEstado => estado;

  set setEstado(String estado) => this.estado = estado;

  DateTime get getFechaPago => fechaPago;

  set setFechaPago(DateTime fechaPago) => this.fechaPago = fechaPago;

  DetalleCredito.fromJson(Map<String, dynamic> json)
      : codigo = json['codigoDetalle'],
        estado = json['estado'],
        monto = json['monto'],
        interes = json['interes'],
        fechaPago =
            DateTime.fromMillisecondsSinceEpoch(json['fechaPago']),
        numCuota = json['numeroCuota'],
        saldo = json['saldo'],
        cuota = json['cuota'];
}
