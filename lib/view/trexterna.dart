import 'package:coop/controllers/services.dart';
import 'package:coop/models/respuesta.dart';
import 'package:coop/models/transferenciaExterna.dart';
import 'package:coop/view/cambio.dart';
import 'package:coop/view/resumen.dart';
import 'package:coop/view/trinterna.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

var globalContext;

class TrExterna extends StatelessWidget {
  TrExterna(this.respuesta);
  final Respuesta respuesta;

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coop JAM',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Coop JAM', respuesta: respuesta),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.respuesta}) : super(key: key);
  final String title;
  Respuesta respuesta;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cuenta = TextEditingController();
  final monto = TextEditingController();
  final institucion = TextEditingController();
  final nombre = TextEditingController();
  final apellido = TextEditingController();

  void showAlertDialog(BuildContext context, String titulo, String des) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        institucion.clear();
        nombre.clear();
        cuenta.clear();
        apellido.clear();
        monto.clear();
      },
    );

    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(des),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showAlertDialog2(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () async {
        _view();
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Confirmación"),
      content: Text("Desea realizar la transacción?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _view() async {
    TransferenciaExterna trans = new TransferenciaExterna();
    trans.cuentaPersonaLocal = widget.respuesta.cuenta.numero;
    trans.fechaTransaccion = null;
    trans.nombreInstitucionExterna = institucion.text;
    trans.apellidoPersonaExterna = apellido.text;
    trans.nombrePersonaExterna = nombre.text;
    trans.cuentaPersonaExterna = cuenta.text;
    trans.montoTransferencia = double.parse(monto.text);
    print(trans);
    var transferencia = trans.toJson();
    var res = await ServiciosDAO.transferenciaExterna(transferencia);
    if (res.codigo == 1) {
      showAlertDialog(context, "Éxito", res.descripcion);
    } else {
      showAlertDialog(context, "Error", res.descripcion);
    }
    
    widget.respuesta = await ServiciosDAO.login(
        widget.respuesta.cuenta.cliente.usuario,
        widget.respuesta.cuenta.cliente.clave);
    setState(() {});
  }

  void _select(value) {
    if (value == 0)
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Transferencia Interna"),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: _select,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 7.0,
                    ),
                    Text("Salir"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 90.0,
              child: DrawerHeader(
                child: Text(
                  'Servicios',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
              ),
            ),
            ListTile(
              title: Text('Estado de Cuenta'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Resumen(widget.respuesta)));
              },
            ),
            ListTile(
              title: Text('Cambio de Contraseña'),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Cambio(widget.respuesta)));
              },
            ),
            ListTile(
              title: Text('Transacciones Internas'),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TrInterna(widget.respuesta)));
              },
            ),
            ListTile(
              title: Text('Transacciones Externas'),
              onTap: () {
                //Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: paginaPrincipal(),
    );
  }

  Widget paginaPrincipal() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber[100],
      ),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Datos Cliente Destino Externo",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_balance),
                  hintText: "Institución Financiera",
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )),
              textAlign: TextAlign.center,
              controller: institucion,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.dialpad),
                  hintText: "Número de Cuenta",
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )),
              textAlign: TextAlign.center,
              controller: cuenta,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: "Nombres",
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )),
              textAlign: TextAlign.center,
              controller: nombre,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: "Apellidos",
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )),
              textAlign: TextAlign.center,
              controller: apellido,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.monetization_on),
                  hintText: "Monto",
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )),
              textAlign: TextAlign.center,
              controller: monto,
            ),
          ),
          Container(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                      child: Text("Aceptar"),
                      onPressed: () {
                        _showAlertDialog2(context);
                      }),
                  SizedBox(
                    width: 35.0,
                  ),
                  RaisedButton(
                      child: Text("Cancelar"),
                      onPressed: () {
                        institucion.clear();
                        nombre.clear();
                        cuenta.clear();
                        apellido.clear();
                        monto.clear();
                      }),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
