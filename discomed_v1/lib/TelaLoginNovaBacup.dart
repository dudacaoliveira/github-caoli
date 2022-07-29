/*
import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;
import 'package:path/path.dart' as p;
import 'dart:async';
import 'dart:io';
import 'Index.dart';


class TelaLoginNova extends StatefulWidget {
  @override
  _TelaLoginNovaState createState() => _TelaLoginNovaState();
}

class _TelaLoginNovaState extends State<TelaLoginNova> {

  static TextEditingController _textEditingController_usuario = new TextEditingController();
  static TextEditingController _textEditingController_senha = new TextEditingController();
  Future <String> _future;

  static var senha64 = utf8.encode(_textEditingController_senha.text);
  var _senha_base64 = base64Encode(senha64);//codifica para base64

  static var email64 = utf8.encode(_textEditingController_senha.text);
  var _email_base64 = base64Encode(email64);//codifica para base64

  String id_Usuario = "";//variável para pegar o id na resposta em json e
  String msg_servidor = "";
  String _status_servidor = "";
  //------------------------Response--------------------------------------------


  _recupera()async{

    String url = "http://discomed.com.br/webService/";
    http.Response response;
    response = await http.get(url);
    print("StatusCode "+response.statusCode.toString());
    print("Resposta "+response.body);
    Map<String ,dynamic> retorno = json.decode(response.body);
    String id = retorno["logradouro"];
    setState(() {
      id_Usuario = ("Logradouro:\n${id}");
    });
    print("Reposta ${id_Usuario}");
  }


  //---------------------------------------------------------------------------

  String criptografa(String cryp)  {
    var encodedKey = 'FCAcEA0HBAoRGyALBQIeCAcaDxYWEQQPBxcXHgAFDgY='; //CHAVE EM 256
    var encodedIv = 'DB4gHxkcBQkKCxoRGBkaFA=='; //VETOR INICIALIZAÇÃO
    final Chave = enc.Key.fromBase64(encodedKey); //CRIA CHAVE COM BASE NA STRING EM 256
    final Vetor = IV.fromBase64(encodedIv); //CRIA VETOR COM BASE NA STRING VETOR
    final TipoCriptografia = Encrypter(AES(Chave, mode: AESMode.cbc)); //DEFINE TIPO DE CRIPTOGRAFIA
    final TextoCriptografado = TipoCriptografia.encrypt(cryp, iv: Vetor); //GERA TEXTO CRIPTOGRAFADO
    final String retorno = TextoCriptografado.base64;
    print("Aqui aqui ${retorno}");
    return retorno;
  }//func para descriptografar

  String decrip(String cryp) {
    var encodedKey = 'FCAcEA0HBAoRGyALBQIeCAcaDxYWEQQPBxcXHgAFDgY='; //CHAVE EM 256
    var encodedIv = 'DB4gHxkcBQkKCxoRGBkaFA=='; //VETOR INICIALIZAÇÃO
    final Chave = enc.Key.fromBase64(encodedKey); //CRIA CHAVE COM BASE NA STRING EM 256
    final Vetor = IV.fromBase64(encodedIv); //CRIA VETOR COM BASE NA STRING VETOR
    final TipoCriptografia = Encrypter(AES(Chave, mode: AESMode.cbc)); //DEFINE TIPO DE CRIPTOGRAFIA
    final TextoDescriptografado = TipoCriptografia.decrypt64(cryp, iv: Vetor);
    print("resposta na função decrip: ${TextoDescriptografado.toString()}");
    return TextoDescriptografado;
  }//func para dcriptografar

  Future <String> create() async {
    String recebe = _status_servidor;
    String GetUsuario = _textEditingController_usuario.text; //Textoemail PARA DESCRIPTOGRAFAR
    String GetSenha = _textEditingController_senha.text; //Textosenha PARA DESCRIPTOGRAFAR
    var UsuarioCriptografado = criptografa(GetUsuario);//RECEBE O TEXTO DIGITADO E CRIPTOGRAFA
    var SenhaCriptografado = criptografa(GetSenha);//RECEBE O TEXTO DIGITADO E CRIPTOGRAFA
    //ENVIA TEXTO CRIPTOGRAFADO E DESCRIPTOGRAFA RETORNO
    String url = "http://discomed.com.br/webService/";
    final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8',
          "Usuario":"${UsuarioCriptografado.toString()}",
          "Senha":"${SenhaCriptografado.toString()}",
        },
        body: {
          "modulo": "bG9nYXJVc3Vhcmlv"
        }
    );

    String a = decrip(response.body);
    print("-------------------${a}------------------------");//variável que pega o response.body e descriptografa para json

    Map<String ,dynamic> retorno = json.decode(a);
    String id = retorno["idUsuario"];
    String b = retorno["msg"];
    String c = retorno["status"].toString();
    setState(() {
      id_Usuario = ("Id do usuário:\n${id},${b},${c}");
      msg_servidor = (b);
      _status_servidor = (c);
    });//
    print("Variável b = ${b}");
    print("Variável c = ${c}");

    if(_status_servidor == "true") {
      print("Ok2");
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => Index()
      ));
    }
  }//create


  void valida_login(String email, String senha){
    email = "ttt";
    senha = "333";
    if( email == _textEditingController_usuario.text && senha == _textEditingController_senha.text){
      Navigator.push(context,  MaterialPageRoute(
          builder: (context) => Index()
      ));
      print("Dados corretos!");
    }
  }

  String valida2(String stserv){

    if(stserv == "true"){
      Navigator.push(context,  MaterialPageRoute(
          builder: (context) => Index()
      ));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width:MediaQuery.of(context).size.width ,
                  height: MediaQuery.of(context).size.height/2.5,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin:Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors:[
                            Color(0xFF0000FF),
                            Color(0xFF00BFFF)
                          ]
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(90)
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Spacer(),
                      Align(
                          alignment:Alignment.center,
                          child: Icon(Icons.person,size: 90,color: Colors.white,
                          )
                      ),
                      Spacer(),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(padding: EdgeInsets.only(bottom:32,right: 32),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                ),
                Container(
                  width:MediaQuery.of(context).size.width ,
                  height: MediaQuery.of(context).size.height/2,
                  padding: EdgeInsets.only(top: 62),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width/1.2,
                        height: 50,
                        padding:EdgeInsets.only(
                            top: 8,left: 16,right: 16,bottom: 4
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5
                              )
                            ]
                        ),

                        child: TextField(
                          controller: _textEditingController_usuario,
                          decoration: InputDecoration.collapsed(
                            //icon: Icon(Icons.email,color: Colors.black26,size: 20,),
                              hintText: ("Usuário")
                          ),
                        ),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width/1.2,
                        margin: EdgeInsets.only(top: 16),
                        height: 50,
                        padding:EdgeInsets.only(
                            top: 8,left: 16,right: 16,bottom: 4
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5
                              )
                            ]
                        ),

                        child: TextField(
                          controller: _textEditingController_senha,
                          decoration: InputDecoration.collapsed(
                            hintText: ("Senha"),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,  MaterialPageRoute(
                              builder: (context) => Index()
                          ));
                        },
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(padding: EdgeInsets.only(top: 10,right: 32),
                              child: Text(
                                "Esqueci a senha",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey
                                ),
                              ),
                            )
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: (){
                          create();
                          //valida2(_status_servidor);
                        },
                        child: Container(

                          width:MediaQuery.of(context).size.width/1.4,
                          height:50,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors:[
                                Color(0xFF0000FF),
                                Color(0xFF00BFFF)
                              ]
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(50)
                              )
                          ),
                          child:Center(
                            child: Text("Logar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ) ,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5),
                        child:  Text(
                          id_Usuario,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.green
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
*/
