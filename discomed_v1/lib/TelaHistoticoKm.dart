import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:discomedv1/IndexOLD.dart';
import 'package:discomedv1/TelaDetalhesKmRodado.dart';
import 'package:discomedv1/Urls.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'ConexaoBd.dart';






class TelaHistoricoKm extends StatefulWidget {
  @override
  _TelaHistoricoKmState createState() => _TelaHistoricoKmState();
}

class _TelaHistoricoKmState extends State<TelaHistoricoKm> {
  List _tarefas = [];
  Map<String, dynamic> _lastRemoved;
  int _lastremovedPos;
  Color cortxt = Colors.black;
  Color cortxt2 = Colors.black45;
  double fontSize = 15;
  double lblfontSize = 15;
  String _id = Get.parameters['id'];
  String _nome = Get.parameters['nome'];
  String _txtLista = "";
  String _idRegistro = "";
  bool verifica;
  String acao = "";
  List filtered = [];
  List items = new List();

  //-------------------------------------------------

  Future<String> _envia(String acao) async {
    print("Chamou o envia!!!!!!!!!!!!Tela históricoKM");
    String _corpo_json = jsonEncode(<String, dynamic>{
      "modulo": "c3RhdHVzS21Sb2RhZG8",
      "id": _id,
      "idRegistro":_idRegistro,
      "acao":acao,
    });
    String a = await enviaparametro(_corpo_json);
    if (a.substring(0, 1) == "E") {
      print("-------------Erro de envio--------------" + decrip(a).toString());
    } else {
      //if testa se deu algum erro no envio se não tratar para decodificar json
      Map<String, dynamic> retornoDespesa = json.decode(a);
      String c = retornoDespesa["status"].toString();
      String d = retornoDespesa["msg"].toString();
      String retornoCreate = a;
      print(
          "**********Else do método _envia linha 56 tELAhISTÓRICOkM *********** " + a.toString());
      //print("Mensagem de Status da despesa venciada " + c.toString());
      if (c.toString() == 'true') {
        verifica = true;
        print("####################### Hoje " + verifica.toString());//var verifica recebe o status para deletar o registro do arquivo local em Dimissible
        //Get.snackbar("Verifica", "${verifica}",backgroundColor: Colors.white);
        //_showModalBottomSheetDespEnv();
        //_imprimeDadosEnviados();
      } else {
        print("Erro entrou no else do envia despesas!!!!");
        Get.snackbar("Falha", "Mensagem não enviada!",
            backgroundColor: Colors.red);
      }
      // _showDialogDespesaEnviada();
    }
  }



  String criptografa(String cryp) {
    var encodedKey =
        'FCAcEA0HBAoRGyALBQIeCAcaDxYWEQQPBxcXHgAFDgY='; //CHAVE EM 256
    var encodedIv = 'DB4gHxkcBQkKCxoRGBkaFA=='; //VETOR INICIALIZAÇÃO
    final Chave =
    enc.Key.fromBase64(encodedKey); //CRIA CHAVE COM BASE NA STRING EM 256
    final Vetor =
    enc.IV.fromBase64(encodedIv); //CRIA VETOR COM BASE NA STRING VETOR
    final TipoCriptografia =
    enc.Encrypter(enc.AES(Chave, mode: enc.AESMode.cbc)); //DEFINE TIPO DE CRIPTOGRAFIA
    final TextoCriptografado =
    TipoCriptografia.encrypt(cryp, iv: Vetor); //GERA TEXTO CRIPTOGRAFADO
    final String retorno = TextoCriptografado.base64;
    //print("Aqui Cripografa ${retorno}");
    return retorno;
  }

