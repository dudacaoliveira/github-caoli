
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;
import 'package:sqflite/sqflite.dart';

import 'ConexaoBd.dart';
import 'Criptografia.dart';
import 'Urls.dart';


class TelaComprovantes extends StatefulWidget {
  @override
  _TelaComprovantesState createState() => _TelaComprovantesState();
}

class _TelaComprovantesState extends State<TelaComprovantes> {
  TextEditingController _textEditingControllerNf = new TextEditingController();
  TextEditingController _textEditingControllerCaixa = new TextEditingController();
  TextEditingController _textEditingControllerEnv = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final focus = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  File _image;
  final picker = ImagePicker();
  String status = '';
  String _id_Usuario = Get.parameters['id'];
  String _nome = Get.parameters['nome'];


  bool verificaFormatoCamera(PickedFile pickedFile){
    bool retorno = true;
    print("----------------");
    print(pickedFile.path.length);
    print(pickedFile.path.substring(130));
    String verificajpg = pickedFile.path.substring(130);
    if(pickedFile.path.contains('.jpg')){
      print("Certo! = " + verificajpg);
    }else{
      print("Erro! = " + verificajpg);
      retorno = false;
    }
    print("----------------" + retorno.toString());
    return retorno;
  }

  bool verificaFormatoGaleria(PickedFile pickedFile){
    bool retorno = true;
    print("----------------");
    print(pickedFile.path);
    print(pickedFile.path.length);
    print(pickedFile.path.substring(105));
    String verificajpg = pickedFile.path.substring(105);
    if(pickedFile.path.contains('.jpg')){
      print("Certo! = " + verificajpg);
    }else{
      print("Erro! = " + verificajpg);
      retorno = false;
    }
    print("----------------" + retorno.toString());
    return retorno;
  }


  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  Future getImageGalery() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        maxHeight: 1024,
        maxWidth: 768,
        imageQuality: 80);

   if(verificaFormatoGaleria(pickedFile)){
     setState(() {
       _image = new File(pickedFile.path);
     });
   }
    setStatus('');
  }

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera,
        maxHeight: 1024,
        maxWidth: 768,
        imageQuality: 80);
    if(verificaFormatoCamera(pickedFile)){
      setState(() {
        _image = new File(pickedFile.path);
      });
    }
    setStatus('');
  }

  void limpaCampos() {
    setState(() {
      _image = null; //aqui eu mudo o estado da foto para null depois que foi enviada
      _textEditingControllerCaixa.clear();
      _textEditingControllerEnv.clear();
      _textEditingControllerNf.clear();
    });
  }

  _showBottomSheetEnviada() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Enviada com sucesso",
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                  Text(
                    "Deseja enviar outro Canhoto?",
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CupertinoButton(
                        //color: Colors.red,
                        child: Text(
                          "Não",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        onPressed: () {
                          limpaCampos();
                          Navigator.pop(context);
                          Get.offAllNamed(
                              "/index?device=phone&id=${_id_Usuario} &nome=${_nome}");

                        },
                      ),
                      CupertinoButton(
                        //color: Colors.green,
                        child: Text("Sim",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          limpaCampos();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
          );
        });
  }

  _showEnviando(){
    Get.snackbar("Aguarde!", "ENVIANDO...!",
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.greenAccent,
        backgroundColor: Colors.black,
        overlayColor: Colors.orange,
        duration: Duration(milliseconds: 5000)
    );
  }

  enviaparametro(String _corpo_json) async {
    //ENVIA TEXTO CRIPTOGRAFADO E DESCRIPTOGRAFA RETORNO
    String url = Urls.url;
    String url2 = "https://discomed.mlsistemas.com/ws.php";
    final http.Response response = await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
    }, body: {
      'corpo': criptografa(_corpo_json)
    });
    print("Corpo do JSON from envia parametro" + _corpo_json);
    print(
        "Corpo do JSON enviado para webservice from envia parametro @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!!!!!" +
            criptografa(_corpo_json));
    String a = decrip(response.body).substring(3);
    String h = decrip(response.body);
    print(h);
    print("Variável a from enviaparâmetro" + a.toString());
    if (decrip(response.body).substring(0, 3) == '01.') {
      Map<String, dynamic> retorno =
      json.decode(decrip(response.body).substring(3));
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      String id = retorno["idUsuario"];
      //mapeia para saber o conteúdo da ms e printar "+b"
      Get.snackbar("Falha", "Mensagem não enviada! Verifique Com a TI... ",
          backgroundColor: Colors.red,colorText: Colors.white,snackPosition: SnackPosition.BOTTOM );
      return "Erro no enviaparametro: " + b;
    } else {
      return decrip(response.body).substring(3);
    }
  }

  Future<String> _enviaComprovante() async {
    //String getVal = _textEditingControllerValor.text;
    //String getObs = _textEditingControllerObs.text;
    String imagem;
    if(_image!=null){
      imagem = base64Encode(_image.readAsBytesSync());//
    }
    //teste utf8 obsevação

    String _corpo_json = jsonEncode(<String, dynamic>{
      "modulo": "c2FsdmFyQ29tcHJvdmFudGU=",
      "id" : _id_Usuario,
      "numeroNf": _textEditingControllerNf.text,
      "numeroCaixa": _textEditingControllerCaixa.text,
      "numeroEnvelope": _textEditingControllerEnv.text,
      "image": imagem,
    });
    //Conexao con = new Conexao(); //Instacia objeto "con"
    //Database db = await con.recuperarBanco(); // objeto "con" abre a conexão
    //con.salvarDespesa(int.parse(_dataTipo), int.parse(_dataCodMunicipio), _vardata, 4002587841,getVal,_textEditingControllerObs.text, db);
    print("Print do numeroNf dentro do Create Tela Comprovantes " + _textEditingControllerNf.text);
    print("Print da Envelope dentro do Create Tela DeComprovantesspesa " + _textEditingControllerEnv.text);
    //print(_corpo_json);
    //envia corpo json webservice
    String a = await enviaparametro(_corpo_json);

    if (a.substring(0, 1) == "E") {
      print("-------------Erro de envio--------------" + decrip(a).toString());
    } else {
      //if testa se deu algum erro no envio se não tratar para decodificar json
      Map<String, dynamic> retornoDespesa = json.decode(a);
      String c = retornoDespesa["status"].toString();
      String retornoCreate = a;
      print(
          "**********Else do método _enviaDespesa *********** " + a.toString());
      print("Mensagem de Status da despesa venciada " + c.toString());
      if (c.toString() == 'true') {
        //CircularProgressIndicator(value: 20,);
        await _showBottomSheetEnviada();
        //_imprimeDadosEnviados();
      } else {
        print("Erro entrou no else do envia despesas!!!!");
        Get.snackbar("Falha", "Mensagem não enviada! Verifique data, imagem etc.",
            backgroundColor: Colors.red);
      }
      // _showDialogDespesaEnviada();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){FocusScope.of(context).unfocus();},//fecha o teclado no toque da tela
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            //onPressed: (){Get.toNamed("/index?device=phone&id=${_id} &nome=${_nome}");},
            onPressed: (){
              FocusScope.of(context).unfocus();
              Navigator.pop(context);},

          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right:16),
              child: GestureDetector(child: Icon(Icons.search,color: Colors.white,),onTap: (){Get.toNamed("/telaListaComnprov?device=phone&visualizada=sim&id=${_id_Usuario}&nome=${_nome}");},),
            ),
          ],
          title: Text("Comprovantes Recepção",style: TextStyle(color: Colors.white),),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [

              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
                      child: TextFormField(
                        onTap: () {

                        },
                        autofocus: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: _textEditingControllerNf,
                        cursorColor: Colors.black45,
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                        //autofocus: true,
                        onFieldSubmitted: (v){
                          FocusScope.of(context).requestFocus(focus);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nº NF',
                          hintText: 'Digite o número da NF',
                        ),
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
                        onTap: () async {
                          //chama o BottomSheet tipos
                        },
                        autofocus: false,
                        textInputAction: TextInputAction.next,
                        focusNode: focus,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (v){
                          FocusScope.of(context).requestFocus(focus2);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Campo Obrigatório';
                          }
                          return null;
                        },
                        controller: _textEditingControllerCaixa,
                        cursorColor: Colors.black45,
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nº Caixa',
                          hintText: 'Digite o número da Caixa',
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
                      child: TextFormField(
                        autofocus: false,
                        textInputAction: TextInputAction.done,
                        focusNode: focus2,
                        controller: _textEditingControllerEnv,
                        //inputFormatters: [maskTextInputFormatter],
                        cursorColor: Colors.black45,
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                        decoration: InputDecoration(
                          //icon: Icon(Icons.monetization_on,color: Colors.black26,size: 20,),
                          border: OutlineInputBorder(),
                          labelText: 'Nº Envelope',
                          hintText: "Digite o número do Envelope",
                        ),
                        keyboardType: TextInputType.number,
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
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                //color: Colors.amberAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(1),
                      child: IconButton(
                          icon: Icon(
                            Icons.photo,
                            size: 50,
                            color: Colors.lightBlueAccent,
                          ),
                          onPressed: (){
                            setState(() {
                             // _corDivider = Colors.grey;
                              //_expessuraDivider = 0;
                            });
                            getImageGalery();
                          }
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1),
                      child: IconButton(
                          icon: Icon(
                            Icons.photo_camera,
                            size: 50,
                            color: Colors.lightBlueAccent,
                          ),
                          onPressed:(){
                            setState(() {
                             // _corDivider = Colors.grey;
                             // _expessuraDivider = 0;
                            });
                            getImageCamera();
                          }
                      ),
                    )
                  ],
                ),
              ),
              Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Center(
                      child: _image == null
                          ? Padding(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          'Selecione uma imagem.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                          : Padding(
                        padding: EdgeInsets.all(10),
                        child: Image.file(
                          _image,
                          //height: 280,
                          fit: BoxFit.fill,
                        ),
                      )),
                ],
              ),
              //---------------------------------------------------------------------------
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          //backgroundColor: Colors.green,
          onPressed: () {
              if (_formKey.currentState.validate()) {
                //_imprimeDadosEnviados();
                Center(child: CircularProgressIndicator());
                /*Get.snackbar("", "ENVIANDO...!",
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    isDismissible: true,
                    dismissDirection: SnackDismissDirection.HORIZONTAL,
                    showProgressIndicator: true,
                    progressIndicatorBackgroundColor: Colors.greenAccent,
                    backgroundColor: Colors.black,
                    overlayColor: Colors.orange,
                    duration: Duration(milliseconds: 3000)
                );*/
                //validador();
                if(_image != null){
                  _showEnviando();
                  _enviaComprovante();
                }else{
                  Get.defaultDialog(title:"Atenção",middleText: "Insira uma imagem!");
                }

              }
            },
          //tooltip: 'Pick Image',
          child: Icon(Icons.send,color: Colors.white),
        ),
      ),
    );
  }
}
