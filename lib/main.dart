import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



void main() => runApp(MaterialApp(
  home: Draw(),
));

class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  bool clr = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr? Colors.red:Colors.purple,
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text('Layout 1'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context)=>Layout1()
                  )
                );
              },
            ),
            ListTile(
              title: Text('Layout 2'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context)=>Layout2()
                    )
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("My Drawer"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        elevation: 20.0,
      ),
    );
  }
}

class Layout1 extends StatefulWidget {
  const Layout1({Key? key}) : super(key: key);

  @override
  _Layout1State createState() => _Layout1State();
}

class _Layout1State extends State<Layout1> {

  List list = ['abir', 'rony', 'shimul', 'forhad'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pop(context);
        },
        backgroundColor: Colors.grey[900],
        child: Icon(Icons.arrow_back),
      ),
      body: Center(
        child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i){
                  return Card(
                    child: ListTile(
                      onTap: (){},
                      title: Text("${list[i]}"),
                    ),
                  );
                },
              ),
      )
    );
  }
}

List<Album> welcomeFromJson(String str) => List<Album>.from(json.decode(str).map((x) => Album.fromJson(x)));

class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
  };

}

Future<List<Album>> getLateAlbum() async {
  final response =
  await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return welcomeFromJson(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}


class Layout2 extends StatefulWidget {
  const Layout2({Key? key}) : super(key: key);

  @override
  _Layout2State createState() => _Layout2State();
}

class _Layout2State extends State<Layout2> {

  late Future<Album> futureAlbum;
  late Future<List<Album>> lateAlbum;

  @override
  void initState() {
    super.initState();
    lateAlbum = getLateAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pop(context);
          },
          backgroundColor: Colors.grey[900],
          child: Icon(Icons.arrow_back),
        ),
        body: Center(
          child: FutureBuilder<List<Album>>(
            future: lateAlbum,
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {

                return ListView.builder(
                  itemCount: 100,
                  itemBuilder: (context, i){
                    return Card(
                      child: ListTile(
                        onTap: () {},
                        title: Text("${snapshot.data?[i].title}"),
                      ),
                    );
                  }
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),

        )
    );
  }
}
