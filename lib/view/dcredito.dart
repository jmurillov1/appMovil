import 'package:coop/main.dart';
import 'package:coop/models/credito.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var globalContext;

class Detalle extends StatelessWidget {
  Detalle(this.credito);
  final Credito credito;

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(title: 'Detalle de Crédito', credito: credito),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title, this.credito}) : super(key: key);

  final String title;
  final Credito credito;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _select(value) {
    if (value == 0)
      setState(() {
        Navigator.pop(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      });
  }

  String transformar(fecha) {
    var nFecha = fecha.toString().split(" ")[0].split("-");
    return nFecha[2] + "/" + nFecha[1] + "/" + nFecha[0];
  }

  List<ListTile> _detalles() {
    var list = List<ListTile>();
    for (var each in widget.credito.detalles) {
      list.add(ListTile(
        title: Text(
          'Cuota: ' + each.numCuota.toString(),
          style: new TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Código: " + each.codigo.toString(),
              style: TextStyle(fontSize: 15.0, color: Colors.black),
            ),
            Text("Pago: " + transformar(each.fechaPago),
                style: TextStyle(fontSize: 15.0, color: Colors.black)),
            Text("Estado: " + each.estado,
                style: TextStyle(fontSize: 15.0, color: Colors.black)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Monto Restante: ",
                    style: TextStyle(fontSize: 18.0, color: Colors.black), textAlign: TextAlign.left),
                Text(each.monto.toString(),
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Valor a Pagar:\$ ",
                    style: TextStyle(fontSize: 18.0, color: Colors.black), textAlign: TextAlign.left),
                Text(each.saldo.toString(),
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
              ],
            ),
          ],
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(globalContext);
          },
        ),
        title: Text("Tabla de Crédito"),
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
      body: paginaPrincipal(),
    );
  }

  Widget paginaPrincipal() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber[50],
      ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        children: ListTile.divideTiles(
          context: context,
          tiles: _detalles(),
        ).toList(),
      ),
    );
  }
}
