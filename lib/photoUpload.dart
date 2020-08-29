import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grass_app/homePage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';

class PhotoUpload extends StatefulWidget {
  PhotoUpload({Key key}) : super(key: key);

  @override
  _PhotoUploadState createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  File sampleImage;
  String _myValue;
  String url;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subida de Fotos"),
        centerTitle: true,
      ),
      body: Center(
        child:
            sampleImage == null ? Text("Seleccione una foto") : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: "Agregue una foto",
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  Widget enableUpload() {
    return SingleChildScrollView(
      child: Container(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: formKey,
            child: Column(
              children: [
                Image.file(
                  sampleImage,
                  height: 300.0,
                  width: 600.0,
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Descripcion"),
                  validator: (value) {
                    return value.isEmpty ? "La descripcion es requerida" : null;
                  },
                  onSaved: (value) {
                    return _myValue = value;
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                RaisedButton(
                  onPressed: uploadStatusImage,
                  child: Text("Agregar foto"),
                  elevation: 10.0,
                  color: Colors.grey,
                  textColor: Colors.white,
                )
              ],
            )),
      )),
    );
  }

  void uploadStatusImage() async {
    if (validateAndSave()) {
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child("Post images");
      var timekey = DateTime.now();
      final StorageUploadTask uploadTask =
          postImageRef.child(timekey.toString() + ".jpg").putFile(sampleImage);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = imageUrl.toString();
      print("Imagen: " + url);
      saveToDatabase(url);
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    }
  }

  void saveToDatabase(String url) {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data = {
      "image": url,
      "description": _myValue,
      "date": date,
      "time": time
    };

    ref.child("Posts").push().set(data);
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
