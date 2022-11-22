import 'dart:convert';
import 'dart:io';

import 'package:discomedv1/ComprovanteModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'ConexaoBd.dart';
import 'Criptografia.dart';
import 'Urls.dart';

class ListaComprovantes extends StatefulWidget {
  @override
  _ListaComprovantesState createState() => _ListaComprovantesState();
}

class _ListaComprovantesState extends State<ListaComprovantes> {
  String _txtLista = "";
  List<Comprovante> filtered = new List();
  List<Comprovante> items = new List();
  List itemsAux = [];
  List listaIdComp = [];
  double fontSize = 15;
  double lblfontSize = 15;
  Color cortxt = Colors.black;
  Color cortxt2 = Colors.black45;
  String _idRegistro = "";
  String _id = Get.parameters['id'];
  String _nome = Get.parameters['nome'];
  bool verifica;
  File _image;
  String imgFull = "";
  TextEditingController _textEditingControllerNf =  new TextEditingController();



  enviaparametro(String _corpo_json) async {
    //ENVIA TEXTO CRIPTOGRAFADO E DESCRIPTOGRAFA RETORNO
    String url = Urls.url;
    final http.Response response = await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
    }, body: {
      'corpo': criptografa(_corpo_json)
    });
    //-------------Teste----------------
    /*print("Corpo do JSON from envia parametro" + _corpo_json);
    print("Corpo do JSON enviado para webservice from envia parametro" + criptografa(_corpo_json));
    print(response.body);*/
    //print("Response body sem decrip do método enviaparametro " + response.body);
    //-------------Teste----------------
    String a = decrip(response.body).substring(3);
    String h = decrip(response.body);
    //-------------Teste----------------
    print("Response do método enviaparametro com substring " + a);
    print("Response do método enviaparametro  " + h);
    //-------------Teste----------------
    if (decrip(response.body).substring(0,3) == '01.') {

      print("Entou!!!!!!!!!!!!!!!!! Erro gerado no enviaparametro");
      Map<String, dynamic> retorno =
      json.decode(decrip(response.body).substring(3));
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      String i = retorno["imagem"];
      //String id = retorno["idUsuario"];
      //mapeia para saber o conteúdo da ms e printar "+b"
      Get.snackbar("Comprovante", "Não Encontrado ",
          backgroundColor: Colors.red,colorText: Colors.white,snackPosition: SnackPosition.BOTTOM );
      return "01. Não encontrado, msg do snac!!!! " + b + c;
    } else {
      Get.snackbar("Buscando", "Comprovante",
          backgroundColor: Colors.green,colorText: Colors.white,snackPosition: SnackPosition.BOTTOM,showProgressIndicator:true,duration: Duration(milliseconds: (200)), );
      print("Else final do enviaParametro");
      return decrip(response.body).substring(0);
    }
  }

  Future<String> _enviaComprovante() async {

    String _corpo_json = jsonEncode(<String, dynamic>{
      "modulo": "YnVzY2FyQ29tcHJvdmFudGVz",
      "id" : _id,
      "numeroNf": _textEditingControllerNf.text,
      //"image": imagem,
    });
    //-------------Teste----------------
    //print("Print do numeroNf dentro do Create Tela Comprovantes " + _textEditingControllerNf.text);
    //print("Corpo json " + _corpo_json);
    //-------------Teste----------------

    //envia corpo json webservice

    String a = await enviaparametro(_corpo_json);
    //Após executar  o método envia parametro executa a partir daqui
    //-------------Teste----------------
    //print("Variável a método _enviacomprovante: " + a);
    //print("Variável a método _enviacomprovante com Substring: " + a.substring(0,3));
    //-------------Teste----------------

    if (a.substring(0, 3) == "01.") {
      //-------------Teste----------------
      print("Entrou no if-------------Comprovante Não encontrado--------------"  + a);
      //-------------Teste----------------
    } else {
      //-------------Teste----------------
      print(
          "********** Else do método _enviaComprovante*********** " + a.substring(3));
      //-------------Teste----------------
      //if testa se deu algum erro no envio, se não tem erro tenta tratar para decodificar json
      
      Map<String, dynamic> retornoDespesa = json.decode(a.substring(3));
      String c = retornoDespesa["status"].toString();
      String d = retornoDespesa["msg"];
      String img = retornoDespesa["imagem"];
      String id = retornoDespesa["id"];
      String caixa = retornoDespesa["caixa"];
      String envelope = retornoDespesa["envelope"];

      imgFull = img;
      print("NF é :" + d);
      print("ID da imagem :" + id);
      print("ID da caixa :" + caixa);
      print("ID da envelope :" + envelope);
      print("ID da imagem :" + id);
      print("Imagem é :" + img.toString());
      Comprovante comprovante = new Comprovante();
      comprovante.id = id;
      comprovante.nf = d;
      comprovante.img = img;
      comprovante.caixa = caixa;
      comprovante.envelope = envelope;


      setState(() {
        if(itemsAux.contains(d)){
          Get.snackbar("Já na lista", "Insira outro",backgroundColor: Colors.deepOrange,colorText: Colors.white );
          _textEditingControllerNf.clear();
        }else{
          items.add(comprovante);
          itemsAux.add(d);
          listaIdComp.add(id);
          _textEditingControllerNf.clear();
        }

      });
      //-------------Teste----------------
      print("Mensagem de Status da despesa venciada = " + c.toString());
      //-------------Teste----------------

    }
  }


  enviaparametroEmail(String _corpo_json) async {
    //ENVIA TEXTO CRIPTOGRAFADO E DESCRIPTOGRAFA RETORNO
    String url = Urls.url;
    final http.Response response = await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
    }, body: {
      'corpo': criptografa(_corpo_json)
    });
    //-------------Teste----------------
    /*print("Corpo do JSON from envia parametro" + _corpo_json);
    print("Corpo do JSON enviado para webservice from envia parametro" + criptografa(_corpo_json));
    print(response.body);*/
    //print("Response body sem decrip do método enviaparametro " + response.body);
    //-------------Teste----------------
    String a = decrip(response.body).substring(3);
    String h = decrip(response.body);
    //-------------Teste----------------
    print("Response do método enviaparametro com substring " + a);
    print("Response do método enviaparametro  " + h);
    //-------------Teste----------------
    if (decrip(response.body).substring(0,3) == '01.') {
      print("Entou!!!!!!!!!!!!!!!!! Erro gerado no enviaparametroEmail");
      Map<String, dynamic> retorno =
      json.decode(decrip(response.body).substring(3));
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      //String id = retorno["idUsuario"];
      //mapeia para saber o conteúdo da ms e printar "+b"
      Get.snackbar("Email", "Não Enviado ",
          backgroundColor: Colors.red,colorText: Colors.white,snackPosition: SnackPosition.BOTTOM );
      return "01. Não encontrado, msg do snac!!!! " + b + c;
    } else {
      Get.snackbar("Email ", "Enviado",
        backgroundColor: Colors.green,colorText: Colors.white,snackPosition: SnackPosition.BOTTOM,showProgressIndicator:true,duration: Duration(milliseconds: (2000)), );
      print("Else final do enviaParametroEmail");
      setState(() {
        filtered = [];
      });
      return decrip(response.body).substring(0);

    }
  }

  Future<String> _enviaEmail() async {

    String _corpo_json = jsonEncode(<String, dynamic>{
      "modulo": "ZW52aWFFbWFpbENvbXByb3ZhbnRlcw==",
      "id" : _id,
      "lista": listaIdComp,
    });
    //-------------Teste----------------
    //print("Print do numeroNf dentro do Create Tela Comprovantes " + _textEditingControllerNf.text);
    print("Corpo json " + _corpo_json);
    //-------------Teste----------------

    //envia corpo json webservice

    String a = await enviaparametroEmail(_corpo_json);
    //Após executar  o método envia parametro executa a partir daqui
    //-------------Teste----------------
    print("Variável a método _enviacomprovante: " + a);
    //print("Variável a método _enviacomprovante com Substring: " + a.substring(0,3));
    //-------------Teste----------------

    if (a.substring(0, 3) == "01.") {
      //-------------Teste----------------
      print("Entrou no if-------------Comprovante Não encontrado--------------"  + a);
      //-------------Teste----------------
    } else {
      //-------------Teste----------------
      print(
          "********** Else do método _enviaEmail*********** " + a.substring(3));
      //-------------Teste----------------
      //if testa se deu algum erro no envio, se não tem erro tenta tratar para decodificar json

      Map<String, dynamic> retornoDespesa = json.decode(a.substring(3));
      String c = retornoDespesa["status"].toString();
      String d = retornoDespesa["msg"];

      print("Status :" + c);
      print("Msg :" + d);

      //-------------Teste----------------
      print("Mensagem de Status da despesa venciada = " + c.toString());
      //-------------Teste----------------

    }
  }


  Widget criaLista(context, index) {
    return  Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 1),
          child: GestureDetector(
            onTap: (){Get.toNamed("/telaVisuImg?device=phone&image=${filtered[index].img}");},
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //Text("Id Reg: " + _tarefas[index]["idRegistro"]),
                    //Text("Data: " + _tarefas[index]["data"]),
                    Center(
                        child: Text(
                          "Encontrado ",
                          style: TextStyle(color: Colors.green,fontSize: 17),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                            child: Text(
                              "Nf: " + filtered[index].nf,
                              style: TextStyle(color: Colors.grey,fontSize: 17),
                            )),
                        Center(
                            child: Text(
                              "Caixa: " + filtered[index].caixa,
                              style: TextStyle(color: Colors.grey,fontSize: 17),
                            )),
                        Center(
                            child: Text(
                              "Envelope: " + filtered[index].envelope,
                              style: TextStyle(color: Colors.grey,fontSize: 17),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    SizedBox(
                      height: 15,
                    )

                    //Divider()
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();

    items = [];
    filtered = items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
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
        title: Text(
          "COMPROVANTES",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: 130,
            color: Colors.blue,
          ),
          Center(child: Text(_txtLista)),
          Padding(
            padding: EdgeInsets.only(left: 20,right: 20),
            child: Row(
              children: [
                Container(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _textEditingControllerNf,
                    decoration: InputDecoration(
                        //icon: Icon(Icons.search),
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Digite a NF para buscar',
                        labelText: 'Pesquisar'
                    ),
                    //onTap: (){_enviaComprovante();},
                  ),
                  width: 300,
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent),elevation:MaterialStateProperty.all(0) ),
                  child: Icon(Icons.search,color: Colors.white,),
                  onPressed: (){

                    FocusScope.of(context).unfocus();//fecha o teclado

                    if(_textEditingControllerNf.text.isNotEmpty){
                      _enviaComprovante();
                    }else{
                      Get.defaultDialog(title: "Campo Vazio!", middleText: "Favor inserir um valor!",onCancel: (){});

                    }
                    },

                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: criaLista
            ),
          ),
          //Text("${_nome} ${_id}",style: TextStyle(fontSize: 35),)
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.blue,
        onPressed: (){
          Get.offAndToNamed("/telaKmRodadoStepper?device=phone&id=${_id} &nome=${_nome}");
        },
      ),*/
      floatingActionButton: FloatingActionButton(
        //backgroundColor: Colors.green,
        onPressed: (){
          //-----------teste---------------
          print(jsonEncode(listaIdComp));
          //-----------teste---------------
          if(listaIdComp.isNotEmpty){
            Get.defaultDialog(
                title: "Enviar email!",
                middleText: "Deseja enviar o email?",
                onConfirm: (){
                  _enviaEmail();
                  Navigator.pop(context);
                  listaIdComp = [];
                  itemsAux = [];
                },
                onCancel: (){

                }
            );
          }else{
            Get.defaultDialog(title: "Lista Vazia!",middleText: "Não pode enviar uma lista vazia.",onCancel: (){});
          }
        },
        //tooltip: 'Pick Image',
        child: Icon(Icons.send,color: Colors.white,),
      ),
    );
  }
}
