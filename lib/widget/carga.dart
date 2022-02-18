import 'package:flutter/material.dart';

class Carga extends StatelessWidget {
  const Carga({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Spacer(),
          CircularProgressIndicator(),
          Spacer(),
        ],
      ),
    );
  }
}
