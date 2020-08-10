import 'package:coop/controllers/services.dart';
import 'package:coop/main.dart';
import 'package:coop/models/respuesta.dart';
import 'package:coop/models/transferencia.dart';
import 'package:coop/view/cambio.dart';
import 'package:coop/view/trexterna.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coop/view/resumen.dart';

var globalContext;

class TrInterna extends StatelessWidget {
  TrInterna(this.respuesta);
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
  final cue = TextEditingController();
  final ced = TextEditingController();
  final nom = TextEditingController();
  final ape = TextEditingController();
  final dir = TextEditingController();
  final mon = TextEditingController();

  void _showAlertDialog(BuildContext context, String mensaje) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Error"),
      content: Text("$mensaje"),
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

  void showAlertDialog(BuildContext context, String titulo, String des) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        cue.clear();
        ced.clear();
        dir.clear();
        nom.clear();
        ape.clear();
        mon.clear();
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
    Transferencia trans = new Transferencia();
    trans.cedula = widget.respuesta.cuenta.cliente.cedula;
    trans.cuenta = cue.text;
    trans.monto = double.parse(mon.text);
    var transferencia = trans.toJson();
    var res = await ServiciosDAO.transferencia(transferencia);
    if (res.codigo == 1) {
      showAlertDialog(context, "Exito", res.descripcion);
    } else {
      showAlertDialog(context, "Error", res.descripcion);
    }
    print("Respuesta");
    print(widget.respuesta);
    print("Fin Respuesta");
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Cambio(widget.respuesta)));
              },
            ),
            ListTile(
              title: Text('Transacciones Internas'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Transacciones Externas'),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TrExterna(widget.respuesta)));
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
            "Datos Cliente Destino",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Padding(
                      padding: EdgeInsets.all(15), child: Text('Cuenta #')),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 30.0,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      var res = await ServiciosDAO.busqueda(cue.text);
                      if (res != null) {
                        if (widget.respuesta.cuenta.numero != cue.text) {
                          ced.text = res.cuenta.cliente.cedula;
                          nom.text = res.cuenta.cliente.nombre;
                          ape.text = res.cuenta.cliente.apellido;
                          dir.text = res.cuenta.cliente.direccion;
                        } else {
                          _showAlertDialog(
                              context, "No puede transferir dinero así mismo");
                        }
                      }
                    },
                  ),
                  hintText: "Número de Cuenta",
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )),
              textAlign: TextAlign.center,
              controller: cue,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: TextFormField(
              enabled: false,
              decoration: InputDecoration(
                  prefixIcon: Padding(
                      padding: EdgeInsets.all(15), child: Text('Cédula')),
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )),
              textAlign: TextAlign.center,
              controller: ced,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: TextFormField(
              enabled: false,
              decoration: InputDecoration(
                  prefixIcon: Padding(
                      padding: EdgeInsets.all(15), child: Text('Nombres')),
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )),
              textAlign: TextAlign.center,
              controller: nom,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: TextFormField(
              enabled: false,
              decoration: InputDecoration(
                  prefixIcon: Padding(
                      padding: EdgeInsets.all(15), child: Text('Apellidos')),
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )),
              textAlign: TextAlign.center,
              controller: ape,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: TextFormField(
              enabled: false,
              decoration: InputDecoration(
                  prefixIcon: Padding(
                      padding: EdgeInsets.all(15), child: Text('Dirección')),
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )),
              textAlign: TextAlign.center,
              controller: dir,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Padding(
                      padding: EdgeInsets.all(15), child: Text('Monto')),
                  hintText: "Monto",
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )),
              textAlign: TextAlign.center,
              controller: mon,
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
                        cue.clear();
                        ced.clear();
                        dir.clear();
                        nom.clear();
                        ape.clear();
                        mon.clear();
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
