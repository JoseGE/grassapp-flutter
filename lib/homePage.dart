import 'package:flutter/material.dart';

import 'photoUpload.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inicio")),
      body: Container(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 40.0,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PhotoUpload();
                  }));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
