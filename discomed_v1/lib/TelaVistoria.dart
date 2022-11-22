import 'dart:convert';

import 'package:discomedv1/OfensorVistoriaModel.dart';
import 'package:discomedv1/TipoVistoriaModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'ConexaoBd.dart';
import 'Criptografia.dart';
import 'VistoriaModel.dart';
import 'SetorVistoriaModel.dart';
import 'StatusVistoriaModel.dart';
import 'Urls.dart';
import 'package:http/http.dart' as http;


class TelaVistoria extends StatefulWidget {
  @override
  _TelaVistoriaState createState() => _TelaVistoriaState();
}

class _TelaVistoriaState extends State<TelaVistoria> {
  TextEditingController _textEditingControllerVistoria = new TextEditingController();
  TextEditingController _textEditingControllerSetor = new TextEditingController();
  TextEditingController _textEditingControllerItem = new TextEditingController();
  TextEditingController _textEditingControllerDescricao = new TextEditingController();
  bool _mostraSetor = false;
  bool _mostraOpcao = false;
  bool _mostraBotao = false;
  /*List listaVistoria = ["1VISTORIA NICHOS","2VISTORIA CARROS","3CONTROLE TEMPERATURA","4VISTORIA ESTOQUE"];
  List listaSetor = ["1DIREITORIA","2FATURAMENTO ","3TI","4ESTOQUE ","5QUALIDADE ","6FINANCEIRO ","7SER.GERAIS ","8VENDAS ","9TÉCNICA ","10GER.EXECUTIVA ","11GER.COMERCIAL ","12RH "];
  List listaItem = ["1MESA","2GAVETA","3ALIMENTO","TODOS"];
  List listaOpcoes = ["1C = CONFORME","2AP = ATENDE PARCIALMENTE","3NC =  NÃO CONFORME","4NA = NÃO SE APLICA"];*/
  final _formKey = GlobalKey<FormState>();

  List <VistoriaModel> listaVistoNichos = [];
  List <VistoriaModel> listaVistoNichosAux = [];
  final corBotao = Colors.blue;
  VistoriaModel dirObj1 = VistoriaModel();
  String _id_Usuario = Get.parameters['id'];
  String _objJsonGlobal = "";
  String idVist = "";
  String idSetor = "";
  String idOfensor = "";


