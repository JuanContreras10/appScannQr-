import 'package:flutter/material.dart';
import 'package:fragos_greend_gold_codeqr/screens/buscarInvitado.dart';
import 'package:fragos_greend_gold_codeqr/screens/invitados.dart';
import 'package:fragos_greend_gold_codeqr/screens/panelCentral.dart';
import 'package:fragos_greend_gold_codeqr/screens/registro.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'login': (BuildContext context) => PanelCentral(),
    'invitados': (BuildContext context) => Invitados(),
    'buscador': (BuildContext context) => BuscadorInv(),
    'registro': (BuildContext context) => Registro(),
  };
}
