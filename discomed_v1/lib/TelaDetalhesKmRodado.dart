
import 'dart:convert';
import 'dart:io';
import 'dart:math' as calc;
import 'package:discomedv1/Bordas.dart';
import 'package:discomedv1/TelaHistoticoKm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'ConexaoBd.dart';
import 'PessoaModel.dart';

class TelaDetalhesKmRodado extends StatefulWidget {
  @override
  _TelaDetalhesKmRodadoState createState() => _TelaDetalhesKmRodadoState();
}

class _TelaDetalhesKmRodadoState extends State<TelaDetalhesKmRodado> {

  String _data = Get.parameters['data'];
  String _id = Get.parameters['id'];
  String _local = Get.parameters['local'];
  String _localEsp = Get.parameters['localEspec'];
  String _kmIni = Get.parameters['kmIni'];
  String _kmFinal = Get.parameters['kmFinal'];
  String _dataEditada = Get.parameters['dataEditada'];
  String idRegistro = Get.parameters['idRegistro'];
  List  listaAux = [];
  double fontSize = 12;
  Color corLbl = Colors.deepOrange;
  Color cortxt2 = Colors.blueGrey;
  int sizeList = 0;
  List<Pessoa> listaPessoas = new List();
  int totalKm;

  int somaKm(){
    var x = int.parse(_kmFinal)-int.parse(_kmIni);
    return x;
  }

