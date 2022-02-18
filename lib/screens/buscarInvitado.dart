import 'dart:convert';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:fragos_greend_gold_codeqr/widget/carga.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

var nomselect;
FToast fToast = FToast();

class Invitado {
  var nombre;
  var ocupacion;
  var tipo;
  var idRegistro;
  var grupo;

  Invitado(this.nombre, this.ocupacion, this.tipo, this.idRegistro, this.grupo);
}

class BuscadorInv extends StatefulWidget {
  BuscadorInv({Key? key}) : super(key: key);

  @override
  _BuscadorInvState createState() => _BuscadorInvState();
}

class _BuscadorInvState extends State<BuscadorInv> {
  List vacia = [];
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: BuscaEmpresa(list: vacia),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Preciona el icon de lupa para poder buscar un invitado'),
            Icon(
              Icons.search,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("This is a Custom Toast"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

    // Custom Toast Position
    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 16.0,
            left: 16.0,
          );
        });
  }
}

class BuscaEmpresa extends SearchDelegate<String> {
  List<dynamic> list;

  BuscaEmpresa({required this.list});
  var registro;

  Future showAllPost() async {
    List<Invitado> listaInvtados = [];
    var url2 = Uri.parse(
        "https://unaindustriamillonaria.com/archivos_php/registros/buscar_registros_nombre.php");
    Map cuerpo = {'nombre': query};
    var body = jsonEncode(cuerpo);
    final response = await http.post(url2, body: body);
    var datauser = json.decode(response.body);
    for (var i in datauser) {
      // print('object');
      //print(datauser);
      Invitado inv = Invitado(i['nombre'], i['ocupacion'], i['respuesta'],
          i['id_registro'], i['grupo']);
      listaInvtados.add(inv);
    }

    return listaInvtados;
  }

  Future asistencia(idRegistro, tipo) async {
    var url = Uri.parse(
        "https://unaindustriamillonaria.com/archivos_php/asistencias/agregar_asistencia.php");
    Map cuerpo = {"id": "$idRegistro", "usuario": "$tipo"};
    var body = jsonEncode(cuerpo);

    try {
      final response = await http.post(url, body: body);
      // ignore: unused_local_variable
      var datauser = json.decode(response.body);
      //busquedaAsistencia(idRegistro);
      //print(body);
    } catch (e) {
      print('error: $e');
    }
  }

  Future busquedaAsistencia(idRegistro) async {
    var url = Uri.parse(
        "https://unaindustriamillonaria.com/archivos_php/asistencias/buscar_asistencia_id.php");
    Map cuerpo = {"id": idRegistro};
    var body = jsonEncode(cuerpo);

    try {
      final response = await http.post(url, body: body);
      var datauser = json.decode(response.body);
      datauser['status'] == true ? registro = 'registrado' : print(body);
      print(registro);
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = ''; //texto del textfild restablecido
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().length == 0) {
      return Center(child: Text('Invitado'));
    }
    return FutureBuilder(
      future: showAllPost(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _crearCart(snapshot);
        }
        return Center(child: Carga());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var listData = query.isEmpty
        ? list
        : list
            .where((element) => element.toLowerCase().contains(query))
            .toList();
    return listData.isEmpty
        ? Center(child: Text('Sin resultados'))
        : ListView.builder(
            itemCount: listData.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  query = listData[index];
                  nomselect = listData[index];
                  showResults(context);
                  // Navigator.pushReplacementNamed(context, '/ConsultaEmpresa');
                },
                title: Text(listData[index]),
              );
            });
  }

  Widget _crearCart(AsyncSnapshot snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          var list = snapshot.data[index];
          //String correoId = list['correo'];
          return Card(
            // shadowColor: Colors.white,
            //elevation: 10.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SizedBox(height: 10.0),
                ListTile(
                  title: Text(list.tipo),
                  subtitle: Column(children: [
                    Text(list.nombre),
                    Text(list.grupo),
                  ]),
                ),
                SizedBox(height: 10.0),
                _widgetResultado(list.idRegistro, list.tipo)
              ],
            ),
          );
        });
  }

  Widget _widgetResultado(var idRegistro, var tipo) {
    return registro == 'registrado'
        ? Text('asistencia confirmada')
        : ElevatedButton(
            onPressed: () => {asistencia(idRegistro, tipo), showToast()},
            child: Text('Confirmar Asistencia'),
          );
  }

  showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Registrado"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

    // Custom Toast Position
    /* fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 16.0,
            left: 16.0,
          );
        });*/
  }
}
