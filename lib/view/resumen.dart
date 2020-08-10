import 'package:coop/main.dart';
import 'package:coop/models/credito.dart';
import 'package:coop/models/respuesta.dart';
import 'package:coop/view/dcredito.dart';
import 'package:coop/view/trexterna.dart';
import 'package:coop/view/trinterna.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cambio.dart';

class Resumen extends StatelessWidget {
  Resumen(this.respuesta);
  final Respuesta respuesta;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(title: 'Estado de Cuenta', respuesta: respuesta),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title, this.respuesta}) : super(key: key);
  final String title;
  final Respuesta respuesta;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _select(value) {
    if (value == 0)
      setState(() {
        sesion = false;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      });
  }

  String transformar(fecha) {
    var nFecha = fecha.toString().split(" ")[0].split("-");
    return nFecha[2] + "/" + nFecha[1] + "/" + nFecha[0];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        appBar: new AppBar(
          title: Text("Estado de Cuenta"),
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
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                  ),
                ),
              ),
              ListTile(
                title: Text('Estado de Cuenta'),
                onTap: () {
                  Navigator.pop(context);
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TrExterna(widget.respuesta)));
                },
              ),
            ],
          ),
        ),
        body: paginaPrincipal(),
      ),
    );
  }

  Widget paginaPrincipal() {
    final double saldo = widget.respuesta.cuenta.saldo;
    void _item(int which) {
      Credito cre;
      for (var item in widget.respuesta.creditos) {
        if (item.codigo == which) {
          cre = item;
        }
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Detalle(cre)));
    }

    List<ListTile> _creditos() {
      var list = List<ListTile>();
      for (var each in widget.respuesta.creditos) {
        list.add(ListTile(
          title: Text(
            'Código: ' + each.codigo.toString(),
            style: new TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Registro: " + transformar(each.fechaRegistro),
                style: TextStyle(fontSize: 14.0, color: Colors.black),
              ),
              Text("Vence: " + transformar(each.fechaVencimiento),
                  style: TextStyle(fontSize: 14.0, color: Colors.black)),
              Text("Estado: " + each.estado,
                  style: TextStyle(fontSize: 14.0, color: Colors.black)),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Monto: " + each.monto.toString(),
                  style: TextStyle(fontSize: 15.0)),
              SizedBox(
                width: 5.0,
              ),
              Text("Interés: " + each.interes.toString() + "%",
                  style: TextStyle(fontSize: 15.0)),
              IconButton(
                icon: Icon(
                  CupertinoIcons.right_chevron,
                  size: 20.0,
                  color: Colors.black,
                ),
                onPressed: () {
                  _item(each.codigo);
                },
              ),
            ],
          ),
        ));
      }
      return list;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.amber[50],
      ),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Saldo de Cuenta",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "Cuenta # "+ widget.respuesta.cuenta.numero,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            height: 200.0,
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Icon(
                    Icons.monetization_on,
                    size: 60.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("$saldo",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.lightGreen[300],
              shape: BoxShape.circle,
              border: Border.all(width: 5.0, color: Colors.black),
            ),
          ),
           SizedBox(
            height: 30.0,
          ),
          Text(
            widget.respuesta.cuenta.cliente.nombre+" "+widget.respuesta.cuenta.cliente.apellido,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            "Créditos del Cliente",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 40.0,
          ),
          Container(
            height: 300.0,
            width: 450.0,
            decoration: BoxDecoration(
              color: Colors.lightGreen[300],
              border: Border.all(width: 2.5, color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              children: ListTile.divideTiles(
                context: context,
                tiles: _creditos(),
              ).toList(),
            ),
          ),
        ],
      )),
    );
  }
}
