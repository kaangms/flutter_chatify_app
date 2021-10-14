import 'package:flutter/material.dart';
import 'package:flutter_chatify_app/app/ornek2.dart';

class Ornek1 extends StatelessWidget {
  const Ornek1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Örnek Sayfa 1"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context,
                        rootNavigator:
                            true) //navinin gideceği sayfayı bottom gizler
                    .push(MaterialPageRoute(
                        builder: (context) => Ornek2(),
                        fullscreenDialog: true));
              },
              icon: Icon(Icons.adb))
        ],
      ),
      body: Center(
        child: Text("Ornek sayfa 1"),
      ),
    );
  }
}