  enviaparametro(String _corpo_json) async {
    //ENVIA TEXTO CRIPTOGRAFADO E DESCRIPTOGRAFA RETORNO
    String url = Urls.url;
    final http.Response response = await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
    }, body: {
      'corpo': criptografa(_corpo_json)
    });
    print("Corpo do JSON from envia parametro" + _corpo_json);
    print(
        "Corpo do JSON enviado para webservice from envia parametro @@@@@@@@@@@@!!!!!" +
            criptografa(_corpo_json));
    String a = decrip(response.body).substring(3);
    print("Variável a from enviaparâmetro" + a.toString());
    if (decrip(response.body).substring(0, 3) == '01.') {
      Map<String, dynamic> retorno =
      json.decode(decrip(response.body).substring(3));
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      String id = retorno["idUsuario"];
      //mapeia para saber o conteúdo da ms e printar "+b"
      Get.snackbar("Falha", "Mensagem não enviada! Verifique a Data e etc... ",
          backgroundColor: Colors.red,colorText: Colors.white);
      return "Erro no enviaparametro: " + b;
    } else {
      return decrip(response.body).substring(3);
    }
  }

  Future<String> _enviaVistoria() async {

    //CRIA O JSON
    String _corpo_json = jsonEncode(<String, dynamic>{
      "modulo": "c2FsdmFyVmlzdG9yaWFz",
      "id": _id_Usuario,
      "tipo" : idVist,
      "VistObjJson" : listaVistoNichosAux,

    });

    print(_corpo_json);
    // CHAMA O MÉTODO DE ENVIO E RECEBE A SUA RESPOSTA
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
        Get.snackbar("Enviando...", "Sucesso no envio!.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green);
        setState(() {
          limpa();
        });
        //CircularProgressIndicator(value: 20,);
       // await _showModalBottomSheetDespEnv();
        //_imprimeDadosEnviados();
      } else {
        print("Erro entrou no else do envia despesas!!!!");
        Get.snackbar("Falha", "Mensagem não enviada! Verifique data, imagem etc.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red);
      }
      // _showDialogDespesaEnviada();
    }
  }

  _SelecionaTipo(List lista) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: lista.length,
                        padding: const EdgeInsets.all(1.0),
                        itemBuilder: (context, position) {
                          return Column(
                            children: <Widget>[
                              Divider(height: 2.0),
                              ListTile(
                                  title: Center(
                                    child: Text(
                                      '${lista[position].tipo}',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      _textEditingControllerVistoria.text = lista[position].tipo;
                                      idVist = lista[position].id;
                                      _mostraSetor = true;
                                    });
                                    Navigator.pop(context);//fecha a caixa
                                  }
                              ),
                            ],
                          );
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CupertinoButton(
                        //color: Colors.green,
                        child: Text("Cancelar",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {

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

  _SelecionaSetor(List lista) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: lista.length,
                        padding: const EdgeInsets.all(1.0),
                        itemBuilder: (context, position) {
                          return Column(
                            children: <Widget>[
                              Divider(height: 2.0),
                              ListTile(
                                  title: Center(
                                    child: Text(
                                      '${lista[position].setor}',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      _textEditingControllerSetor.text = lista[position].setor;
                                      idSetor = lista[position].id;
                                      _mostraOpcao = true;
                                    });
                                    Navigator.pop(context);//fecha a caixa
                                  }
                              ),
                            ],
                          );
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CupertinoButton(
                        //color: Colors.green,
                        child: Text("Cancelar",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {

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

  _SelecionaOfensor(List lista) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: lista.length,
                        padding: const EdgeInsets.all(1.0),
                        itemBuilder: (context, position) {
                          return Column(
                            children: <Widget>[
                              Divider(height: 2.0),
                              ListTile(
                                  title: Center(
                                    child: Text(
                                      '${lista[position].ofensor}',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      _textEditingControllerItem.text = lista[position].ofensor;
                                      idOfensor = lista[position].id;
                                      _mostraBotao = true;
                                    });
                                    Navigator.pop(context);
                                  }
                              ),
                            ],
                          );
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CupertinoButton(
                        //color: Colors.green,
                        child: Text("Cancelar",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {

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


  Widget getLista(){
    return listaVistoNichos.isNotEmpty ?
    Expanded(
      flex: 3,
      child: ListView.builder(
          itemCount: listaVistoNichos.length,
          padding: const EdgeInsets.all(1.0),
          itemBuilder: (context, position) {
            return listaVistoNichos.isEmpty ? Center(child: Text("Lista Vazia!"),):
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Container(
                color: Colors.grey[200],
                child: Column(
                  children: <Widget>[
                    Divider(height: 2.0),
                    Dismissible(
                      background: Container(
                        color: Colors.red,
                        child: Align(
                          alignment: Alignment(-0.9, 0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                      key: UniqueKey(),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction){
                        Get.defaultDialog(
                          title: "Deseja realmente Excluir?",
                          middleText: "",
                          onConfirm: (){
                          setState(() {
                            listaVistoNichos.removeAt(position);
                            listaVistoNichosAux.removeAt(position);
                          });
                          Navigator.pop(context);
                          },
                          textConfirm: "Excluir",

                          onCancel: (){setState(() {
                            listaVistoNichos;
                          });},
                          textCancel: "Cancelar"
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0,right: 0),
                        child: Card(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:20.0,top: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${listaVistoNichos[position].nome}',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                  Text(
                                                    ' - ',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${listaVistoNichos[position].ofensor}',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            /*Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left:8.0),
                                                child: CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: listaVistoNichos[position].resultFinal == "C" ? Colors.green:listaVistoNichos[position].resultFinal == "AP" ? Colors.yellow :listaVistoNichos[position].resultFinal == "NC" ? Colors.red: Colors.grey,
                                                  child: Text(
                                                    '${listaVistoNichos[position].resultFinal}',
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )*/
                                          ],

                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0),
                                          child: Row(
                                            children: [
                                              Text("Observação: ",style: TextStyle(fontSize: 12.0,color: Colors.grey),),
                                              Expanded(child: Text('${listaVistoNichos[position].descricao}',style: TextStyle(fontSize: 12.0,color: Colors.grey),)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: listaVistoNichos[position].resultFinal == "C" ? Colors.green:listaVistoNichos[position].resultFinal == "AP" ? Colors.yellow :listaVistoNichos[position].resultFinal == "NC" ? Colors.red: Colors.grey,
                                    child: Text(
                                      '${listaVistoNichos[position].resultFinal}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    ):
    Expanded(
      child: Padding(
          padding: EdgeInsets.only(top: 100),
          child: Text("Lista Vazia!")),
    );
  }

  void geraFinal(List lista, List listaAux){
    for(String x in lista){
      //print(x);
      if(x.contains('NC')){
        listaAux.add(4);
      }else if(x.contains('AP')) {
        listaAux.add(3);
      }else if(x.contains('C')){
        listaAux.add(2);
      }else{
        listaAux.add(1);
      }
    }
    for(var x in listaAux){
      //print(x);
    }
  }

  String geraResultFinal(List listAux,var resultFinal){
    var aux = 0;
    for(var num in listAux){
      if(num > aux){
        //if para pegar o maior dentro da lista...
        aux = num;
      }
      //print(num);
    }
    setState(() {
      if(aux == 4){
        resultFinal = "NC";
        //print("NC = ${aux} + ${resultFinal}");
      }else if(aux == 3){
        resultFinal = "AP";
        //print("AP = ${aux} + ${resultFinal}");
      }else if(aux == 2){
        resultFinal = "C";
        //print("C = ${aux} + ${resultFinal}");
      }
      else{
        resultFinal = "NA";
        //print("NA = ${aux} + ${resultFinal}");
      }

      print("Auxiliar");
      print(aux);
      print(resultFinal);
    });

    return resultFinal;
  }

  void geraCard(int position){

    VistoriaModel obj = VistoriaModel();
    VistoriaModel objAux = VistoriaModel();
    //Objeto criado para mostrar na telai
    obj.tipo = _textEditingControllerVistoria.text;
    obj.nome = _textEditingControllerSetor.text;
    obj.resultFinal = listaStatusVistoria[position].sigla;
    obj.ofensor = _textEditingControllerItem.text;
    obj.descricao = _textEditingControllerDescricao.text;

    //Objeto criado com os IDs para enviar para a API
    objAux.nome = idSetor;
    objAux.ofensor = idOfensor;
    objAux.resultFinal = listaStatusVistoria[position].id;
    objAux.descricao = _textEditingControllerDescricao.text;

    Conexao con = Conexao();
    con.salvarVistoria(obj.tipo,obj.nome,obj.ofensor,obj.descricao,listaStatusVistoria[position].sigla);


    setState(() {
      //Insere na lista atualizando
      listaVistoNichos.add(obj);
      listaVistoNichosAux.add(objAux);
    });
    for(var x in listaVistoNichos){
      print("Ofensor = ${x.nome + " " + x.ofensor + " " + x.resultFinal + " " + x.descricao }");
    }
    //_textEditingControllerOpcao.clear();
  }

  _classifica() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: listaStatusVistoria.length,
                        padding: const EdgeInsets.all(1.0),
                        itemBuilder: (context, position) {
                          return Column(
                            children: <Widget>[
                              Divider(height: 2.0),
                              ListTile(
                                  title: Center(
                                    child: Text(
                                      '${listaStatusVistoria[position].status}',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: listaStatusVistoria[position].sigla == "C" ? Colors.green: listaStatusVistoria[position].sigla.trim() == "AP" ? Colors.yellow:listaStatusVistoria[position].sigla.trim() == "NC" ? Colors.red: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    geraCard(position);//insere um card na lista
                                    _textEditingControllerItem.clear();
                                    _textEditingControllerDescricao.clear();//limpa o input toda vez que é escolhido uma opção
                                    Navigator.pop(context);//fecha a caixa
                                  },
                               /* subtitle:CircleAvatar(
                                  child: Text(
                                    '${listaStatusVistoria[position].sigla}',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      color: listaStatusVistoria[position].sigla == "C" ? Colors.green: listaStatusVistoria[position].sigla.trim() == "AP" ? Colors.yellow:listaStatusVistoria[position].sigla.trim() == "NC" ? Colors.red: Colors.blue,
                                    ),
                                  ),
                                ),*/
                              ),
                            ],
                          );
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      /*CupertinoButton(
                        //color: Colors.red,
                        child: Text(
                          "Não",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        onPressed: () {
                          //Navigator.pop(context);
                        },
                      ),*/
                      CupertinoButton(
                        //color: Colors.green,
                        child: Text("Cancelar",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
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

  List<TiposVistoria> listatiposVistoria = new List();
  List<OfensorVistoria> listaofensorVistoria = new List();
  List<SetorVistoria> listasetorVistoria = new List();
  List<StatusVistoria> listaStatusVistoria = new List();
  Conexao db = new Conexao();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    db.getStatusVist().then((notes) {
      setState(() {
        notes.forEach((note) {
          listaStatusVistoria.add(StatusVistoria.fromMap(note));
          //_wer = items[0].tipo;
        });
      });
    });

    db.getTiposVist().then((notes) {
      setState(() {
        notes.forEach((note) {
          listatiposVistoria.add(TiposVistoria.fromMap(note));
          //_wer = items[0].tipo;
        });
      });
    });

    db.getOfensorVist().then((notes) {
      setState(() {
        notes.forEach((note) {
          listaofensorVistoria.add(OfensorVistoria.fromMap(note));
          //_wer = items[0].tipo;
        });
      });
    });

    db.getSetorVist().then((notes) {
      setState(() {
        notes.forEach((note) {
          listasetorVistoria.add(SetorVistoria.fromMap(note));
          //_wer = items[0].tipo;
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vistoria Nova",style: TextStyle(color: Colors.white),),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
            //onPressed: ()=> Get.toNamed("/index?device=phone&nome=${_nome_Usuario}&id=${_id_Usuario}"),
            //onPressed: ()=> Navigator.pop(context),
            onPressed: (){
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            }
        ),
        actions: [
           Visibility(
            visible: _mostraBotao,
            child: GestureDetector(
                onTap: (){
                  setState(() {
                    limpa();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right:16.0),
                  child: Center(child: Text("Limpar",style: TextStyle(color: Colors.white),)),
                )),
          ),
        ],
      ),
      body: Column(
        children: [
          /*Container(
              width: MediaQuery.of(context).size.width,
              //height: 50,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    Text("C = CONFORME",style: TextStyle(fontSize: 10,color:Colors.green ),),
                    Text("AP = ATENDE PARCIALMENTE",style: TextStyle(fontSize: 10,color:Colors.yellow),),
                    Text("NC = NÃO CONFORME",style: TextStyle(fontSize: 10,color:Colors.red),),
                    Text("NA = NÃO SE APLICA",style: TextStyle(fontSize: 10),),
                  ],
                ),
              )
          ),*/
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () async {
                      _SelecionaTipo(listatiposVistoria);
                      //_showModalBottomSheetTipos(); //chama o BottomSheet tipos
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                    controller: _textEditingControllerVistoria,
                    cursorColor: Colors.black45,
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tipo Vistoria',
                      hintText: 'Selecione a Vistoria',
                    ),
                  ),
                ),

                Visibility(
                  visible: _mostraSetor,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
                    child: TextFormField(
                      readOnly: true,
                      onTap: () async {
                        _SelecionaSetor(listasetorVistoria);
                        //_showModalBottomSheetTipos(); //chama o BottomSheet tipos
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo Obrigatório';
                        }
                        return null;
                      },
                      controller: _textEditingControllerSetor,
                      cursorColor: Colors.black45,
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Selecione um Setor',
                        hintText: 'Setor',
                      ),
                    ),


                  ),

                ),

                Visibility(
                  visible: _mostraOpcao,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
                    child: TextFormField(
                      readOnly: true,
                      onTap: () async {
                        _SelecionaOfensor(listaofensorVistoria);
                        //_showModalBottomSheetTipos(); //chama o BottomSheet tipos
                      },
                      /*validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo Obrigatório';
                        }
                        return null;
                      },*/
                      controller: _textEditingControllerItem,
                      cursorColor: Colors.black45,
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Item',
                        hintText: 'Selecione um item',
                      ),
                    ),
                  ),

                ),
                Visibility(
                  visible: _mostraOpcao,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
                    child: TextFormField(
                      maxLines: 2,
                      /*validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo Obrigatório';
                        }
                        return null;
                      },*/
                      //Não valida pois pode enviar sem a descrição!
                      textInputAction: TextInputAction.done ,
                      controller: _textEditingControllerDescricao,
                      autofocus: false,
                      cursorColor: Colors.black45,
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Observação',
                        // hintText: 'Descreva o motivo',
                      ),
                    ),


                  ),

                ),
              ],
            ),
          ),
          Visibility(
            visible: _mostraBotao,
            child: Padding(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(corBotao)
                  ),
                  onPressed: (){
                    print(" ");
                    if(_textEditingControllerItem.text.trim() == "MESA"){
                      print("Escolheu Mesa");
                      _classifica();
                      print("${_textEditingControllerSetor.text
                      }");
                    }else if(_textEditingControllerItem.text.trim() == "GAVETA"){
                      print("Escolheu Gaveta");
                      _classifica();
                      print("${_textEditingControllerSetor.text
                      }");
                    }else{
                      print("Escolheu Alimento");
                      _classifica();
                      print("${_textEditingControllerSetor.text
                      }");
                    }

                  },
                  child: Text("Selecione"),
                ),
              ),
            ),
          ),
         /* Visibility(
            visible: _mostraBotao,
            child: Padding(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.amber)),
                  child: Text("Limpa"),
                  onPressed: (){setState(() {
                    limpa();
                  });},
                ),
              ),
            ),
          ),*/
          getLista(),
          Expanded(
            flex: 1,
            child: SizedBox(
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send,color: Colors.white,),
        backgroundColor: Colors.green,
        onPressed: (){
          if(_formKey.currentState.validate()){
            if(listaVistoNichos.isNotEmpty){
              _enviaVistoria();
            }else {
              Get.snackbar("Atenção!", "Precisa adicionar Alguma vistoria!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red);
            }
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void limpa() {
    _textEditingControllerSetor.clear();
    _textEditingControllerItem.clear();
    _textEditingControllerVistoria.clear();
    _textEditingControllerDescricao.clear();
    _mostraOpcao = false;
    _mostraSetor = false;
    _mostraBotao = false;
  }
}