  Widget getCardsListView() {
    return idRegistro.isNotEmpty
        ? Expanded(
      child: ListView.builder(

          itemCount: idRegistro.length,
          padding: const EdgeInsets.all(1.0),
          itemBuilder: (context, position) {
            final item = idRegistro[position];
            return Dismissible(
              background: Container(
                color: Colors.red,
                child: Align(
                  alignment: Alignment(-0.9, 0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
              key: Key(item.toString()),
              onDismissed: (direction){
                Scaffold
                    .of(context)
                    .showSnackBar(
                  SnackBar(
                    content:
                    Text(
                        "Despesa foi removida!"),
                  ),
                );
              },
              child: Column(
                children: <Widget>[
                  Divider(height: 2.0),
                  GestureDetector(
                    onTap: ()async{
                    },

                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text("",
                                    style: TextStyle(
                                      fontSize: 20,
                                      //color: items[position].status == "DEVOLVIDO" ? Colors.red : Colors.green,
                                      color: Colors.black
                                    ),
                                  ),
                                  width: 290,
                                ),
                              ],
                            ),
                            Text("DATA: ${idRegistro[position]}"),
                            /*Text("Tipo: ${items3[int.parse(items[position].idTipoDespesa)-1].tipo}"),
                            Text("VALOR: R\$ ${items[position].valor}"),
                            Text("CIDADE: ${items[position].idCidade}"),
                            //Text("Cidade: ${items4[0].nomeMunicipio}"),
                            Text("OBS DA DESPESA: ${items[position].observacao}"),
                            Text("OBSERVAÇÃO: ${items[position].obsRetorno}"),
                            Text("Id do Tipo: ${items[position].idTipoDespesa}"),*/
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
      ),
    )
        : //Center(child: Image.asset("img/logo1.png", height: 200,));
    Center(child:
    Padding(
        padding: EdgeInsets.only(top: 100),
        child: Text("Lista Vazia!")));
  }


  List _tarefas = [];

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

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    print("Init State aqui ${_id}");
    /*_readData().then((data) {
      setState(() {
        _tarefas = json.decode(data);
        for(var data in _tarefas){
          print(" Print do initState telaDetalhes ${data['lista']}");
          listaAux.add(data['lista']);
        }
        if (_tarefas.isEmpty) {
          setState(() {
            print("Lista vazia");
          });
        }
      });
      print(listaAux[int.parse(indexListAux)]);
      print("InitState linha 156 Tamanho da lista  listaAux ${listaAux[int.parse(indexListAux)].length}");
      sizeList = listaAux[int.parse(indexListAux)].length;
      print("Tamanho do sizeList ${sizeList}");
    });*/
    Conexao con = Conexao();
    con.listarPessoasId(int.parse(_id)).then((notes) {
      setState(() {
        notes.forEach((note) {
          listaPessoas.add(Pessoa.fromMap(note));
          print(note.toString());
        });
        if(listaPessoas.isNotEmpty){
          print("Lista Pessoas Carregada!");
        }else{
          print("Lista VAzia!");
        }
      });
    });

    /*con.listarPessoas2().then((notes) {
      setState(() {
        notes.forEach((note) {
          listaPessoas.add(Pessoa.fromMap(note));
          //print("notes ${listaPessoas}");
        });
        if(listaPessoas.isNotEmpty){
          for(var data in listaPessoas){
            print("WWW ${data.observacao}");
          }
          print("Lista Pessoas Carregada!");
        }else{
          print("Lista VAzia!");
        }
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),color: Colors.white,onPressed: (){Navigator.pop(context);},),
        elevation: 0,
        backgroundColor: Colors.blue,
        //title: Text("Detalhes Km do Km rodado",style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 0),
        child: Stack(
          children: [
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.only(top:20.0,left: 20),
                child: Text("DETALHES DA KM",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:116,left:170),
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 35,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:120,left:175),
              child: CircleAvatar(
                child: Icon(Icons.timelapse,size: 50,),
                backgroundColor: Colors.blue,
                radius: 30,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top:190,left: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //------------------------------------------------------------Container da Data--------------------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top:30,right: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: myBoxDecorationRadBlur(),
                      child: Center(child: Text(_dataEditada,style:TextStyle(fontSize:17,color: Colors.blueAccent))),
                    ),
                  ),
                  //------------------------------------------------------------Container  Rota/Km/Contato----------------------
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top:30,right: 10),
                    child: Container(
                      //decoration: myBoxDecoration2(Colors.black12),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //----------------------------------------------------Container Rota------------------------------------------
                          Container(
                            //decoration: myBoxDecoration2(Colors.black12),
                            child: Column(
                              children: [
                                Text("Rota ",style: TextStyle(color: Colors.grey,fontSize: 17),),
                                Padding(
                                    padding: const EdgeInsets.only(top:10,bottom: 10),
                                    child: Row(
                                      children: [
                                        Text("Local:           ...................",style:TextStyle(fontSize: fontSize,color: Colors.grey)),
                                        Text(_local,style:TextStyle(fontSize: fontSize,color: Colors.black)),
                                      ],
                                    )
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                          Divider(),
                          /*Padding(
                            padding: const EdgeInsets.only(top:10,bottom: 20),
                            child: Row(
                              children: [
                                Text("LocalEsp:     ...................",style:TextStyle(fontSize: 17,color: Colors.blueGrey)),
                                Text(_localEsp,style:TextStyle(fontSize: fontSize,color: Colors.blueGrey)),
                              ],
                            )
                          ),*/
                          //----------------------------------------------------Container Kilometragem------------------------------------------------

                          Container(
                            //decoration: myBoxDecoration2(Colors.black12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text("Kilometragem",style: TextStyle(color: Colors.grey,fontSize: 17),),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(

                                      children: [
                                        Divider(),
                                        Padding(
                                            padding: const EdgeInsets.only(top:10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("Km Inicial:     ...................",style:TextStyle(fontSize: fontSize,color: Colors.blueGrey)),
                                                Text(_kmIni.toString()+" Km",style:TextStyle(fontSize: fontSize,color: Colors.black)),
                                              ],
                                            )
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(top:10),
                                            child: Row(
                                              children: [
                                              Text("Km Final:       ...................",style:TextStyle(fontSize: fontSize,color: Colors.blueGrey)),
                                              Text(_kmFinal.toString()+"Km",style:TextStyle(fontSize: fontSize,color: Colors.black)),
                                            ],)
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(
                                        //decoration: myBoxDecoration2(Colors.deepOrange),
                                        width: MediaQuery.of(context).size.width/2,
                                          child: Column(
                                            children: [
                                              Center(child: Text("${somaKm()}",style: TextStyle(fontSize: 35,color: Colors.black),)
                                              ),
                                              Text("Kilometros",style: TextStyle(color: Colors.grey),)
                                            ],
                                          )
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),

                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left:10,top:10),
                      child: Container(child: Text("Contatos:",style:TextStyle(fontSize: 17,color: Colors.black)))
                  ),
                  Expanded(
                    child:listaPessoas.isEmpty?Center(child: Text("Lista vazia"),) :ListView.builder(
                      //scrollDirection: Axis.horizontal,
                        itemCount: listaPessoas.length,
                        padding: const EdgeInsets.all(1.0),
                        itemBuilder: (context, position) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color:Color.fromARGB(255,254, 249, 231),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15,left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Nome: ',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Divider(height: 5.0,color: Colors.pink,),
                                          Text(
                                            '${listaPessoas[position].nome}',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Text(
                                            'Obs:    ',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 5),
                                              child: Text(
                                                '${listaPessoas[position].observacao}',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ),
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}
