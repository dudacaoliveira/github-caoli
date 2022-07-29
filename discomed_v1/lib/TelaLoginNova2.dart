import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;
import 'package:path/path.dart' as p;
import 'dart:async';
import 'dart:io';
import 'Index.dart';

class Controller extends GetxController{
  TextEditingController _textEditingController_usuario = new TextEditingController();
  TextEditingController _textEditingController_senha = new TextEditingController();
  var count = 0.obs;
  String id_Usuario = " ";
  String usuarioController = " ";
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



_showDialog(){
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

class TelaLoginNova2 extends StatelessWidget {
  static final Controller c = Get.put(Controller());
  //static TextEditingController _textEditingController_usuario = new TextEditingController();
  //static TextEditingController _textEditingController_senha = new TextEditingController();

  //static var senha64 = utf8.encode(_textEditingController_senha.text); era assim
  static var senha64 = utf8.encode(c._textEditingController_senha.text);
  var _senha_base64 = base64Encode(senha64);//codifica para base64

  static var email64 = utf8.encode(c._textEditingController_usuario.text);
  var _email_base64 = base64Encode(email64);//codifica para base64

  //String id_Usuario = "";//variável para pegar o id na resposta em json e
  String msg_servidor = "";
  String _status_servidor = "";
  //------------------------Response--------------------------------------------

  String criptografa(String cryp)  {
    var encodedKey = 'FCAcEA0HBAoRGyALBQIeCAcaDxYWEQQPBxcXHgAFDgY='; //CHAVE EM 256
    var encodedIv = 'DB4gHxkcBQkKCxoRGBkaFA=='; //VETOR INICIALIZAÇÃO
    final Chave = enc.Key.fromBase64(encodedKey); //CRIA CHAVE COM BASE NA STRING EM 256
    final Vetor = IV.fromBase64(encodedIv); //CRIA VETOR COM BASE NA STRING VETOR
    final TipoCriptografia = Encrypter(AES(Chave, mode: AESMode.cbc)); //DEFINE TIPO DE CRIPTOGRAFIA
    final TextoCriptografado = TipoCriptografia.encrypt(cryp, iv: Vetor); //GERA TEXTO CRIPTOGRAFADO
    final String retorno = TextoCriptografado.base64;
    //print("Aqui aqui ${retorno}");
    return retorno;
  }//func para criptografar

  String decrip(String cryp) {
    var encodedKey = 'FCAcEA0HBAoRGyALBQIeCAcaDxYWEQQPBxcXHgAFDgY='; //CHAVE EM 256
    var encodedIv = 'DB4gHxkcBQkKCxoRGBkaFA=='; //VETOR INICIALIZAÇÃO
    final Chave = enc.Key.fromBase64(encodedKey); //CRIA CHAVE COM BASE NA STRING EM 256
    final Vetor = IV.fromBase64(encodedIv); //CRIA VETOR COM BASE NA STRING VETOR
    final TipoCriptografia = Encrypter(AES(Chave, mode: AESMode.cbc)); //DEFINE TIPO DE CRIPTOGRAFIA
    final TextoDescriptografado = TipoCriptografia.decrypt64(cryp, iv: Vetor);
    //print("resposta na função decrip: ${TextoDescriptografado.toString()}");
    return TextoDescriptografado;
  }//func para dcriptografar

  EnviaParametro(String _corpo_json) async {
    //ENVIA TEXTO CRIPTOGRAFADO E DESCRIPTOGRAFA RETORNO
    String url = "http://discomed.com.br/webService/";
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

  Future <String> create() async{
    String recebe = _status_servidor;
    final Controller c1 = Get.put(Controller());

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
      _status_servidor = c;
      //id_Usuario = id;
      c1.id_Usuario = id;//recebe o id da resposta e manda pra controller
      c1.usuarioController = "${Controller.to._textEditingController_usuario.text}";// aqui eu recebo a variável do textEditin dentro do usuario controller
    }

    if(_status_servidor == "true") {
      Get.toNamed("/index");
      //Get.toNamed("/index/$id_Usuario");funcionando
      //Get.toNamed("/index/${c._textEditingController_usuario.text}/$id_Usuario");
      //Get.offAllNamed("/index?device=phone&id=$id_Usuario&name="+"${c._textEditingController_usuario.text}");
      //Get.toNamed("/index", arguments: '$id_Usuario');
    }else{
      _showDialog();
    }
    //print("Aquiiiiiiiiiiiiiiiiiiiiiiiiii${c._textEditingController_usuario.text}" );
    print(" Print dentro do create TelaLoginNova, Usuario Logado ${c1.usuarioController}" );

  }//create


/* void valida_login(String email, String senha){
      email = "ttt";
      senha = "333";
      if( email == _textEditingController_usuario.text && senha == _textEditingController_senha.text){
        Navigator.push(context,  MaterialPageRoute(
            builder: (context) => Index(_textEditingController_usuario.text)
        ));
        print("Dados corretos!");
      }
  }*/


/*String valida2(String stserv){

    if(stserv == "true"){
      Navigator.push(context,  MaterialPageRoute(
          builder: (context) => Index()
      ));
    }
    return null;
  }*/
  @override
  Widget build(context) {

    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width:MediaQuery.of(context).size.width ,
                  height: MediaQuery.of(context).size.height/2,
                  padding: EdgeInsets.only(top: 62),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
                                child: TextFormField(
                                  controller: c._textEditingController_usuario,
                                  //inputFormatters: [maskTextInputFormatter],
                                  cursorColor: Colors.black45,
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                  decoration: InputDecoration(
                                    //icon: Icon(Icons.monetization_on,color: Colors.black26,size: 20,),
                                    border: OutlineInputBorder(),
                                    labelText: 'Usuário',
                                    hintText: "Digite o valor",
                                  ),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Campo Obrigatório';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
                                child: TextFormField(
                                  controller: c._textEditingController_senha,
                                  //inputFormatters: [maskTextInputFormatter],
                                  cursorColor: Colors.black45,
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                  decoration: InputDecoration(
                                    //icon: Icon(Icons.monetization_on,color: Colors.black26,size: 20,),
                                    border: OutlineInputBorder(),
                                    labelText: 'Senha',
                                    hintText: "Digite o valor",
                                  ),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Campo Obrigatório';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            /*gradient: LinearGradient(
                    begin:Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors:[
                        Color(0xFF0000FF),
                        Color(0xFFFFFFFF)
                    ]
                ),*/ //Gradiente de cores
                            //color: Colors.blue,
                              border: Border.all(
                                  width: 1,
                                  color: Colors.blueGrey
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),

                              )
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,  MaterialPageRoute(
                              builder: (context) => TelaLoginNova2()
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

                    ],
                  ),

                ),
                //-----------------------Botão LOGAR
                GestureDetector(
                  onTap: (){
                    create();
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
                  //----------------------Botão LOGAR
                ),
              ],
            ),
          ),
        )
    );
  }
}
