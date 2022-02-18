import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

// ignore: camel_case_types
class listaGrupos {
  Map<String, dynamic> grupos;
  listaGrupos(this.grupos);
}

// ignore: camel_case_types
class grupo {
  String gp;
  grupo(this.gp);
}

class Grupo extends StatefulWidget {
  Grupo({Key? key}) : super(key: key);

  @override
  _GrupoState createState() => _GrupoState();
}

class _GrupoState extends State<Grupo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
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
            PageView(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Pagina(),
                )
              ],
            )
          ],
        ),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: "Agregar",
        elevation: 0,
        hoverColor: Colors.white30,
        heroTag: "btn1",
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class Pagina extends StatefulWidget {
  @override
  _PaginaState createState() => _PaginaState();
}

class _PaginaState extends State<Pagina> {
  Future obtenerGrupos() async {
    listaGrupos listaGrupo;
    Map<String, dynamic> listaDeGrupos;
    //List<grupo> grupos = [];
    var url = Uri.parse(
        "https://unaindustriamillonaria.com/archivos_php/registros/buscar_registros_por_grupo.php");

    try {
      final response = await http.post(url);
      var datauser = json.decode(response.body);
      listaDeGrupos = datauser;
      for (var i in datauser) {}
      print(datauser);
    } catch (e) {
      print('error: $e');
    }
    //return listaGrupo;
  }

  @override
  void initState() {
    super.initState();
    obtenerGrupos();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(),
    );
  }
}
