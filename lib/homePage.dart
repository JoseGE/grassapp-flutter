import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'Posts.dart';
import 'photoUpload.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postList = [];

  @override
  void initState() {
    super.initState();
    DatabaseReference postsRef =
        FirebaseDatabase.instance.reference().child("Posts");
    postsRef.once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;

      postList.clear();
      for (var k in keys) {
        Posts post = Posts(data[k]['image'], data[k]['description'],
            data[k]['date'], data[k]['time']);
        postList.add(post);
      }

      setState(() {
        print("Length: $postList.length");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inicio")),
      body: Container(
        child: postList.length == 0
            ? Center(child: Text("No hay na'"))
            : ListView.builder(
                itemCount: postList.length,
                itemBuilder: (_, index) {
                  return postUI(
                    postList[index].image,
                    postList[index].description,
                    postList[index].date,
                    postList[index].time,
                  );
                }),
      ),
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

  Widget postUI(String image, String description, String date, String time) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(14.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Image.network(
              image,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
