import 'package:coop/controllers/services.dart';
import 'package:coop/main.dart';
import 'package:coop/models/respuesta.dart';
import 'package:coop/view/trexterna.dart';
import 'package:coop/view/trinterna.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coop/view/resumen.dart';

class Cambio extends StatelessWidget {
  Cambio(this.respuesta);
  final Respuesta respuesta;
  @override
  Widget build(BuildContext context) {
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
  final cor = TextEditingController();
  final cv = TextEditingController();
  final cn = TextEditingController();

  showAlertDialog(BuildContext context, String titulo, String des) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
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

  _showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        _view();
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Confirmación"),
      content: Text("Desea Continuar"),
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
    var correo = cor.text;
    var contraAntigua = cv.text;
    var contraNueva = cn.text;
    var res =
        await ServiciosDAO.cambioClave(correo, contraAntigua, contraNueva);
    print(res.descripcion);
    if (res.codigo == 1) {
      showAlertDialog(context, "Exitoso",
          res.descripcion + " La nueva contraseña fue enviada a su correo");
      widget.respuesta = await ServiciosDAO.login(
          widget.respuesta.cuenta.cliente.usuario, contraNueva);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Resumen(widget.respuesta)));
    } else {
      showAlertDialog(context, "error", res.descripcion);
    }
    setState(() {});
  }

  bool _obscureTextV = true;
  Icon _iconV = Icon(Icons.visibility_off);
  void _toggleV() {
    setState(() {
      _obscureTextV = !_obscureTextV;
      _iconV = Icon(Icons.visibility);
    });
  }

  bool _obscureTextN = true;
  Icon _iconN = Icon(Icons.visibility_off);
  void _toggleN() {
    setState(() {
      _obscureTextN = !_obscureTextN;
      _iconN = Icon(Icons.visibility);
    });
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
        title: Text("Cambio de Contraseña"),
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
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Transacciones Internas'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TrInterna(widget.respuesta)));
              },
            ),
            ListTile(
              title: Text('Transacciones Externas'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TrExterna(widget.respuesta)));
              },
            ),
          ],
        ),
      ),
      body: paginaPrincipal(),
    );
  }

  Widget paginaPrincipal() {
    cor.text = widget.respuesta.cuenta.cliente.correo;
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber[100],
      ),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Ingreso de Datos",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.mail),
                  hintText: "Correo",
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )),
              textAlign: TextAlign.center,
              controller: cor,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: TextFormField(
              obscureText: _obscureTextV,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Contraseña Vieja",
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  suffixIcon: IconButton(
                      icon: _iconV,
                      onPressed: () {
                        _toggleV();
                      })),
              textAlign: TextAlign.center,
              controller: cv,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: TextFormField(
              obscureText: _obscureTextN,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Contraseña Nueva",
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  suffixIcon: IconButton(
                      icon: _iconN,
                      onPressed: () {
                        _toggleN();
                      })),
              textAlign: TextAlign.center,
              controller: cn,
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
                        _showAlertDialog(context);
                      }),
                  SizedBox(
                    width: 35.0,
                  ),
                  RaisedButton(
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.pop(context);
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
