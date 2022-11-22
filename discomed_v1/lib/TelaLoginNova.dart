import 'dart:convert';
import 'package:discomedv1/Urls.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'ConexaoBd.dart';
import 'Criptografia.dart';
import 'IndexOLD.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller extends GetxController{
  TextEditingController _textEditingController_usuario = new TextEditingController();
  TextEditingController _textEditingController_senha = new TextEditingController();
  var count = 0.obs;
  String id_Usuario = "";
  var usuarioController = 'Duda'.obs;
  static Controller get to => Get.find();

}

_showSnackbar(){
  Get.snackbar(
      "Atenção!", // title
      "Mensagem ao usuário", // message
      icon: Icon(Icons.alarm),
      shouldIconPulse: true,
      barBlur: 20,
      isDismissible: true,
      duration: Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM
  );
}

_showDialogInvalidos(){
  Get.defaultDialog(
    //onConfirm: () => Get.to(Other()),
    onCancel: () => print("Cancelado"),
    buttonColor: Colors.blue,
    title: "Ei",
    //textConfirm: "Confirma?",
    confirmTextColor: Colors.white,
    middleText: "Dados inválidos",
    textCancel: "Ok",
  );
}
class TelaLoginNova extends StatefulWidget {
  @override
  _TelaLoginNovaState createState() => _TelaLoginNovaState();
}

class _TelaLoginNovaState extends State<TelaLoginNova> {
  final Controller c = Get.put(Controller());
  //static TextEditingController _textEditingController_usuario = new TextEditingController();
  //static TextEditingController _textEditingController_senha = new TextEditingController();
  //static var senha64 = utf8.encode(_textEditingController_senha.text); era assim
  //static var senha64 = utf8.encode(c._textEditingController_senha.text);
  //var _senha_base64 = base64Encode(senha64);//codifica para base64
  //static var email64 = utf8.encode(c._textEditingController_usuario.text);
  //var _email_base64 = base64Encode(email64);//codifica para base64

  //String id_Usuario = "";//variável para pegar o id na resposta em json e
  String msg_servidor = "";
  String _status_servidor = "";
  String _logado = "";
  bool passwordVisible = false;

  void funcao(){
    print(c._textEditingController_senha.text);
    if(c._textEditingController_senha.text == '123456'){
      Get.snackbar("ok", "Senha correta!");
      Get.offAll(Index());
    }else{
      Get.snackbar("Errou", "Senha incorreta!");
    }
  }
  //------------------------Response--------------------------------------------

  EnviaParametro(String _corpo_json) async {
    //ENVIA TEXTO CRIPTOGRAFADO E DESCRIPTOGRAFA RETORNO
    String url = Urls.url;
    String url2 = "https://discomed.mlsistemas.com/ws.php";
    final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
        },
        body: {
          'corpo': criptografa(_corpo_json)
        }
    );

    if(decrip(response.body).substring(0,3)== '01.') {
      Map<String ,dynamic> retorno = json.decode(decrip(response.body).substring(3));
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      String id = retorno["idUsuario"];
      //mapeia para saber o conteúdo da ms e printar "+b"
      return "Erro: "+b;
    }
    else {
      return  decrip(response.body).substring(3);
    }

  }

  Future <String> logar() async{

    String recebe = _status_servidor;
    //final Controller c1 = Get.put(Controller());
    String id_Logar = "";
    String _corpo_json = jsonEncode(<String, String>{
      'modulo':"bG9nYXJVc3Vhcmlv",
      "usuario":"${c._textEditingController_usuario.text}",
      "senha":"${c._textEditingController_senha.text}",
    });

    //envia corpo json webservice
    String a = await EnviaParametro(_corpo_json);

    if (a.substring(0,1) == "E") {
      print (a);
    }
    else  {
      //tratar para decodificar json
      // print (a);

      Map<String ,dynamic> retorno = json.decode(a);
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      String id = retorno["idUsuario"];
      String vist = retorno["vistoria_permissao"];
      print("|||||||||||||||||||||||||||||||| ${c} , ${b}, ${id} vistoria permissão = ${vist}");
      _status_servidor = c;
      id_Logar = id;
      Controller.to.id_Usuario = id;
      //id_Usuario = id;
      //c1.id_Usuario = id;//recebe o id da resposta e manda pra controller
      //c1.usuarioController = "${Controller.to._textEditingController_usuario.text}";// aqui eu recebo a variável do textEditin dentro do usuario controller
    }
    if(_status_servidor == "true") {

      Conexao conL =  new Conexao();//Instacia objeto "con"
      Database dbL = await conL.recuperarBanco();// objeto "con" abre a conexão
      conL.salvarUsuario(id_Logar,c._textEditingController_usuario.text, "sim", dbL);// se Logar grava no banco o usuário logado
      //c.usuarioController = c._textEditingController_usuario.text as RxString;
      FocusScope.of(context).unfocus();
      Get.offAllNamed("/index?device=phone&id=${id_Logar}&nome="+"${c._textEditingController_usuario.text}");
      c._textEditingController_usuario.clear();
      c._textEditingController_senha.clear();
    }else{
      _showDialogInvalidos();
    }
    //print("Aquiiiiiiiiiiiiiiiiiiiiiiiiii${c._textEditingController_usuario.text}" );
    print(" Print dentro do create TelaLoginNova, Usuario Logado ${c._textEditingController_usuario.text}" );

  }//fim do logar



  @override
  void initState() {
    super.initState();
  }

  final focus = FocusNode();
  
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
                      Text("Despesas Discomed",style: TextStyle(color: Colors.white),),
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 5,
                        ),
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

                          child: TextFormField(
                            autofocus: true,
                            autocorrect: true,
                            controller: c._textEditingController_usuario,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration.collapsed(
                              //icon: Icon(Icons.email,color: Colors.black26,size: 20,),
                                hintText: ("Usuário")
                            ),
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focus);
                            },
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
                            focusNode: focus,
                            obscureText: !passwordVisible,
                            controller: c._textEditingController_senha,
                            autofocus: true,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Muda o ícone de acor do com o valor boleano da variável passwordVisible
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              hintText: ("Senha"),

                            ),
                            onTap: (){
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                              //funcao();
                            },

                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Get.snackbar("Aenção!", "Contate a TI da Empresa",snackPosition: SnackPosition.BOTTOM);
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
                        //Spacer(),
                        /*Padding(padding: EdgeInsets.all(5),
                       child:  Text(
                         //"id usuário: ${id_Usuario}",
                         "",
                         style: TextStyle(
                             fontSize: 20,
                             color: Colors.green
                         ),
                       ),
                       ),*/
                        Container(
                          height: 10,
                        ),
                        Visibility(
                          visible: c._textEditingController_senha.text.isNotEmpty & c._textEditingController_usuario.text.isNotEmpty,
                          child: GestureDetector(
                            onTap: (){
                              logar();
                              //print("Sim");
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
                        ),

                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }
}



