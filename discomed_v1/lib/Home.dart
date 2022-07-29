import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File _imagem;


/*  _post()async{
    String _url =  "http://discomed.com.br/webService/";
    http.Response response = await http.post(
      _url,
      headers: {
        "Content-type":"application/json;"
      },
      body: _imagem
    );
    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");
  }*/

  Future _postImg()async{
    String _url =  "http://discomed.com.br/webService/";
    String url2 = "https://discomed.mlsistemas.com/ws.php";
    http.Response response = await http.post(
        url2,
        headers: {
          "Content-type":"application/img;"
        },
        body: null
    );
    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");
  }
  //---------------------------------------------------

  //String _urlBase = "http://discomed.com.br/webService/";

  Future _recuperarImagem(bool daCamera)async{

    File imagemSelecionada;

    if(daCamera){
      imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera,
          maxHeight: 1024,
          maxWidth: 768,
          imageQuality: 80);
    }else{
      imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery,
          maxHeight: 1024,
          maxWidth: 768,
          imageQuality: 80);
    }
    setState(() {
      _imagem = imagemSelecionada;
      //file = imagemSelecionada;
    });
  }

  Future <String> _future;

  Future<String> create() async {
    String url = "http://discomed.com.br/webService/";
    String url2 = "https://discomed.mlsistemas.com/ws.php";
    final http.Response response = await http.post(
      url2,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': "Blabla",
      }),
    );
  }
  //----------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Selcione uma imagem"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              /*RaisedButton(
              color: Colors.orange,
              child: Text("Camera"),
              onPressed: (){
                _recuperarImagem(true);
              },
            ),*/
              Padding(padding: EdgeInsets.all(10),
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    "Galeria",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  onPressed: (){
                    _recuperarImagem(false);
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: FloatingActionButton(
                    child: Icon(Icons.add_a_photo),
                    backgroundColor: Colors.pinkAccent,
                    onPressed: (){
                      _recuperarImagem(true);
                    }
                ),
              ),
              _imagem == null
                  ? Container()
                  : Image.file(_imagem,
                height: 350,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      "Up Load Imagem",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: (){
                      setState(() {
                        _future = _postImg();
                      });
                    }
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: (){
                      setState(() {
                        _future = create();
                      });
                    }

                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      "Novo",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: (){
                      setState(() {
                        _future = create();
                      });
                    }

                ),
              ),

            ],
          ),
        )
    );
  }
}
