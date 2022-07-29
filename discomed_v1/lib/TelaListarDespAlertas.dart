import 'package:discomedv1/Urls.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:discomedv1/ConexaoBd.dart';
import 'package:discomedv1/TiposModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;
import 'package:intl/intl.dart';
import 'dart:async';
import 'CidadesModel.dart';
import 'Criptografia.dart';
import 'DespesaModel.dart';
import 'TelaLoginNova.dart';

class TelaListarDespAlertas extends StatefulWidget {
  @override
  _TelaListarDespAlertasState createState() => _TelaListarDespAlertasState();
}

class _TelaListarDespAlertasState extends State<TelaListarDespAlertas> {

  List<Despesa> items = new List();
  List<TiposDespesa> items3 = new List();
  List<Cidades> items4 = new List();
  List<TiposDespesa> items2 = new List();

  Conexao db = new Conexao();
  String _msgServidor = "";
  String _statusEnvio = "";
  String _dadosCarregados = "";
  String _recebeVisualizada = Get.parameters['visualizada'];
  String _id = Get.parameters['id'];
  String _nome = Get.parameters['nome'];
  String _idDespesa = "";
  int _qtdeDesp = 0;
  TextEditingController _textEditingControllerIni = new TextEditingController();
  TextEditingController _textEditingControllerFin = new TextEditingController();
  String _vardataPT_Ini;
  String _vardataPT_Final;
  String txtDataIni = "Data Inicial";
  String txtDataFinal = "Data Final";
  String _codigoCidadeParametro = '';
  Color lblColor = Colors.grey[500];
  double font = 13;
  double font2 = 15;
  Color txtColor = Colors.black;
  List codigosCidade = new List();




/*  String criptografa(String cryp)  {
    var encodedKey = 'FCAcEA0HBAoRGyALBQIeCAcaDxYWEQQPBxcXHgAFDgY='; //CHAVE EM 256
    var encodedIv = 'DB4gHxkcBQkKCxoRGBkaFA=='; //VETOR INICIALIZAÇÃO
    final Chave = enc.Key.fromBase64(encodedKey); //CRIA CHAVE COM BASE NA STRING EM 256
    final Vetor = enc.IV.fromBase64(encodedIv); //CRIA VETOR COM BASE NA STRING VETOR
    final TipoCriptografia = enc.Encrypter(enc.AES(Chave, mode: enc.AESMode.cbc)); //DEFINE TIPO DE CRIPTOGRAFIA
    final TextoCriptografado = TipoCriptografia.encrypt(cryp, iv: Vetor); //GERA TEXTO CRIPTOGRAFADO
    final String retorno = TextoCriptografado.base64;
    //print("Aqui aqui ${retorno}");
    return retorno;
  }//func para criptografar

  String decrip(String cryp) {
    var encodedKey = 'FCAcEA0HBAoRGyALBQIeCAcaDxYWEQQPBxcXHgAFDgY='; //CHAVE EM 256
    var encodedIv = 'DB4gHxkcBQkKCxoRGBkaFA=='; //VETOR INICIALIZAÇÃO
    final Chave = enc.Key.fromBase64(encodedKey); //CRIA CHAVE COM BASE NA STRING EM 256
    final Vetor = enc.IV.fromBase64(encodedIv); //CRIA VETOR COM BASE NA STRING VETOR
    final TipoCriptografia = enc.Encrypter(enc.AES(Chave, mode: enc.AESMode.cbc)); //DEFINE TIPO DE CRIPTOGRAFIA
    final TextoDescriptografado = TipoCriptografia.decrypt64(cryp, iv: Vetor);
    //print("resposta na função decrip: ${TextoDescriptografado.toString()}");
    return TextoDescriptografado;
  }//func para dcriptografar*/


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

    setState(() {
      _statusEnvio = response.statusCode.toString();
    });