  String decrip(String cryp) {
    var encodedKey =
        'FCAcEA0HBAoRGyALBQIeCAcaDxYWEQQPBxcXHgAFDgY='; //CHAVE EM 256
    var encodedIv = 'DB4gHxkcBQkKCxoRGBkaFA=='; //VETOR INICIALIZAÇÃO
    final Chave =
    enc.Key.fromBase64(encodedKey); //CRIA CHAVE COM BASE NA STRING EM 256
    final Vetor =
    enc.IV.fromBase64(encodedIv); //CRIA VETOR COM BASE NA STRING VETOR
    final TipoCriptografia =
    enc.Encrypter(enc.AES(Chave, mode: enc.AESMode.cbc)); //DEFINE TIPO DE CRIPTOGRAFIA
    final TextoDescriptografado = TipoCriptografia.decrypt64(cryp, iv: Vetor);
    print("resposta na função decrip: ${TextoDescriptografado.toString()}");
    return TextoDescriptografado;
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
    print("Corpo do JSON from envia parametro Tela Historico" + _corpo_json);
    print(
        "Corpo do JSON enviado para webservice from envia parametro TelaHistóricoKm linha 117!!!!!" +
            criptografa(_corpo_json));
    String a = decrip(response.body).substring(3);
    print("Variável a from enviaparâmetro" + a.toString());
    if (decrip(response.body).substring(0, 3) == '01.') {
      Map<String, dynamic> retorno =
      json.decode(decrip(response.body).substring(3));
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      String id = retorno["idUsuario"];
     // _idRegistro = retorno["lastId"];
      //mapeia para saber o conteúdo da ms e printar "+b"
      Get.snackbar("Falha", "Mensagem não enviada! ",
          backgroundColor: Colors.red,colorText: Colors.white);
      return "Erro no enviaparametro: " + b;
    } else {
      return decrip(response.body).substring(3);
    }
  }

  //-------------------------------------------------

