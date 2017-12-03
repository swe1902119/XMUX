import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CalendarPage extends StatefulWidget {

  @override
  _CalendarPageState createState() => new _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  var classes, data;
  String id, password;

  Future<File> _getFile(String name) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/$name');
  }

  Future<Null> _saveFile(String name, String str) async {
    await (await _getFile(name)).writeAsString(str);
  }

  Future<String> _readFile(String name) async {
    return await (await _getFile(name)).readAsString();
  }

  Future<Null> _getClasses() async {
    var response = await http.post("https://xmux.azurewebsites.net/ac",
        body: {
          "id": id,
          "pass": password,
        });
    setState((){
      data = JSON.decode(response.body);
    });
  }

  @override
  void initState() {
    _readFile("login.dat").then((String str){
      Map loginInfo = JSON.decode(str);
      id = loginInfo["id"];
      password = loginInfo["campus"];
    }).then((Null){
      _getClasses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Calendar"),),
      body: new ListView.builder(
          itemCount: data == null ? 0 : data["classes"].length,
          itemBuilder: (_, int index) {
            return new Card(
                child: new Text(data["classes"][index]["class"])
            );
          }
      ),
    );
  }
}