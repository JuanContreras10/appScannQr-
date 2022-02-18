//import 'package:fic/src/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2500),
        () => Navigator.pushReplacementNamed(context, 'login'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[_crearFondo(), _spash(context)],
    ));
  }

  Widget _spash(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          Center(
            child: Container(
              width: 250.0,
              child: Image.asset('assets/fgg.png'),
            ),
          ),
          Spacer(),
          CircularProgressIndicator(),
          Spacer(),
          Text('Bienvenido')
        ],
      ),
    );
  }

  Widget _crearFondo() {
    final fondo = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/fondo.jpg"), fit: BoxFit.cover),
      ),
    );
    return Stack(
      children: <Widget>[
        fondo,
      ],
    );
  }
}
