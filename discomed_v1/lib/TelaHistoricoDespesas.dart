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
import 'DespesaModel.dart';
import 'TelaLoginNova.dart';
import 'Cores.dart';


class TelaDespRecusada extends StatefulWidget {
  @override
  _TelaDespRecusadaState createState() => _TelaDespRecusadaState();
}

const String MIN_DATETIME = '2019-01-01';
const String MAX_DATETIME = '2021-11-25';
const String INIT_DATETIME = '2019-05-17';
const double font = 13;
const double font2 = 15;

class _TelaDespRecusadaState extends State<TelaDespRecusada> {

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
  String _alerta = Get.parameters['alerta'];
  String _idDespesa = "";
  int _qtdeDesp = 0;
  TextEditingController _textEditingControllerIni = new TextEditingController();
  TextEditingController _textEditingControllerFin = new TextEditingController();
  String _vardataPT_Ini;
  String _vardataPT_Final;
  String txtDataIni = "Data Inicial";
  String txtDataFinal = "Data Final";
  Color lblColor = Colors.grey[500];
  Color txtColor = Colors.black;
  List codigosCidade = new List();





  String criptografa(String cryp)  {
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
  }//func para dcriptografar


  EnviaParametro(String _corpo_json) async {
    //ENVIA TEXTO CRIPTOGRAFADO E DESCRIPTOGRAFA RETORNO
    String url = Urls.url;
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
      //aqui recebe o response descriptografando e decodificando para json
      Map<String ,dynamic> retorno = json.decode(decrip(response.body).substring(3));
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      //mapeia para saber o conteúdo da ms e printar "+b"
      return "Erro: "+b;
    }
    else {
      print("Else EnviaParametro" + decrip(utf8.decode(response.body.codeUnits)).substring(3));
      return  decrip(response.body).substring(3);
    }
  }

  Future <List<Despesa>> _carregaDespRecu() async{
    //List<TiposDespesa> cidades = new List();

    String _corpo_json = jsonEncode(<String, String>{
      'modulo':"ZGVzcGVzYXNBdGl2YXM=",
      'id': _id,
      'visualizada': _recebeVisualizada,
      'dataIni':"${_dateTimeIni}",
      'dataFinal': "${_dateTimeFinal}",
      'status': "",
      'alerta': "",
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
      print("Entrou no else carrega despRecusadas\n");
      //print("Aqui" + dados);

      //----------------------------------------------------------------------1
      //criei um mapa com a variável dados, que recebe o retorno, do método envia parâmetro.Dados retornados do wed service
      Map<String ,dynamic> retorno2 = json.decode(dados);
      String st = retorno2["status"].toString();//status do response.boby
      print("Status =  ${st}");
      msg = retorno2["msg"];// msg é uma lista passada na variável dados, que é o retorno do response body
      //----------------------------------------------------------------------1
      print(" = msg = ${msg.toString()}");
      //List<Despesa> lista;
      //Aqui converte a lista para o método fromJson da Clase Despesa
      items = msg.map<Despesa>((json) => Despesa.fromJson(json)).toList();//aqui cria uma lista e converte o código de Json para uma Lista
      utf8.decode(items.toString().codeUnits);//decodifica a lista
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>Teste para utf8>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>linha 146 TelaHistoricoDespesas");
      for(var x in items){
        var obsnova = utf8.decode(x.observacao.toString().codeUnits);
        print("Nova:  " + obsnova);
        print("Id da Cidade: ${x.idCidade}");
      }
      //items = lista;
      _qtdeDesp = await items.length;
      print("Quantidade de Despesas: ${items.length}");

      //----------------------------------------------------------------------2
      //Laço para trocar o idCidade  recebido na mensagem pelo nome da cidade para exibir ao usuário
      for(var data in items){
        //pega o nome da cidade pelos id's
        db.getCidadesforId(int.parse(data.idCidade)).then((notes) {
          setState(() {
            notes.forEach((note) {
              items4.add(Cidades.fromMap(note));
              //print(" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Items4 ${note}");
            });
            for(var cid in items4){
              //print("############${cid.nomeMunicipio}");
              data.idCidade = cid.nomeMunicipio;
            }
          });
        });
        codigosCidade.add(data.idCidade);
        print("((((((((((((((()))))))))))))))))))))");
        print("********************** Status:${data.status} ID: ${data.id} Despesa:${data.valor} Data ${data.data} id Cidade: ${data.idCidade} Id TipoDesp ${data.idTipoDespesa} xxx ${utf8.decode(data.observacao.toString().codeUnits)}");
      }
      //----------------------------------------------------------------------2
      setState(() {
        _msgServidor = st;
        _dadosCarregados = msg.toString();
      });
    }
    return items;
  }
  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
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
      print ("Mensagem no if método carregaDesprecu ${dados}");
    }
    else  {
      //tratar para decodificar json
      //print (dados);
      print("Entrou no else carrega despRecusadas\n");
      print("Aqui" + dados);
      //cria um mapa com a variável dados, que recebe o retorno, do método envia parâmetro. Que são os dados da mensagem!
      Map<String ,dynamic> retorno2 = json.decode(dados);
      String st = retorno2["status"].toString();//status do response.boby
      print("Status =  ${st}");
      msg = retorno2["msg"];// body do response.body
      print("msg = ${msg.toString()}");
    }
  }

  //------------------------------------------------------------------------------------

  /*DateTimePickerLocale _locale = DateTimePickerLocale.pt_br;
  List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;
  String _format = 'dd-MM-yyyy';
  DateTime _dateTimeIni;
  DateTime _dateTimeFinal;*/



  /*void _showDatePicker1() {
    DatePicker.showDatePicker(
      context,
      onMonthChangeStartWithFirstDate: false,
      pickerTheme: DateTimePickerTheme(
        //showTitle: _showTitle,
        confirm: Text('OK', style: TextStyle(color: Colors.red)),
        cancel: Text('Cancel', style: TextStyle(color: Colors.red)),
      ),
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: _dateTimeIni,
      dateFormat: _format,
      locale: DateTimePickerLocale.pt_br,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTimeIni = dateTime;
          final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeIni);
          _vardataPT_Ini = datapt; // aqui a vardata recebe a data formatada pelo código acima
          txtDataIni = _vardataPT_Ini;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTimeIni = dateTime;
          txtDataIni = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeIni);
        });
      },
    );
  }*/

  /*void _showDatePicker2() {
    DatePicker.showDatePicker(
      context,
      onMonthChangeStartWithFirstDate: false,
      pickerTheme: DateTimePickerTheme(
        //showTitle: _showTitle,
        confirm: Text('OK', style: TextStyle(color: Colors.red)),
        cancel: Text('Cancel', style: TextStyle(color: Colors.red)),
      ),
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: _dateTimeFinal,
      dateFormat: _format,
      locale: DateTimePickerLocale.pt_br,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTimeFinal = dateTime;
          final datapt2 = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeFinal);
          _vardataPT_Final = datapt2; // aqui a vardata recebe a data formatada pelo código acima
          txtDataFinal = _vardataPT_Final;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTimeFinal = dateTime;
          txtDataFinal = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeFinal);
        });
      },
    );
  }*/

  //--------------------------------------------------------------------------------------------------

  DateTime _dateTimeIni;
  DateTime _dateTimeFinal;


  void _showDataPickerIni(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Container(
            height: 300,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlatButton(child: Text("Cancel",style:TextStyle(color: Colors.deepOrange)),onPressed: (){
                      Navigator.pop(context);
                    },),
                    //Text(dataText),
                    FlatButton(child: Text("Ok",style:TextStyle(color: Colors.green),),onPressed: (){
                      setState(() {
                        final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeIni);
                        _vardataPT_Ini = datapt; // aqui a vardata recebe a data formatada pelo código acima
                        //txtData = _date.toString();
                        txtDataIni = _vardataPT_Ini;
                      });
                      Navigator.pop(context);
                    },
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                  child: Container(
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle:
                          TextStyle(color: Colors.black,fontSize: 15),
                        ),
                      ),
                     child: CupertinoDatePicker(
                       initialDateTime: DateTime.now(),
                       onDateTimeChanged:(DateTime newDate){
                         setState(() {
                           _dateTimeIni = newDate;
                           final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeIni);
                           _vardataPT_Ini = datapt; // aqui a vardata recebe a data formatada pelo código acima
                           txtDataIni = _vardataPT_Ini;

                         });
                       } ,
                       use24hFormat: true,
                       minimumYear: 2019,
                       maximumYear: 2028,
                       mode: CupertinoDatePickerMode.date,
                     ),
                    )
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  void _showDatePickerFinal(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Container(
            height: 300,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlatButton(child: Text("Cancel",style:TextStyle(color: Colors.deepOrange)),onPressed: (){
                      Navigator.pop(context);
                    },),
                    //Text(dataText),
                    FlatButton(child: Text("Ok",style:TextStyle(color: Colors.green),),onPressed: ()async{
                      setState(() {
                        final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeFinal);
                        _vardataPT_Final = datapt; // aqui a vardata recebe a data formatada pelo código acima
                        //txtData = _date.toString();
                        txtDataFinal = _vardataPT_Final;
                      });
                      Navigator.pop(context);
                      if( _dateTimeFinal == null || _dateTimeIni == null){
                        Get.snackbar("", "Favor escolher Data inicial e Final!",colorText: Colors.red ,snackPosition: SnackPosition.TOP,backgroundColor: Colors.white,isDismissible: true,
                          dismissDirection: SnackDismissDirection.HORIZONTAL,
                          showProgressIndicator: true,);
                      }else{
                        await _carregaDespRecu();
                        print("------------------- ${items.length}");
                        print("--------Inicial------------${_dateTimeIni}");
                        print("--------Final------------${_dateTimeFinal}");
                        print("Else Carrega despesas TelaDespRecusada");
                      }
                    },
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                  child: Container(
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle:
                            TextStyle(color: Colors.black,fontSize: 15),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          initialDateTime: DateTime.now(),
                          onDateTimeChanged:(DateTime newDate){
                            setState(() {
                              _dateTimeFinal = newDate;
                              final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeFinal);
                              _vardataPT_Final = datapt; // aqui a vardata recebe a data formatada pelo código acima
                              txtDataFinal = _vardataPT_Final;

                            });
                          } ,
                          use24hFormat: true,
                          minimumYear: 2019,
                          maximumYear: 2028,
                          mode: CupertinoDatePickerMode.date,
                        ),
                      )
                  ),
                )
              ],
            ),
          );
        }
    );
  }


  Future<bool> _showDialogDeleta(BuildContext context,String item) {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Deseja deletar uma despesa?',style: TextStyle(color: Colors.red),),
        content: Text('Obrigado!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              print("Clicou não");
              Navigator.of(context).pop(false);//Nada faz e fica na mesma tela
              //Get.offAndToNamed("/despRecu?device=phone&visualizada=sim&id=${_id}&nome=${_nome}");
              _carregaDespRecu();
            },
            child: Text('Não',style: TextStyle(color: Colors.red),),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);//Nada faz e fica na mesma tela
              _deletaDesp();
              _carregaDespRecu();//ATUALIZA A LISTA
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


  Widget getListaDespesas() {
    return items.isNotEmpty
        ? Expanded(
      child: ListView.builder(
          itemCount: items.length,
          padding: const EdgeInsets.all(1.0),
          itemBuilder: (context, position) {
            final item = items[position];
            return Dismissible(
              direction: DismissDirection.startToEnd,
              background: Container(
                color: Colors.red,
                child: Align(
                  alignment: Alignment(-0.9, 0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
              key: UniqueKey(),
              onDismissed: (direction){
                if(items[position].status == "APROVADO" || items[position].status == "PAGO" ){
                 Get.defaultDialog(title: "ATENÇÃO!",titleStyle: TextStyle(color: Colors.red), content: Text("Já Aprovada! Não pode deletar."));
                 _carregaDespRecu();//ATUALIZA A LISTA
                }else{
                  _showDialogDeleta(context,item.id);
                  _idDespesa = item.id;
                  print("'''''''''''''''''''''''''''''''''" + _idDespesa);
                }
                //_deletaDesp();
                //Get.offNamed("/index?device=phone&id=${_id} &nome=${_nome}");
                /*Scaffold
                    .of(context)
                    .showSnackBar(
                  SnackBar(
                    content:
                    Text(
                        " Despesa ${item.id} foi removida!"),
                  ),
                );*/
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
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Container(
                        //height: MediaQuery.of(context).size.height/5,
                        //height: 130,
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              /*Container(
                                alignment: Alignment.topRight,
                                //color: Colors.grey[200],
                                width: MediaQuery.of(context).size.width,
                                child: Icon(items[position].status == "DEVOLVIDO" ? Icons.report_problem :
                                items[position].status == "ENVIADO" ? Icons.access_time :
                                Icons.check_circle,color: items[position].status == "DEVOLVIDO" ? Colors.red :
                                items[position].status == "ENVIADO" ? Colors.blue : Colors.green,size: 17,),
                              ),*/
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

  void _limpaData(){
    _dateTimeIni = null;
    _dateTimeFinal = null;
  }


  @override
  void initState() {
    print("Alerta Alerta Alerta Alerta Alerta Alerta Alerta Alerta ${_alerta}" );

    super.initState();
    //busca tipos
    db.getAllTiposDesp().then((notes) {
      setState(() {
        notes.forEach((note) {
          items3.add(TiposDespesa.fromMap(note));
          //_wer = items[0].tipo;
        });
      });
    });
    //Fim busca tipos
  }
    
  //-----------------------Funções----------------------------

  static final Controller c = Get.find();// Controller para receber  as variáveis
//child:Text("Mensagem do servidor = " + _msgServidor +","+ c.id_Usuario)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corBckgScaffold, // cor do fundo bodycar
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
            //onPressed: ()=> Get.toNamed("/index?device=phone&nome=${_nome}&id=${_id}"),
            onPressed: (){
               //Get.toNamed("/index?device=phone&nome=${_nome}&id=${_id}");
              _limpaData();
              Navigator.pop(context);
              print(_dateTimeIni.toString() + _dateTimeFinal.toString());
            },
          ),
          //backgroundColor: Colors.white,
          //elevation: 1,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search,color: Colors.white,),
                onPressed: ()async{

              if( _dateTimeFinal == null || _dateTimeIni == null){
                Get.snackbar("", "Favor escolher Data inicial e Final!",colorText: Colors.red ,snackPosition: SnackPosition.TOP,backgroundColor: Colors.white,isDismissible: true,
                  dismissDirection: SnackDismissDirection.HORIZONTAL,
                  showProgressIndicator: true,);
              }else{
                await _carregaDespRecu();
                print("------------------- ${items.length}");
                print("--------Inicial------------${_dateTimeIni}");
                print("--------Final------------${_dateTimeFinal}");
                print("Else Carrega despesas TelaDespRecusada");
              }
            }
            )
          ],
          title: Text("Listar Despesas",style: TextStyle(color: corFontAppBar),),
        ),
        body:

      Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Visibility(
                visible: _qtdeDesp > 0,
                child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(" ${_qtdeDesp} Despesa(s)",style: TextStyle(color: Colors.lightBlue,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center))
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                /*GestureDetector(
                  onTap: (){
                    _showDatePicker1();
                    final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY,"pt_Br").format(_dateTimeIni);
                    _vardataPT_Ini = datapt; // aqui a vardata recebe a data formatada pelo código acima
                    setState(() {
                      txtDataIni = _vardataPT_Ini;
                    });
                  },
                  child: Container(
                    color: Colors.grey[100],
                    child: FlatButton.icon(
                        icon: Icon(Icons.date_range), label: Text(txtDataIni)
                    ),
                  ),
                ),*/

                /*GestureDetector(
                  onTap: (){
                    _showDatePicker2();
                    final datapt2 = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeFinal);
                    _vardataPT_Final = datapt2; // aqui a vardata recebe a data formatada pelo código acima
                    setState(() {
                      txtDataFinal = _vardataPT_Final;
                    });
                  },
                  child: Container(
                    color: Colors.grey[100],
                    child: FlatButton.icon(
                        icon: Icon(Icons.date_range), label: Text(txtDataFinal)
                    ),
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.all(8),
                  child: RaisedButton(color: Colors.blue[600],child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.date_range,color:Colors.white,),
                      Text(txtDataIni,style: TextStyle(color: Colors.white,fontSize: 12))
                    ],
                  ),onPressed: ()async{
                    _dateTimeIni = DateTime.now();
                    setState(() {
                      final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeIni);
                      _vardataPT_Ini = datapt; // aqui a vardata recebe a data formatada pelo código acima
                      //txtData = _date.toString();
                      txtDataIni = _vardataPT_Ini;
                    });
                    _showDataPickerIni(context);
                    /*_showDatePicker1();
                    final datapt1 = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeIni);
                    _vardataPT_Ini = _dateTimeIni.toString(); // aqui a vardata recebe a data formatada pelo código acima
                    setState(() {
                      //txtDataIni = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeIni);
                    });*/
                  }),
                ),
                Center(child: Text("até",style: TextStyle(color: Colors.deepOrange,fontSize: 12),)),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: RaisedButton(color: Colors.blue[600],child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.date_range,color: Colors.white,),
                      Text(txtDataFinal,style: TextStyle(color: Colors.white,fontSize: 12),)
                    ],
                  ),onPressed: (){
                    _dateTimeFinal = DateTime.now();
                    setState(() {
                      final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeFinal);
                      _vardataPT_Final = datapt; // aqui a vardata recebe a data formatada pelo código acima
                      //txtData = _date.toString();
                      txtDataFinal = _vardataPT_Final;
                    });
                    _showDatePickerFinal(context);
                    /*_showDatePicker2();
                    final datapt2 = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeFinal);
                    _vardataPT_Final = _dateTimeFinal.toString(); // aqui a vardata recebe a data formatada pelo código acima
                    setState(() {
                      //txtDataFinal = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTimeFinal);
                    });*/
                  }),
                ),
              ],
            ),
            getListaDespesas()
          ],
        )
    );
  }
}





