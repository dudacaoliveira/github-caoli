import 'package:discomedv1/TelaLoginNova.dart';
import 'package:discomedv1/UsuarioModel.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'ConexaoBd.dart';
import 'IndexOLD.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  {


  List<Usuario> usus = new List();
  Conexao db = new Conexao();


  String _st = "false";

  Future<String> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 3000), () {});
    return "1";
  }

  void _chamaIndex(String id,String nome) {
    //Get.toNamed("/despRecu?device=phone&visualizada=nao");
    Get.offAllNamed("/index?device=phone&id=${id} &nome=${nome}");
    print("------------------método ChamaIndex do splash-------------------");
    print("################ id = ${id} nome = ${nome}#################");
    print("------------------método ChamaIndex do splash-------------------");
  }

  void _chamaLogin() {
    Get.offNamed("/Login");
  }

  @override
  void initState() {
    super.initState();
    String _nome = "";
    String _id = "";
    db.getAllUsuario().then((notes) {
      setState(() {
        notes.forEach((note) {
          usus.add(Usuario.fromMap(note));
          print("----------------Procura usuários no banco na splashScrenn-------------------");
          print("usuários cadastrados = ${usus.length}");
          for(Usuario u in usus){
            print("Nome: " + u.nome + "|" + "ID: " + u.id + "|" + "Status Logado: " + u.status);
          }
        });
      });
      for(var u in usus){
        print("Nome do usuario dentro do initState " + u.nome);
        print("----------------Procura usuários no banco-------------------");
        _nome = u.nome;
        _id = u.id;
      }
    });

    _mockCheckForSession().then(
            (status) {
          if (usus.length <= 0) {
            _chamaLogin();
          } else {
            _chamaIndex(_id,_nome);
            print("Id ${_id} e nome ${_nome} no else do _mockCheck TELA splash_screen");
          }
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:250),
                child: Center(child: Image.asset("img/logo1.png", height: 200,)),
              ),
              Padding(padding: EdgeInsets.only(top: 0,bottom: 200),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 1,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 0),child: Text("FROM DISCOMED",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white70),)),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text("Versão 2.1.0",style: TextStyle(
                    color: Colors.white,
                    fontSize: 10
                ),
                ),
              )
            ],
          ),

        ),
      ),

    );
  }

}


