import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

FToast fToast = FToast();

final _formKey = GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

TextEditingController passNue = new TextEditingController();

TextEditingController tel = new TextEditingController();

TextEditingController correo = new TextEditingController();

class Registro extends StatefulWidget {
  Registro({Key? key}) : super(key: key);

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  _reinicioForm() {
    setState(() {
      passNue.text = "";
      tel.text = "";
      correo.text = "";
    });
  }

  Future registro(BuildContext context) async {
    Map cuerpo = {
      "nombre": "${passNue.text}",
      "telefono": "+52${tel.text}",
      "ocupacion": "puesto",
      "correo": "${correo.text}",
      "labor": "empresa",
      "ciudad": "estado",
      "tipo": "Usuario",
    };
    var body = jsonEncode(cuerpo);

    var link =
        ("https://unaindustriamillonaria.com/archivos_php/registros/agregar_registros.php");
    var url = Uri.parse(link);

    try {
      final response = await http.post(url, body: body);
      var datauser = json.decode(response.body);
      if (datauser['status'] == 0) {
        //_reinicioContrato();
        // print('Registro Existoso!');
        showToast(context, Icons.check, Colors.green, "Registrado");
        _reinicioForm();
      } else if (datauser['status'] == 2) {
        // print('numero duplicado!');
        showToast(context, Icons.phone, Colors.red, "numero duplicado!");
      } else if (datauser['status'] == 3) {
        // print('maximo de registros!');
        showToast(context, Icons.error, Colors.yellow, "maximo de registros!");
      } else {
        print('Registro fallido!');
      }
    } catch (e) {
      print("error $e");
    }

    //print('fin proceso contrato..');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Registro', style: TextStyle(color: Colors.white)),
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
        onPressed: () {
          // Add your onPressed code here!

          if (_formKey.currentState!.validate()) {
            registro(context);
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  showToast(BuildContext context, IconData icono, Color color, String text) {
    //print('hola');
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono),
          SizedBox(
            width: 12.0,
          ),
          Text(text),
        ],
      ),
    );

    fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM_LEFT,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            bottom: 100.0,
            left: 125.0,
          );
        });

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

class Pagina extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(children: <Widget>[
          SafeArea(
            child: Container(
              height: 5.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Container(
              margin: const EdgeInsets.all(10.0),
              width: size.width * 0.96,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                        10.0), //                 <--- border radius here
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black,
                      offset: Offset(1, 3),
                    ),
                  ] // Make rounded corner of border

                  ),
              child: formInputs(),
            ),
          ),
        ]),
      ),
    );
  }

  Widget formInputs() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 5.0,
            ),
          ),
          TextField(
            textInputAction: TextInputAction.done,
            controller: passNue,
            obscureText: false,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                icon: Icon(
                  Icons.person_add,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(color: Colors.black)),
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'Nombre'),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.phone,
            controller: tel,
            obscureText: false,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                icon: Icon(
                  Icons.phone,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(color: Colors.black)),
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'Telefono'),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.emailAddress,
            controller: correo,
            obscureText: false,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                icon: Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(color: Colors.black)),
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'Correo'),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