    if(decrip(response.body).substring(0,3)== '01.') {
      Map<String ,dynamic> retorno = json.decode(decrip(response.body).substring(3));
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      //mapeia para saber o conteúdo da ms e printar "+b"
      return "Erro: "+b;
    }
    else {
      print("Else EnviaParametro" + decrip(response.body).substring(3));
      return  decrip(response.body).substring(3);
    }
  }

  Future <String> _carregaDespRecu(String status, String alerta,String visu) async{
    List<TiposDespesa> cidades = new List();

    String _corpo_json = jsonEncode(<String, String>{
      'modulo':"ZGVzcGVzYXNBdGl2YXM=",
      'id': _id,
      //'visualizada': _recebeVisualizada,
      'visualizada': visu,
      'dataIni':"",
      'dataFinal': "",
      'status': status,
      'alerta': alerta,
    });

    //envia corpo json webservice
    String dados = await EnviaParametro(_corpo_json);//Aqui capitura na ver dados, o retorno do método que faz a requisição para a API
    List msg = new List();
    http.Response response2;

    if (dados.substring(0,1) == "E") {
      print ("Mensagem no if método carregaDesprecu ${dados}");
    }
    else  {
      //tratar para decodificar json
      //print (dados);
      print("Entrou no else carregadespRecu\n");
      print("Aqui" + dados);
      //cria um mapa com a variável dados, que recebe o retorno, do método envia parâmetro. Que são os dados da mensagem!
      Map<String ,dynamic> retorno2 = json.decode(dados);
      String st = retorno2["status"].toString();//status do response.boby
      print("Status =  ${st}");
      msg = retorno2["msg"];// body do response.body
      print("msg = ${msg.toString()}");
      //List<Despesa> lista;
      items = msg.map<Despesa>((json) => Despesa.fromJson(json)).toList();//aqui cria uma lista e converte o código de Json para uma Lista
      //items = lista;
      _qtdeDesp = await items.length;
      print("Quantidade de Despesas dentro do _carregaDespRecu: ${items.length}");
      if(_qtdeDesp > 0){
        for(var data in items){
          db.getCidadesforId(int.parse(data.idCidade)).then((notes) {
            setState(() {
              notes.forEach((note) {
                items4.add(Cidades.fromMap(note));
              });
              for(var cid in items4){
                //print(cid.nomeMunicipio);
                _codigoCidadeParametro = data.idCidade;// recebe o id da cidade para enviar para editar
                data.idCidade = cid.nomeMunicipio;
              }
            });
          });
          codigosCidade.add(data.idCidade);
          print("*******111********** Status:${data.status} ID: ${data.id} Despesa:${data.valor} Data ${data.data} id Cidade: ${data.idCidade} Id TipoDesp ${data.idTipoDespesa} retorno: ${data.obsRetorno} ");
        }
      }else{
        print("Não retornou despesas solicitadas! ");
      }
      setState(() {
        _msgServidor = st;
        _dadosCarregados = msg.toString();
      });
    }
  }

  Future <String> _deletaDesp() async{

    String _corpo_json = jsonEncode(<String, String>{
      'modulo':"ZGVzYXRpdmFEZXNwZXNh",
      'id': _id,
      "idDespesa":_idDespesa,
    });

    //envia corpo json webservice
    String dados = await EnviaParametro(_corpo_json);
    List msg = new List();
    http.Response response2;

    if (dados.substring(0,1) == "E") {
      print ("Mensagem no if método deletaDesp ${dados}");
    }
    else  {
      //tratar para decodificar json
      //print (dados);
      print("Entrou no else carrega deletaDesp\n");
      print("Aqui" + dados);
      //cria um mapa com a variável dados, que recebe o retorno, do método envia parâmetro. Que são os dados da mensagem!
      Map<String ,dynamic> retorno2 = json.decode(dados);
      String st = retorno2["status"].toString();//status do response.boby
      print("Status =  ${st}");
      msg = retorno2["msg"];// body do response.body
      print("msg = ${msg.toString()}");
    }
  }

  /*DateTimePickerLocale _locale = DateTimePickerLocale.pt_br;
  List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;
  String _format = 'dd-MM-yyyy';
  DateTime _dateTimeIni;
  DateTime _dateTimeFinal;*/ //*-*-*-*-*-**-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


  Future<bool> _showDialogDeleta(BuildContext context,String item) {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Deseja deletar uma despesa?',style: TextStyle(color: Colors.red),),
        content: Text('Confira por favor!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _carregaDespRecu("devolvido", "nao", "sim"); //carrega só as recusadas
              //_carregaDespRecu("","",""); //carrega todas
              print("Clicou não");
              Navigator.of(context).pop(false);//Nada faz e fica na mesma tela
              //Get.offAllNamed("/index?device=phone&id=${_id} &nome=${_nome}");--------------------------------------------------------------------------------
            },
            child: Text('Não',style: TextStyle(color: Colors.red),),
          ),
          FlatButton(
            onPressed: () {
              _deletaDesp();
              //Get.offNamed("/index?device=phone&id=${_id} &nome=${_nome}");
              _carregaDespRecu("", "", "sim"); //carrega só as recusadas
              Navigator.of(context).pop(false);//Nada faz e fica na mesma tela
              Scaffold
                  .of(context)
                  .showSnackBar(
                SnackBar(
                  content:
                  Text(
                      " Despesa ${item} foi removida!"),
                ),
              );
            },
            child: Text('Sim',style: TextStyle(color: Colors.green),),
          ),
        ],
      ),
    ) ??
        false;
  }

  Widget getCardsListView() {
    return items.isNotEmpty
        ? Expanded(
      child: ListView.builder(
          itemCount: items.length,
          padding: const EdgeInsets.all(1.0),
          itemBuilder: (context, position) {
            final item = items[position];
            return Dismissible(
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
                _showDialogDeleta(context,item.id);
                _idDespesa = item.id;
                print("'''''''''''''''''''''''''''''''''" + _idDespesa);
                //_deletaDesp();
                //Get.offNamed("/index?device=phone&id=${_id} &nome=${_nome}");
              },
              child: Column(
                children: <Widget>[
                  Divider(height: 2.0),
                  GestureDetector(
                    onTap: ()async{
                      print("Clicado no Gesture!!!!!!!");
                      Conexao con = new Conexao();
                      List tipos = await con.buscarTipoPorId(int.parse(item.idTipoDespesa));// aqui busca no banco a o tipo pelo id
                      //List tipos = await con.buscarTipoPorId(2);
                      //Busca o
                      db.buscarTipoPorId(int.parse(item.idTipoDespesa)).then((notes) {
                        setState(() {
                          notes.forEach((note) {
                            items2.add(TiposDespesa.fromMap(note));
                            print("Nome do tipo items2 = " + items2[0].tipo);//busca o nome do tipo pelo id retornado do webservice
                          });
                        });
                      });
                      if(item.status == "DEVOLVIDO"){
                        return showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Text('Deseja Editar uma despesa?',style: TextStyle(color: Colors.red),),
                            content: Icon(Icons.edit,color: Colors.grey,),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  print("Clicou não");
                                  Navigator.of(context).pop(false);//Nada faz e fica na mesma tela
                                  //Get.offAndToNamed("/despRecu?device=phone&visualizada=sim&id=${_id}&nome=${_nome}");
                                },
                                child: Text('Não',style: TextStyle(color: Colors.red),),
                              ),
                              FlatButton(
                                onPressed: () {
                                  print("Clocou sim!!!!!");
                                  Navigator.of(context).pop(false);//Fecha o diálogo e fica na mesma tela!
                                  Get.toNamed("/editaDespesa?device=phone&_id_DespesaRecu=${item.id}&_nome_CidadeRecu=${item.idCidade}&codigoCidade=${codigosCidade[position]}"
                                      "&id_TipoRec=${item.idTipoDespesa}&_valorRecu=${item.valor}&image=${item.nomeImagem}&id=${_id}&nome_tipo=${items2[1-1].tipo}&obs=${item.observacao}");
                                },
                                child: Text('Sim',style: TextStyle(color: Colors.green),),
                              ),
                            ],
                          ),
                        ) ??
                            false;
                        /*Get.toNamed("/editaDespesa?device=phone&_id_DespesaRecu=${item.id}&_nome_CidadeRecu=${item.idCidade}&codigoCidade=${codigosCidade[position]}"
                            "&id_TipoRec=${item.idTipoDespesa}&_valorRecu=${item.valor}&image=${item.nomeImagem}&id=${_id}&nome_tipo=${items2[1-1].tipo}&obs=${item.observacao}");

                        print("-------------Testes da chamada de tela editaDespesa com passagem de parâmetro TelaHistoricoDespesa GestureDetector linha 527 ------");
                        print("Nome da Imagem no clique do card:-----  ${item.nomeImagem}");
                        print("idUuário no clique do card:-----------  ${_id}");
                        print("id da Despesa para envio :------------  ${item.id}");
                        print("Tipo no clique do card:---------------  ${items2[0].tipo}");
                        print("id  TipoDesp para envio :-------------  ${item.idTipoDespesa}");
                        print("Cidade no clique do card:-------------  ${item.idCidade}");
                        print("Id da Cidade no clique :--------------  ${codigosCidade[position]}");
                        print("Valor da despesa para envio :---------  ${item.valor}");
                        print("Obs da despesa para envio :-----------  ${utf8.decode(item.observacao.toString().codeUnits)}");
                        print("Obs da kmFinal :----------------------  ${item.kmFinal}");
                        print("Obs da kmFinal :----------------------  ${item.kmFinal == "" ? "Vazio":"Null"}");
                        print(" -------------------------------------  ${item.data}");
                        print("------------------------------------------------------------------------------------------------------------------------------");*/

                      }else{
                        Get.snackbar("Não permitido!", "somente devolvidas para editar",colorText: Colors.white,snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red);
                      }
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.grey[100],
                              child: Text("${items[position].status}",
                                //textAlign: TextAlign.start,envi
                                style: TextStyle(
                                  fontSize: font2,
                                  //color: items[position].status == "DEVOLVIDO" ? Colors.red : Colors.green,
                                  color: items[position].status == "DEVOLVIDO" ? Colors.deepOrangeAccent : items[position].status == "ENVIADO" ? Colors.blueGrey : items[position].status == "APROVADO" ? Colors.lightBlueAccent:Colors.green,
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          //Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              /*Container(
                                    width: MediaQuery.of(context).size.width/17,
                                  ),*/
                              Expanded(
                                child: Container(
                                  //color: Colors.black12,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text("CIDADE: ",textAlign: TextAlign.start,style: TextStyle(color: lblColor,fontSize: font),),
                                            Flexible(child: Text("${items[position].idCidade}",textAlign: TextAlign.start,style: TextStyle(color: txtColor,fontSize: font),)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text("Tipo: ",textAlign: TextAlign.start,style: TextStyle(color: lblColor,fontSize: font),),
                                            Text("${items3[int.parse(items[position].idTipoDespesa)-1].tipo}",textAlign: TextAlign.start,style: TextStyle(color: txtColor,fontSize: font),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.yellow,
                                width: MediaQuery.of(context).size.width/9,
                              ),
                              Expanded(
                                child: Container(
                                  //color: Colors.black12,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text("DATA: ",textAlign: TextAlign.start,style: TextStyle(color: lblColor,fontSize: font),),
                                            Text("${items[position].data}",textAlign: TextAlign.start,style: TextStyle(color: txtColor,fontSize: font),),
                                            //DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(${items[position].data});
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text("VALOR: R\$ ",textAlign: TextAlign.start,style: TextStyle(color: lblColor,fontSize: font),),
                                            Text("${items[position].valor}",textAlign: TextAlign.start,style: TextStyle(color: txtColor,fontSize: font),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),



                          //Text("Cidade: ${items4[0].nomeMunicipio}"),
                          Container(
                            //color: Colors.black26,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Obs:",style: TextStyle(color: lblColor),),
                                ),
                                Expanded(child: Container(child: Text(" ${utf8.decode(items[position].observacao.toString().codeUnits)}",textAlign: TextAlign.start,style: TextStyle(color: txtColor,fontSize: font),))),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Resp.Gestor:",style: TextStyle(color: lblColor),),
                                ),
                                Expanded(child: Container(child: Text("${items[position].obsRetorno}",textAlign: TextAlign.start,style: TextStyle(color: Colors.red,fontSize: font),))),
                              ],
                            ),
                          ),
                          Text("id : ${items[position].id}",style: TextStyle(color: Colors.grey[300]),)
                          //Text("Km Inicial: ${items[position].kmInicial}"),
                          //Text("Id do Tipo: ${items[position].idTipoDespesa}"),
                        ],
                      ),
                    ),


                    /*Card(
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
                                  child: Text("${items[position].status}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      //color: items[position].status == "DEVOLVIDO" ? Colors.red : Colors.green,
                                      color: items[position].status == "DEVOLVIDO" ? Colors.red : items[position].status == "ENVIADO" ? Colors.blue : Colors.green,
                                    ),
                                  ),
                                  width: 290,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Icon(items[position].status == "DEVOLVIDO" ? Icons.report_problem : items[position].status == "ENVIADO" ? Icons.access_time : Icons.check_circle,color: items[position].status == "DEVOLVIDO" ? Colors.red : items[position].status == "ENVIADO" ? Colors.blue : Colors.green,)
                                ),
                              ],
                            ),
                            Text("DATA: ${items[position].data}"),
                            Text("Tipo: ${items3[int.parse(items[position].idTipoDespesa)-1].tipo}"),
                            Text("VALOR: R\$ ${items[position].valor}"),
                            Text("CIDADE: ${items[position].idCidade}"),
                            //Text("Cidade: ${items4[0].nomeMunicipio}"),
                            //Text("OBS DA DESPESA: ${utf8.encode(items[position].observacao)}"),
                            Text("OBSERVAÇÃO: ${items[position].observacao}"),
                            Text("OBSERVAÇÃO: ${items[position].obsRetorno}"),
                            //Text("Id do Tipo: ${items[position].idTipoDespesa}"),

                          ],
                        ),
                      ),
                    ),*/
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


  @override
  void initState() {
    super.initState();
    //busca tipos
    db.getAllTiposDesp().then((notes) {
      setState(() {
        notes.forEach((note) {
          items3.add(TiposDespesa.fromMap(note));
          for(var x in items3){
            print(" Itens3 no InitState " + x.toString());
          }
        });
      });
    });
    //Fim busca tipos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
              onPressed: (){Navigator.pop(context);}
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search),
                onPressed: ()async{
                  await _carregaDespRecu("","","");
                  print("------------------- ${items.length}");
                  if(items.isEmpty){
                    Get.snackbar("", "Favor escolher Data inicial e Final!",colorText: Colors.red ,snackPosition: SnackPosition.TOP,backgroundColor: Colors.white,isDismissible: true,
                      dismissDirection: SnackDismissDirection.HORIZONTAL,
                      showProgressIndicator: true,);
                  }
                }
            )
          ],
          title: Text("Listar Despesas"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Visibility(
                visible: _qtdeDesp > 0,
                child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(" ${_qtdeDesp} Despesa(s)",style: TextStyle(color: Colors.lightBlue,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center))
            ),
            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //---------------------------------------------------------BTN
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: RaisedButton(color: Colors.grey[100],child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Aprovadas",style: TextStyle(color: Colors.lightBlueAccent))
                      ],
                    ),onPressed: (){
                      _carregaDespRecu("aprovado","sim","sim");
                      /* final datapt1 = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeIni);
                      _vardataPT_Ini = _dateTimeIni.toString(); // aqui a vardata recebe a data formatada pelo código acima*/
                      setState(() {
                        //txtDataIni = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeIni);
                      });
                    }),
                  ),
                  //---------------------------------------------------------BTN
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: RaisedButton(color: Colors.grey[100],child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Pagas",style: TextStyle(color: Colors.green),)
                      ],
                    ),onPressed: (){
                      _carregaDespRecu("pago", "sim" , "sim");
                    }),
                  ),
                  //---------------------------------------------------------BTN
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: RaisedButton(color: Colors.grey[100],child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Recusadas",style: TextStyle(color: Colors.deepOrange),)
                      ],
                    ),onPressed: (){
                      _carregaDespRecu("devolvido", "nao", "sim");
                      /* final datapt2 = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeFinal);
                      _vardataPT_Final = _dateTimeFinal.toString(); // aqui a vardata recebe a data formatada pelo código acima*/
                      setState(() {
                        //txtDataFinal = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeFinal);
                      });
                    }),
                  ),

                ],
              ),
            ),
            getCardsListView()
          ],
        )
    );
  }
}
//Regra:
/*
Após vizualizar uma despesa solicitada nos botões
Aprovadas e ou Pagas, será setado com o número '1' no banco no campo
'vizualizado',
 Isso acontece enviando um 'sim' no parãmetro 'visu' da função carregaDespRecu.
 */