  Future<File> _getFile() async {
    final directory =
        await getApplicationDocumentsDirectory(); // pega o local de armazenamento dos documentos
    return File(
        "${directory.path}/data.json"); //concatena o caminho com data.json e retorna o arquivo do endereço
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      print("Erro : ${e.toString()}");
    }
  }

  Future<File> _saveData() async {
    print("Entrou no saveData");
    String data = json.encode(
        _tarefas); // pega a lista _todoList converte em um json e armazena na String para gravar no arquivo
    final file =
        await _getFile(); //o objeto aponta para o arquivo armazenado....
    return file.writeAsString(
        data); // função que escreve os dados da variável "data" no objeto file
  }

  Widget criaLista(context, index) {
    return Column(
      children: [
        Dismissible(
          key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
          background: Container(
            color: Colors.red,
            child: Align(
              alignment: Alignment(-0.9, 0.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          direction: DismissDirection.startToEnd,
          child: GestureDetector(
            onTap: () {
              print("toque no card!");
              Get.toNamed(
                  "/telaDetalheKm?device=phone&id=${filtered[index]["idRegistro"]} &data=${filtered[index]["data"]}"
                  "&local=${filtered[index]["local"]} &localEspec=${filtered[index]["localEspec"]} &kmIni=${filtered[index]["kmIni"]}"
                  "&kmFinal=${filtered[index]["kmFinal"]} &dataEditada=${filtered[index]["dataEditada"]} &index=${index} &local= ${""}""");
                  //imprime teste
                  print("Lista da passagem de rota ${filtered[index]["idRegistro"]}");
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 1),
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
                        "" + filtered[index]["dataEditada"],
                        style: TextStyle(color: Colors.deepOrange,fontSize: 17),
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      //Container para mostrar o ID do registro
                      /*Container(

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("id Registro: ...............................",
                                style: TextStyle(
                                    fontSize: lblfontSize, color: cortxt2)),
                            Text(filtered[index]["idRegistro"].toString(),
                                style: TextStyle(
                                    fontSize: fontSize, color: cortxt2)),
                          ],
                        ),

                      ),*/
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Km Inicial: .................................",
                                style: TextStyle(
                                    fontSize: lblfontSize, color: cortxt2)),
                            Text(filtered[index]["kmIni"].toString(),
                                style: TextStyle(
                                    fontSize: fontSize, color: cortxt2)),
                          ],
                        ),

                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Km Final: ...................................",
                                style: TextStyle(
                                    fontSize: lblfontSize, color: cortxt2)),
                            Text(filtered[index]["kmFinal"].toString(),
                                style: TextStyle(
                                    fontSize: fontSize, color: cortxt2)),
                          ],
                        ),

                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Pessoas contatadas.................",
                                style: TextStyle(
                                    fontSize: lblfontSize, color: cortxt2)),
                            Text(filtered[index]["qtde"].toString(),
                                style: TextStyle(
                                    fontSize: fontSize, color: cortxt2)),
                          ],
                        ),

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
          ),
          onDismissed: (direction) async{
            Get.defaultDialog(
                title: "Atenção",
                titleStyle: TextStyle(color: Colors.red),
                middleText: "Deseja realmente deletar?",
                onCancel: (){
                  setState(() {
                    Get.offAndToNamed("/telaHistoricoKm");
                    Navigator.pop(context);//fecha o diálogo com Circular Indicator
                  });
                },
                onConfirm: ()async{

                  //----------------------bloco de teste apaga sem perguntar para API----------------------
                  /*print(_tarefas);
            for(var x in _tarefas){
              print(x);
            }
            setState(() {
              *//*_tarefas.removeAt(index);
              _saveData();*//*
              Conexao con = Conexao();
              con.removerKm(filtered[index]["idRegistro"]);
            });*/
                  //------------------------------------bloco de teste--------------------------------------
                  _idRegistro = filtered[index]["idRegistro"].toString();
                  print("Id registro para deletar " + _idRegistro);
                  // _lastRemoved = Map.from(_tarefas[index]);
                  await _envia("deletar");
                  if(verifica == true){
                    setState(() {
                      int idAux = filtered[index]["idRegistro"];
                      Conexao con = Conexao();
                      con.removerKm(filtered[index]["idRegistro"]);
                      con.deletarPessoasId(int.parse(_idRegistro));// deleta as pessoas ligadas a esse registro
                      filtered.removeAt(index);
                      //----------------------------Bloco com desfazer no arquivo--------------------------------------------
                      //initState();//chamado para atualizar a lista
                      //print(" Id deletado após testar  o Verifica  " + filtered[index]["idRegistro"].toString());
                      //_lastremovedPos = index;
                      //_tarefas.removeAt(index);//remove da lista
                      //print(_tarefas);
                      //_saveData();//salva a lista
                      //Chama SnackBar
                      //-------------------------------Bloco com desfzer--------------------------------------------
                      final snack = SnackBar(
                        content: Text("Registro ${idAux} removido com sucesso!"),
                        action: SnackBarAction(
                          label: "",
                          onPressed: () {
                            setState(() {
                              //-----------Bloco que desfaz--------------------
                              //tarefas.insert(_lastremovedPos, _lastRemoved);//recupera o objeto removido e salva novamente
                              //_saveData(); //salva a lista restaurada
                              //_envia("restaurar");
                              //-----------Bloco que desfaz--------------------
                            });
                          },
                        ),
                        duration: Duration(seconds: 3),
                      );
                      Scaffold.of(context)
                          .removeCurrentSnackBar(); //para remover o sback quando outro for chamado! Eliminando a pilha!
                      Scaffold.of(context).showSnackBar(snack);//Chama o snack!
                    });
                    Navigator.pop(context);
                  }else{
                    Get.toNamed("/index?device=phone&id=${_id} &nome=${_nome}");
                  }

                }
            );

          },
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Conexao db = new Conexao();
    Map<String, dynamic> item = Map();
    db.listarKmRodado().then((notes) {
      setState(() {
        /*notes.forEach((note) {
          int i = 0;
          item["idRegistro"] = note['idRegistro'];
          item["kmIni"] = note['kmIni'];
          item["kmFinal"] = note['kmFinal'];
          item["qtde"] = note['qtde'];
          print("ITEM!!!!!!!!!!!!!!!!!!!!!");
          print(item);
          items.add(item);
          print("Adicionado item ${i}");

          i++;
        });*/
        //filtered.add(Cidades.fromMap(note));
        int i = 1;
        for(var note in notes){
          print(item);
          items.add(note);
          filtered.add(note);
          print(items);
          print("Adicionado item ${i}");
          //filteredUsers.add(Cidades.fromMap(note));
          i++;
        }
        print("Tamanho da lista Items  ${items.length}");
        print("Print Print Print Print Print Print Print Print Print Print ");

      });
      for(var x in items){
        print(x);
      }
    });

    /*_readData().then((data) {
      setState(() {
        _tarefas = json.decode(data);
        filtered = json.decode(data);
        for(var data in _tarefas){
          //print(data['lista']);
        }
        if (_tarefas.isEmpty) {
          setState(() {
            _txtLista = "Lista Vazia!";
          });
        }
      });
    });*/
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
          onPressed: (){Navigator.pop(context);},
        ),
        title: Text(
          "Histórico Km Rodado",
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
            child: TextField(
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  //icon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Digite a data ou o mês para buscar',
                  labelText: 'Pesquisar'
              ),
              onChanged: (string){
                setState(() {
                  filtered = items.where((u)=>
                  (u["dataEditada"]
                      .toLowerCase()
                      .contains(string.toLowerCase()) ||
                      u["dataEditada"].toLowerCase().contains(string.toLowerCase()))).toList();
                });
              },
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.blue,
        onPressed: (){
          Get.offAndToNamed("/telaKmRodadoStepper?device=phone&id=${_id} &nome=${_nome}");
        },
      ),
    );
  }
}
