import 'package:flutter/material.dart';
import 'package:fragos_greend_gold_codeqr/widget/carga.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class Invitado {
  var nombre;
  var ocupacion;
  var tipo;
  var idRegistro;

  Invitado(this.nombre, this.ocupacion, this.tipo, this.idRegistro);
}

class Invitados extends StatefulWidget {
  Invitados({Key? key}) : super(key: key);

  @override
  _InvitadosState createState() => _InvitadosState();
}

class _InvitadosState extends State<Invitados> {
  var total = 0;
  var totalAsistenacias = '0';

  ScrollController _scrollController = ScrollController();

  Future<List<Invitado>> obtenerInvitados() async {
    List<Invitado> listaInvtados = [];
    var url = Uri.parse(
        "https://unaindustriamillonaria.com/archivos_php/registros/buscar_registros.php");

    try {
      final response = await http.post(url);
      var datauser = json.decode(response.body);
      for (var i in datauser) {
        Invitado inv = Invitado(
          i['nombre'],
          i['ocupacion'],
          i['respuesta'],
          i['idRegistro'],
        );
        listaInvtados.add(inv);
      }
      setState(() {
        total = listaInvtados.length;
      });
      //print(total);
      //totalAsistencia();
    } catch (e) {
      print('error: $e');
    }
    return listaInvtados;
  }

  Future totalAsistencia() async {
    var url = Uri.parse(
        "https://api.mapbox.com/geocoding/v5/mapbox.places/-73.989,40.733.json?access_token=pk.eyJ1IjoianVhbnNoaW4iLCJhIjoiY2t3b2RnM2s1MDF1ZDJ3bno5dmlyYzRscCJ9.DsR5N7rX3oWZiqKlQznGwA");

    try {
      final response = await http.post(url);
      var datauser = json.decode(response.body);

      for (var i in datauser) {
        setState(() {
          totalAsistenacias = i['total'];
        });
      }
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    totalAsistencia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invitados', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        //iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondo.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total de invitados: ' + total.toString()),
                SizedBox(width: 10.0),
                Text('Asistencia: ' + totalAsistenacias.toString()),
              ],
            ),
            FutureBuilder(
              future: obtenerInvitados(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Carga(),
                    ),
                  );
                } else {
                  int index = 0;
                  return Stack(children: [
                    crearLista(context, index, snapshot),
                    //_crearLoading()
                  ]);
                  //Text('data_$index _' + snapshot.data[index].idcontrato);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget crearLista(BuildContext context, int index, AsyncSnapshot snapshot) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: total,
      itemBuilder: (BuildContext context, index) {
        return crearCardList(snapshot, index, context, total);
      },
    );
  }

  Widget crearCardList(
      AsyncSnapshot snapshot, int index, BuildContext context, int total) {
    var indice = snapshot.data[index];
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        //shadowColor: Colors.white,
        elevation: 10.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            SizedBox(height: 10.0),
            ListTile(
              title: Text('Invitado: ' + indice.nombre),
              subtitle: Column(
                children: [
                  Text('Ocupacion: ' + indice.ocupacion),
                  Text('Tipo: ' + indice.tipo),
                ],
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
