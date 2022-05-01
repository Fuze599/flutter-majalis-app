import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:majalis_app/domain/Client.dart';
import 'package:majalis_app/pages/ConnectPage.dart';
import 'package:majalis_app/pages/HomePage.dart';


void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Majalis administration';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _token = 'RIP';


  @override
  Widget build(BuildContext context) {
    print(_token);
    return MaterialApp(
      title: MyApp._title,
      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),
      //home: screen,
      initialRoute: '/',
      routes: {
        '/': (context) => ConnectPage(MyApp._title, _connect),
        '/homepage': (context) => HomePage(MyApp._title, _disconnect, _getUserByNumber, _getUserBySearch, _insertCardLine, _addNewClient),
      },
    );
  }

  Future<String> _connect(String email, String password) async {
      var response = await http.post(
        Uri.parse('https://majalis-back.herokuapp.com/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        String token = response.body.toString();
        setState(() {
          _token = token;
        });
        return token;
      } else {
        throw Exception("Failed to load the user! \nStatus code : ${response.statusCode}");
      }
  }

  Future<bool> _addNewClient(String email, String nom, String prenom, String numeroTel) async {
    var response = await http.post(
      Uri.parse('https://majalis-back.herokuapp.com/clients/insert'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": _token.replaceAll("\"", "")
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'nom': nom,
        'prenom': prenom,
        'numero_tel': numeroTel,
      }),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> _insertCardLine(String idUser, String montant) async {
    var response = await http.post(
      Uri.parse('https://majalis-back.herokuapp.com/clients/insertline'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": _token.replaceAll("\"", "")
      },
      body: jsonEncode(<String, String>{
        'idUser': idUser,
        'montant': montant,
      }),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to load the client! \nStatus code : ${response.statusCode}");
    }
  }

  Future<int> _getUserByNumber(String numeroTel) async {
    var response = await http.get(
      Uri.parse('https://majalis-back.herokuapp.com/clients/number/' + numeroTel),
      headers: {
        "Authorization": _token.replaceAll("\"", "")
      }
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)[0]["id_client"];
    } else {
      throw Exception("Failed to load the client! \nStatus code : ${response.statusCode}");
    }
  }

  List<Client> parseClient(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return parsed.map<Client>((json) => Client.fromJson(json)).toList();
  }

  Future<List<Client>> _getUserBySearch(String search) async {
    var response = await http.get(
        Uri.parse('https://majalis-back.herokuapp.com/clients/search?search=' + search),
        headers: {
          "Authorization": _token.replaceAll("\"", "")
        }
    );
    if (response.statusCode == 200) {
      return compute(parseClient, response.body);
    } else {
      throw Exception("Failed to load the client! \nStatus code : ${response.statusCode}");
    }
  }

  void _disconnect() {
    setState(() {
      _token = "RIP";
    });
  }
}

