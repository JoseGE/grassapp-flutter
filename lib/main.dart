import 'package:flutter/material.dart';

import 'homePage.dart';

void main() {
  runApp(GrasApp());
}

class GrasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La GrasApp',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
