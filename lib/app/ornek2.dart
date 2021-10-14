import 'package:flutter/material.dart';

class Ornek2 extends StatelessWidget {
  const Ornek2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Örnek Sayfa 2"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.adb))],
      ),
      body: Center(
        child: Text("Ornek sayfa 2"),
      ),
    );
  }
}
