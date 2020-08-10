class TransferenciaExterna {
  DateTime fechaTransaccion;
  double montoTransferencia;
  String nombreInstitucionExterna;
  String cuentaPersonaLocal;
  String cuentaPersonaExterna;
  String nombrePersonaExterna;
  String apellidoPersonaExterna;

  DateTime get getFechaTransaccion => fechaTransaccion;

  set setFechaTransaccion(DateTime fechaTransaccion) =>
      this.fechaTransaccion = fechaTransaccion;

  double get getMontoTransferencia => montoTransferencia;

  set setMontoTransferencia(double montoTransferencia) =>
      this.montoTransferencia = montoTransferencia;

  String get getNombreInstitucionExterna => nombreInstitucionExterna;

  set setNombreInstitucionExterna(String nombreInstitucionExterna) =>
      this.nombreInstitucionExterna = nombreInstitucionExterna;

  String get getCuentaPersonaLocal => cuentaPersonaLocal;

  set setCuentaPersonaLocal(String cuentaPersonaLocal) =>
      this.cuentaPersonaLocal = cuentaPersonaLocal;

  String get getCuentaPersonaExterna => cuentaPersonaExterna;

  set setCuentaPersonaExterna(String cuentaPersonaExterna) =>
      this.cuentaPersonaExterna = cuentaPersonaExterna;

  String get getNombrePersonaExterna => nombrePersonaExterna;

  set setNombrePersonaExterna(String nombrePersonaExterna) =>
      this.nombrePersonaExterna = nombrePersonaExterna;

  String get getApellidoPersonaExterna => apellidoPersonaExterna;

  set setApellidoPersonaExterna(String apellidoPersonaExterna) =>
      this.apellidoPersonaExterna = apellidoPersonaExterna;

  Map<String, dynamic> toJson() => {
        'fechaTransaccion': fechaTransaccion,
        'montoTransferencia': montoTransferencia,
        'nombreInstitucionExterna': nombreInstitucionExterna,
        'cuentaPersonaLocal': cuentaPersonaLocal,
        'cuentaPersonaExterna': cuentaPersonaExterna,
        'nombrePersonaExterna': nombrePersonaExterna,
        'apellidoPersonaExterna': apellidoPersonaExterna
      };
}
