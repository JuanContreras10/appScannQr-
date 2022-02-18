import 'dart:async';
import 'dart:convert';
import 'dart:ui';
//import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fragos_greend_gold_codeqr/screens/grupos.dart';
import 'package:fragos_greend_gold_codeqr/screens/invitados.dart';
import 'package:fragos_greend_gold_codeqr/screens/registro.dart';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'buscarInvitado.dart';

//import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
FToast fToast = FToast();
var grupo = "sin grupo";

class Invitado {
  var nombre;
  var ocupacion;
  var tipo;
  var idRegistro;
  var grupo;

  Invitado(this.nombre, this.ocupacion, this.tipo, this.idRegistro, this.grupo);
}

class PanelCentral extends StatefulWidget {
  @override
  _PanelCentral createState() => _PanelCentral();
}

class _PanelCentral extends State<PanelCentral> {
  //final _drawerController = ZoomDrawerController();
  // int _index = 0;
  String _scanBarcode = 'Sin Escanear';
  Invitado invitado = Invitado("", "", "", "", "");
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      //  print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      var dataJson = json.decode(barcodeScanRes);
      invitado = new Invitado(dataJson['nombre'], dataJson['ocupacion'],
          dataJson['tipo'], dataJson['id_registro'], dataJson['grupo']);
      busquedaAsistencia(invitado.idRegistro);
      invitadoId();
    });
  }

  Future asistencia(idRegistro, tipo) async {
    var url = Uri.parse(
        "https://unaindustriamillonaria.com/archivos_php/asistencias/agregar_asistencia.php");
    Map cuerpo = {"id": idRegistro, "usuario": tipo};
    var body = jsonEncode(cuerpo);

    try {
      final response = await http.post(url, body: body);
      // ignore: unused_local_variable
      var datauser = json.decode(response.body);
      //showToast();
      setState(() {
        _scanBarcode = 'Sin Escanear';
      });
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
      datauser['status'] == true
          ? setState(() {
              _scanBarcode = 'registrado';
            })
          : print(body);
    } catch (e) {
      print('error: $e');
    }
  }

  // ignore: non_constant_identifier_names
  Future invitadoId() async {
    var url2 = Uri.parse(
        "https://unaindustriamillonaria.com/archivos_php/registros/buscar_registros_id.php");
    Map cuerpo = {'id_registro': invitado.idRegistro};

    var body = jsonEncode(cuerpo);
    try {
      final response = await http.post(url2, body: body);
      var datauser = json.decode(response.body);
      if (datauser.length > 0) {
        //
        var gp = datauser['grupo'];
        setState(() {
          grupo = gp.toString();
          // print(cuerpo);
        });
      }
    } catch (e) {
      print(e);
    }
    //return listaInvtados;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fragos Green Gold QR')),
      body: cuerpo(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            width: 300.0,
            height: 50.0,
            decoration: BoxDecoration(
                color: Colors.black,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.black,
                  tooltip: "invitados",
                  elevation: 0,
                  hoverColor: Colors.white30,
                  heroTag: "btn1",
                  onPressed: () => showBarModalBottomSheet(
                    elevation: 10.0,
                    duration: Duration(milliseconds: 1250),
                    bounce: true,
                    expand: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Invitados(),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10.0),
                FloatingActionButton(
                  heroTag: "btn2",
                  backgroundColor: Colors.black,
                  tooltip: "Buscador",
                  elevation: 0,
                  onPressed: () => showBarModalBottomSheet(
                    elevation: 10.0,
                    duration: Duration(milliseconds: 1250),
                    bounce: true,
                    expand: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => BuscadorInv(),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10.0),
                FloatingActionButton(
                  heroTag: "btn3",
                  backgroundColor: Colors.black,
                  tooltip: "Registros",
                  elevation: 0,
                  onPressed:
                      // Add your onPressed code here!
                      () => showBarModalBottomSheet(
                    elevation: 10.0,
                    duration: Duration(milliseconds: 1250),
                    bounce: true,
                    expand: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Registro(),
                  ),
                  child: const Icon(
                    Icons.app_registration,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10.0),
                FloatingActionButton(
                  heroTag: "btn4",
                  backgroundColor: Colors.black,
                  tooltip: "Grupos",
                  elevation: 0,
                  onPressed:
                      // Add your onPressed code here!
                      () => showBarModalBottomSheet(
                    elevation: 10.0,
                    duration: Duration(milliseconds: 1250),
                    bounce: true,
                    expand: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Grupo(),
                  ),
                  child: const Icon(
                    Icons.group_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    //);
  }

  Widget cuerpo(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green,
              Colors.black,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () => scanQR(),
                    child: Text('Escanear Invitacion')),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0),
                    _scanBarcode == 'Sin Escanear'
                        ? Text("Sin escanear")
                        : Card(
                            shadowColor: Colors.white,
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                SizedBox(height: 10.0),
                                ListTile(
                                  title: Text(invitado.tipo),
                                  subtitle: Column(children: [
                                    Text(invitado.nombre),
                                    grupo == ""
                                        ? Text(" Sin grupo asignado ")
                                        : Text("Grupo: " + grupo),
                                  ]),
                                ),
                                SizedBox(height: 10.0),
                                _widgetResultado(
                                    invitado.idRegistro, invitado.tipo, context)
                              ],
                            ),
                          )
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _widgetResultado(var idRegistro, var tipo, BuildContext context) {
    if (_scanBarcode == 'Sin Escanear') {
      return Container();
    }
    if (_scanBarcode == 'registrado') {
      return ElevatedButton(
        onPressed: () => {
          setState(() {
            _scanBarcode = 'Sin Escanear';
          })
        },
        child: Text('Asistencia Confirmada'),
      );
    } else {
      return ElevatedButton(
        onPressed: () => {showToast(context), asistencia(idRegistro, tipo)},
        child: Text('Confirmar Asistencia'),
      );
    }
  }

  showToast(BuildContext context) {
    //print('hola');
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black,
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
