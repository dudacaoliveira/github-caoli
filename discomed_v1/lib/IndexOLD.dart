import 'dart:convert';

import 'package:discomedv1/ModelsKmRodado/LocalEsp.dart';
import 'package:discomedv1/TelaDespesa.dart';
import 'package:discomedv1/TelaLocais.dart';
import 'package:discomedv1/Urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sqflite/sqflite.dart';
import 'CidadesModel.dart';
import 'ConexaoBd.dart';
import 'Criptografia.dart';
import 'Home.dart';
import 'LocEspModel.dart';
import 'OfensorVistoriaModel.dart';
import 'SetorVistoriaModel.dart';
import 'StatusVistoriaModel.dart';
import 'TelaBuscaCidades2.dart';
import 'TelaLoginNova.dart';
import 'TipoVistoriaModel.dart';
import 'TiposModel.dart';
import 'UploadImageDemoOLD.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;
import 'dart:async';
import 'package:encrypt/encrypt.dart';
import 'Urls.dart';
import 'Cores.dart';




class Index extends StatefulWidget {

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  static final Controller c = Get.find();// Controller para receber  as variáveis
  int _qtdLista = 0;
  String imgSino = "img/logo1.png";
  String _tt = "";
  String _qtdeEnv = "";
  int _totalDesp = 0;
  final Color corIcon = Colors.blue;
  final Color corTextIcon = Colors.white70;
  String _id = Get.parameters['id'];
  String _nome = Get.parameters['nome'];
  List<TiposDespesa> listaTipos = new List();
  List<Cidades> listaCidades = new List();
  List<LocESp> listaLocEsp = new List();
   final double iconesize = 40;
  int ativoGlobal;
  final String _versaoInstalada = "2.0.2";
  String _vist = "";


  _showDialogcarregaTipos(){
    Get.defaultDialog(
      //onConfirm: () => Get.to(Other()),
      //onCancel: () => print("Cancelado"),
      buttonColor: Colors.blue,
      title: "Sucesso!",
      //textConfirm: "Confirma?",
      confirmTextColor: Colors.white,
      middleText: "Tipos carregados",
      textCancel: "Ok",
    );
  }

  _showDialogcarregaCidades(){
    Get.defaultDialog(
      //onConfirm: () => Get.to(Other()),
      //onCancel: () => print("Cancelado"),
      buttonColor: Colors.blue,
      title: "Sucesso!",
      //textConfirm: "Confirma?",
      confirmTextColor: Colors.white,
      middleText: "Cidades carregadas",
      textCancel: "Ok",
    );
  }

  Future <String> _carregaLocEsp() async{
    Conexao con = new Conexao();
    String _corpo_json = jsonEncode(<String, String>{
      'modulo':"cmV0b3JuYUNsaWVudGVz",
      //'busca':"cardiologia"
    });

    //envia corpo json webservice
    String dados = await EnviaParametro2(_corpo_json);
    List msg = new List();

    if (dados.substring(0,0) == "E") {
      print ("Mensagem no if ${dados}");
    }
    else  {
      //tratar para decodificar json
      //print (" wwwwww " + dados);
      print("Entrou no else carrega Locais *** Específicos TelaConfg\n");
      Map<String ,dynamic> retorno = json.decode(dados);
      String st = retorno["status"].toString();
      //print(st);
      //print("Status =  ${st}");
      msg = retorno["msg"];
      //print("msg = ${msg.toString()}");

      List<LocESp> lista;//cria lista do tipo desejado
      lista = msg.map<LocESp>((json) => LocESp.fromJson(json)).toList();//aqui cria uma lista e converte o código de Json para uma Lista
      print("Quantidade de LocaisEsp: ${lista.length}");
      for(var data in lista){
        //print("${data.id }  ${data.nome}");
      }
      Database db2 = await con.recuperarBanco();
      for(var data in lista){
        print("ID: ${data.id} Local Esp:${data.nome}");
        con.salvarLocalEsp(data.id,data.nome,db2);
      }
      //_showDialogcarregaTipos();
    }
  }


  Future <String> _carregaCidades() async{
    Conexao con = new Conexao();
    List<Cidades> cidades = new List();
    String _corpo_json = jsonEncode(<String, String>{
      'modulo':"cmV0b3JuYU11bmljaXBpb3M="
    });

    //envia corpo json webservice
    String dados = await EnviaParametro(_corpo_json);
    List msg = new List();

    if (dados.substring(0,0) == "E") {
      //print ("Dados no if ${dados}");
    }
    else  {
      //tratar para decodificar json
      //print (dados);
      print("Entrou no else\n");
      Map<String ,dynamic> retorno2 = json.decode(dados);
      String st = retorno2["status"].toString();
      print("Status =  ${st}");
      msg = retorno2["msg"];
      List<Cidades> lista;
      lista = msg.map<Cidades>((json) => Cidades.fromJson(json)).toList();//aqui cria uma lista e converte o código de Json para uma Lista
      //print("Quantidade de cidades: ${lista.length}");
      /*lista.forEach((element) => {
        //print("Cód:${element.uf} UF:${element.nomeUf} Cidade: ${element.nomeMunicipio}")
        //con.salvarCidade(element.uf, element.nomeUf, element.municipio, element.codMunicipioCompleto, element.nomeMunicipio)
      });*/
      Database db1 = await con.recuperarBanco();
      for(var cid in lista){
        print("Cód:${cid.uf} UF:${cid.nomeUf} Cidade: ${cid.nomeMunicipio}");
        con.salvarCidade(cid.uf, cid.nomeUf, cid.municipio, cid.codMunicipioCompleto, cid.nomeMunicipio,db1);

      }
      _showDialogcarregaCidades();
    }
  }

  Future <String> _carregaTiposDesp() async{
    Conexao con = new Conexao();
    //List<TiposDespesa> cidades = new List();
    String _corpo_json = jsonEncode(<String, String>{
      'modulo':"cmV0b3JuYVRpcG9EZXNwZXNhcw=="
    });

    //envia corpo json webservice
    String dados = await EnviaParametro(_corpo_json);
    List msg = new List();


    if (dados.substring(0,1) == "E") {
      print ("Mensagem no if ${dados}");
    }
    else  {
      //tratar para decodificar json
      //print (dados);
      print("Entrou no else carrega tipos\n");
      Map<String ,dynamic> retorno2 = json.decode(dados);
      String st = retorno2["status"].toString();
      print("Status =  ${st}");
      msg = retorno2["msg"];
      print("msg = ${msg.toString()}");
      List<TiposDespesa> lista;
      lista = msg.map<TiposDespesa>((json) => TiposDespesa.fromJson(json)).toList();//aqui cria uma lista e converte o código de Json para uma Lista
      print("Quantidade de Tipos: ${lista.length}");

      Database db2 = await con.recuperarBanco();
      for(var data in lista){
        print("ID: ${data.id} TipoDespesa:${data.tipo}");
        con.salvarTiposDesp(data.tipo,db2);
      }
      _showDialogcarregaTipos();
    }
  }


  Future<bool> _exitApp(BuildContext context) {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Deseja sair do Aplicativo?'),
        content: Text('Obrigado!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              print("Clicou não");
              //Navigator.of(context).pop(false);//Nada faz e fica na mesma tela
              Get.offAllNamed("/index?device=phone&id=${_id} &nome=${_nome}");
            },
            child: Text('Não'),
          ),
          FlatButton(
            onPressed: () {
              Conexao conL =  new Conexao();//Instacia objeto "con"
              conL.limpaTabelaUsuario();
              //SystemChannels.platform.invokeMethod('SystemNavigator.pop');// fecha o aplicativo
              Get.offAllNamed("/Login");
            },
            child: Text('Sim'),
          ),
        ],
      ),
    ) ??
        false;
  }

  EnviaParametro2(String _corpo_json) async {
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

    if(decrip(response.body).substring(0,3)== '01.') {
      Map<String ,dynamic> retorno = json.decode(decrip(response.body).substring(3));
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      //mapeia para saber o conteúdo da ms e printar "+b"
      return "Erro: "+b;
    }
    else {
      return  decrip(response.body).substring(0);
    }
  }

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

    });

    if(decrip(response.body).substring(0,3)== '01.') {
      Map<String ,dynamic> retorno = json.decode(decrip(response.body).substring(3));
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      print("Status Envia parametro =  ${c}");
      print("msg Envia parametro =  ${b}");

      //mapeia para saber o conteúdo da ms e printar "+b"
      return "Erro: "+b;
    }
    else {
      print("Else EnviaParametro" + decrip(response.body).substring(3));
      return  decrip(response.body).substring(3);
    }
  }

  Future <String> _carregaDespRecuIndex() async{

    String _corpo_json = jsonEncode(<String, String>{
      'modulo':"ZGVzcGVzYXNBdGl2YXM=",
      'id': c.id_Usuario,

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
      //cria um mapa com a variável dados, que recebe o retorno, do método envia parâmetro. Que são os dados da mensagem!
      Map<String ,dynamic> retorno2 = json.decode(dados);
      String st = retorno2["status"].toString();//status do response.boby
      msg = retorno2["msg"];// body do response.body
      print("Status =  ${st}");
      print("msg = ${msg.toString()}");
      int qtd  = 0;
      qtd = retorno2["qtd"];
      _qtdLista = retorno2["qtd"];
      print("Quantidade da lista Despesas Recusadas ${qtd}");

      if(_qtdLista > 0){
        //_showDialog();
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!true ${_qtdLista}" );

      }else{
        //
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!false ${_qtdLista}");

      }
    }
  }

    void showVersao(){
        Get.defaultDialog(
            title: "A sua versão está desatualizada!",
            middleText: "Favor procurar a TI",
            middleTextStyle: TextStyle(color: Colors.red),
            onCancel:(){},
            textCancel:"Ok",
      );
    }


    Future <String> _chamaAleraDespesas() async{

      String _corpo_json = jsonEncode(<String, String>{
        'modulo':"YWxlcnRhRGVzcGVzYXM=", //consulta status das despesas ao carregar
        'id': _id,
        'numVersao': _versaoInstalada,
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
        print("Entrou no else carrega Alerta\n");
        //cria um mapa com a variável dados, que recebe o retorno, do método envia parâmetro. Que são os dados da mensagem!
        Map<String ,dynamic> retorno2 = json.decode(dados);
        String st = retorno2["status"].toString();//status do response.boby
        String al = retorno2["alerta"].toString();
        String devolvido = retorno2["devolvido"];// body do response.body
        String aprovado = retorno2["aprovado"];
        String pago = retorno2["pago"];
        String enviado = retorno2["enviado"];
        int ativo = int.parse(retorno2["ativo"]);
        ativoGlobal = ativo;
        String novaVersao = retorno2["novaVersao"];
        String vist = retorno2["vistoria_permissao"];
        _vist = vist;
        //String novaVersao = "2.1.0";

        //Verifica se o Usuário está ativo se ativo, carrega se desativado, desloga
        if(ativo != 1){
          print("Uauário desativado = ${ativo}");
          Get.offAndToNamed("/Login");
        }else{
          print("Uauário está ativo = ${ativo}");
          _tt = al;// mensagem true ou false do web server
          _qtdeEnv = aprovado;//despesas enviadas
          _totalDesp = (int.parse(devolvido)+int.parse(aprovado)+int.parse(pago));// soma as despesas do alerta para apresentar no ícone Histórico
          print("Usuário Ativo? ${ativo} " );
          print("Devolvidas " + devolvido);
          print("Aprovados " + aprovado);
          print("Pago " + pago);
          print("Enviado " + enviado);
          print("Status chamaAlerta =  ${st}");
          print("Alerta chamaAlerta = ${al}");
          print("Versão Instalada " + _versaoInstalada);
          print("Nova versão " + novaVersao);
          print("Vistoria Permissao ${vist}" );


          if(al == "true"){
            //_showDialog(enviado,aprovado,devolvido,pago); mostra alerta ao se logar com os quantitativos das despesas
          }else{
            print("Retornado false para não mostrar alerta! método _chamaAlerta!");
          }
          if(novaVersao != _versaoInstalada ){
            showVersao();
          }
        }
      }
      return ativoGlobal.toString();
    }

  _showDialog(String a,String b,String c,String d){
    Get.defaultDialog(
      backgroundColor: Colors.white,
      radius: 20,
      //onConfirm: () =>  Get.toNamed("/index"),
      onConfirm: (){
        Get.toNamed("/despRecu?device=phone&visualizada=sim");
        //Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
      },
      onCancel:  () {
        print("Clicou Não");
      },
      //onCancel: () => (){},
      //buttonColor: Colors.yellowAccent,
      title: "Enviado $a Aprovado $b Recusadas $c Pagas $d",
      titleStyle: TextStyle(
        fontSize: 16,
        color: Colors.red
      ),
      actions: [
       /* Icon(Icons.block,
          color: Colors.red,
        size: 25,
        )*/
      ],

      //textConfirm: "Confirma?",
      confirmTextColor: Colors.white,
      //cancelTextColor: Colors.green,
      middleText: "Deseja Verificar?",
      textCancel: "Não",
      textConfirm: "Sim",
    );
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

  Future <String> retorna()async{
    String subs = await _chamaAleraDespesas();
    print("Retorno da função ChamaAlertas " + subs + " do tipo:" +subs.runtimeType.toString());
    return subs;
  }

  void salvaTiposVistoria(){
    Conexao con = Conexao();
    con.salvarTipoVistoria(1, "NICHOS");
    con.salvarTipoVistoria(2, "CARROS");
    con.salvarTipoVistoria(3, "TEMPERATURA");
    con.salvarTipoVistoria(4, "ESTOQUE");
  }

  void salvaStatusVistoria(){
    Conexao con = Conexao();
    con.salvarStatusVistoria(1, "CONFORME", "C");
    con.salvarStatusVistoria(2, "ATENDE PARCIALMENTE", "AP");
    con.salvarStatusVistoria(3, "NÃO CONFORME", "NC");
    con.salvarStatusVistoria(4, "NÃO SE APLICA", "NA");

  }

  void salvaSetorVist(){
    Conexao con = Conexao();
    con.salvarSetorVistoria(1, "DIRETORIA");
    con.salvarSetorVistoria(2, "FATURAMENTO");
    con.salvarSetorVistoria(3, "TI");
    con.salvarSetorVistoria(4, "ESTOQUE");
    con.salvarSetorVistoria(5, "QUALIDADE");
    con.salvarSetorVistoria(6, "FINANCEIRO");
    con.salvarSetorVistoria(7, "SERVIÇOS GERAIS");
    con.salvarSetorVistoria(8, "RECEPÇAO");
    con.salvarSetorVistoria(9, "ÁREA TÉCNICA");
    con.salvarSetorVistoria(10, "VENDAS");
    con.salvarSetorVistoria(11, "GER.ADMINISTRATIVA");
    con.salvarSetorVistoria(12, "GER.COMERCIAL");
    con.salvarSetorVistoria(13, "GERENCIA CRM");
    print("Salvo dados da Vistoria" );
  }

  void salvaOfensorVist(){
    Conexao con = Conexao();
    con.salvarOfensorVistoria(1, "MESA");
    con.salvarOfensorVistoria(2, "GAVETA");
    con.salvarOfensorVistoria(3, "ALIMENTO");
    var msg = con.salvarOfensorVistoria(4, "TODOS");
  }

  @override
  Future<void> initState()  {
    super.initState();

     retorna();//Aqui chama o metodo _carregaDespRecuIndex();
     if(ativoGlobal == "1"){
       print("Certo no método retorna no initState do Index");
     }else{
       print("Errado no método retorna no initState do Index");
     }

    Conexao con = Conexao();//Abre uma conexão com O DB.

    //Testa se a tabela do banco é vazia e Carrega os dados da Api e grava no banco!
    con.getAllLocais().then((notes) {
      setState(() {
        notes.forEach((note) {
          listaLocEsp.add(LocESp.fromMap(note));
          //print(note);
        });
        if(listaLocEsp.isNotEmpty){
          print("Lista de hospitais carregada!!!");
        }else{
          print("Lista Vazia!!");
          _carregaLocEsp();
        }
        print(listaLocEsp.length);
      });
    });

    //Testa se a tabela do banco é vazia e Carrega os dados da Api e grava no banco!
    con.getAllCidades().then((notes){
      setState(() {
        notes.forEach((note) {
          listaCidades.add(Cidades.fromMap(note));
          //print(note.toString());
        });
        if(listaCidades.isNotEmpty){
          print("Lista Cidades carregada!");
        }else{
          _carregaCidades();
        }
      });
    });

    //Testa se a tabela do banco é vazia e Carrega os dados da Api e grava no banco!
    con.getTipos().then((notes) {
      setState(() {
        notes.forEach((note) {
          listaTipos.add(TiposDespesa.fromMap(note));
          //print(note.toString());
        });
        if(listaTipos.isNotEmpty){
          print("Lista Tipos Carregada!");
        }else{
          _carregaTiposDesp();
        }
      });
    });

    List<OfensorVistoria> listaOfensorVistoria = new List();
    List<SetorVistoria> listaSetorVistoria = new List();
    List<StatusVistoria> listaStatusVistoria = new List();
    List<TiposVistoria> listaTiposVistoria = new List();

    /*salvaOfensorVist();
    salvaSetorVist();
    salvaStatusVistoria();
    salvaTiposVistoria();*/

    con.BuscaOfensorVist().then((notes) {
      setState(() {
        notes.forEach((note) {
          listaOfensorVistoria.add(OfensorVistoria.fromMap(note));
          //print(note.toString());
        });
        if(listaOfensorVistoria.isNotEmpty){
          print("Lista OfensorVist Carregada!");
        }else{
          salvaOfensorVist();
        }
      });
    });

    con.BuscaTiposVist().then((notes) {
      setState(() {
        notes.forEach((note) {
          listaTiposVistoria.add(TiposVistoria.fromMap(note));
          //print(note.toString());
        });
        if(listaTiposVistoria.isNotEmpty){
          print("Lista TiposVist Carregada!");
        }else{
          salvaTiposVistoria();
        }
      });
    });

    con.BuscaSetorVist().then((notes) {
      setState(() {
        notes.forEach((note) {
          listaSetorVistoria.add(SetorVistoria.fromMap(note));
          //print(note.toString());
        });
        if(listaSetorVistoria.isNotEmpty){
          print("Lista SetorVist Carregada!");
        }else{
          salvaSetorVist();
        }
      });
    });

    con.BuscaStatusVist().then((notes) {
      setState(() {
        notes.forEach((note) {
          listaStatusVistoria.add(StatusVistoria.fromMap(note));
          //print(note.toString());
        });
        if(listaStatusVistoria.isNotEmpty){
          print("Lista StatusVist Carregada!");
        }else{
          salvaStatusVistoria();
        }
      });
    });

  }

  void _mudaIcone(){
    setState(() {
      _tt = "false";
    });
  }

  Widget layout1 (){
    return Container(
      padding: EdgeInsets.only(top: 30),
      height: 250,
      color: Colors.grey[800],
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                  onPressed: (){
                    Get.toNamed("/despRecu?device=phone&visualizada=sim&id=${_id}&nome=${_nome}");
                    setState(() {
                      _tt = "false";
                    });
                    //Get.toNamed("page")
                  },
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Icon(_tt == "false" ? Icons.report_problem : _tt == "true" ? Icons.access_time : Icons.check_circle,color: _tt == "DEVOLVIDO" ? Colors.red : _tt == "ENVIADO" ? Colors.blue : Colors.green,),
                      //Icon(_tt =='true' ? Icons.add_alert : Icons.developer_mode),
                      /*CircleAvatar(
                                  child: Text(_qtdeEnv),
                                  backgroundColor: Colors.white,
                                  //backgroundImage: Text(img),
                                  radius: 40,
                                ),*/
                      Visibility(
                        visible: _tt == "true",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              //child: Text("T"),
                              color: Colors.yellow,
                              width: 40,
                            ),
                            Container(
                              //child: Container(decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.only(topRight:Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10),)),child: Center(child: Text(_qtdeEnv,textAlign: TextAlign.end,style: TextStyle(color:Colors.red,fontSize: 12,fontWeight: FontWeight.bold),))),color: Colors.transparent,width: 17,height: 17,),
                                child:  Visibility(
                                  visible: _tt == "true",
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: CircleAvatar(
                                      minRadius: 8,
                                      backgroundColor: Colors.yellow,
                                      child: Text(_totalDesp.toString(),
                                        style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 12),),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      //Icon(Icons.add_alert,color: _tt == 'true'? Colors.red: Colors.white70,size: 40,),// aqui o sino altera a cor se _tt == true
                      Icon(Icons.notifications_none,color: corIcon,size: 40,),
                      Text("Histórico",style: TextStyle(color: corTextIcon),),
                    ],
                  )
              ),
              FlatButton(
                  onPressed: (){
                    Get.toNamed("/despesa?device=phone&id=${_id} &nome=${_nome}");
                    print("333333333333333333333333333333333${_nome}");
                  },
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.monetization_on,color: corIcon,size: 40
                      ),
                      Text("Despesa/KM",style: TextStyle(color: corTextIcon),),
                    ],
                  )
              ),
              FlatButton(
                  onPressed: (){
                    //Get.snackbar("", "Opção indisponível!",colorText: Colors.white ,snackPosition: SnackPosition.BOTTOM);
                    Get.to(TelaDespesa());
                  },
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.apps,color: corIcon,size: 40
                      ),
                      Text("Locais",style: TextStyle(color: corTextIcon),),
                    ],
                  )
              ),

            ],
          ),
          Container(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                  onPressed: (){Get.snackbar("", "Opção indisponível!",colorText: Colors.white ,snackPosition: SnackPosition.BOTTOM);},
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.import_contacts,color: corIcon,size: 40
                      ),
                      Text("Outros",style: TextStyle(color: corTextIcon),),
                    ],
                  )
              ),

              FlatButton(
                  onPressed: (){Get.snackbar("", "Opção indisponível!",colorText: Colors.white ,snackPosition: SnackPosition.BOTTOM);},
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.timeline,color:corIcon,size: 40
                      ),
                      Text("Gráficos",style: TextStyle(color: corTextIcon),),
                    ],
                  )
              ),
              FlatButton(
                  onPressed: (){Get.toNamed("/telaConfig");},
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.settings,color: corIcon,size: 40
                      ),
                      Text("Ajustes",style: TextStyle(color: corTextIcon),),
                    ],
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget layout3 (Color corIcon,Color corTextIcon){
    return Container(
      padding: EdgeInsets.only(top: 30),
      height: 250,
      color: Colors.grey[800],
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: FlatButton(
                    minWidth: 80,
                    height: 50,
                    onPressed: (){
                      Get.toNamed("/despRecu?device=phone&visualizada=sim&id=${_id}&nome=${_nome}");
                      setState(() {
                        _tt = "false";
                      });
                      //Get.toNamed("page")
                    },
                    child:Stack(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //Icon(_tt == "false" ? Icons.report_problem : _tt == "true" ? Icons.access_time : Icons.check_circle,color: _tt == "DEVOLVIDO" ? Colors.red : _tt == "ENVIADO" ? Colors.blue : Colors.green,),
                        //Icon(_tt =='true' ? Icons.add_alert : Icons.developer_mode),
                        /*CircleAvatar(
                                    child: Text(_qtdeEnv),
                                    backgroundColor: Colors.white,
                                    //backgroundImage: Text(img),
                                    radius: 40,
                                  ),*/
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(Icons.notifications_none,color: corIcon,size: 40,),
                        ),
                        Visibility(
                          visible: _tt == "true",
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: CircleAvatar(
                              minRadius: 8,
                              backgroundColor: Colors.red,
                              child: Text(_totalDesp.toString(),
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
                            ),
                          ),
                        ),
                        //Icon(Icons.add_alert,color: _tt == 'true'? Colors.red: Colors.white70,size: 40,),// aqui o sino altera a cor se _tt == true

                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text("Histórico",style: TextStyle(color: corTextIcon),),
                        ),
                      ],
                    )
                ),
              ),
              Container(
                child: FlatButton(
                  minWidth: 80,
                    height: 50,
                    onPressed: (){
                      Get.toNamed("/despesa?device=phone&id=${_id} &nome=${_nome}");
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(Icons.monetization_on,color: corIcon,size: 40
                        ),
                        Text("Despesa/KM",style: TextStyle(color: corTextIcon),),
                      ],
                    )
                ),
              ),
              FlatButton(
                  minWidth: 80,
                  height: 50,
                  onPressed: (){
                    //Get.snackbar("", "Opção indisponível!",colorText: Colors.white ,snackPosition: SnackPosition.BOTTOM);
                    //Get.to(TelaKilometragemNova());
                    Get.toNamed("/telaKmRodadoStepper?device=phone&id=${_id} &nome=${_nome}");
                  },
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.location_on,color: corIcon,size: 40
                      ),
                      Text("KM Rodado",style: TextStyle(color: corTextIcon),),
                    ],
                  )
              ),

            ],
          ),
          Container(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                  minWidth: 80,
                  height: 50,
                  onPressed: (){Get.toNamed("/telaHistoricoKm?device=phone&visualizada=sim&id=${_id}&nome=${_nome}");},
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.list,color: corIcon,size: 40
                      ),
                      Text("Histórico Km",style: TextStyle(color: corTextIcon),),
                    ],
                  )
              ),

              FlatButton(
                  minWidth: 80,
                  height: 50,
                  onPressed: (){Get.snackbar("", "Opção indisponível!",colorText: Colors.white ,snackPosition: SnackPosition.BOTTOM);},
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.timeline,color:corIcon,size: 40
                      ),
                      Text("Gráficos",style: TextStyle(color: corTextIcon),),
                    ],
                  )
              ),
              FlatButton(
                  minWidth: 80,
                  height: 50,
                  onPressed: (){Get.toNamed("/telaConfig");},
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.settings,color: corIcon,size: 40
                      ),
                      Text("Ajustes",style: TextStyle(color: corTextIcon),),
                    ],
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget layoutAtual (Color corBackGrid,Color corIcon,Color corTextIcon,Color corContainer,BuildContext context){
    final double fontSizeButton = MediaQuery.of(context).size.height*0.01;
    return Container(
      color: corContainer,
      height: MediaQuery.of(context).size.height/1.8, 
      //height: MediaQuery.of(context).size.height, //caso esteja com o SingleChildScrollView na Column do body
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                ElevatedButton(

                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255,255, 0, 0)),
                  ),
                  onPressed: (){
                    Get.toNamed("/despRecu?device=phone&visualizada=sim&id=${_id}&nome=${_nome}");
                    //_mudaIcone();
                    //Get.snackbar("", "Opção indisponível!",colorText: Colors.white ,snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.black);
                  }, child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timeline,size: iconesize,color: corFonte,),
                    Text("HISTÓRICO DESP.",style: TextStyle(color: corFonte,fontSize: MediaQuery.of(context).size.height*0.01)),
                  ],
                )
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 0, 128, 0)),
                  ),
                  onPressed: (){
                    Get.toNamed("/despesa?device=phone&id=${_id} &nome=${_nome}");
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.monetization_on,size: iconesize,color: corFonte,),
                      Text("DESPESA",style: TextStyle(color: corFonte,fontSize: fontSizeButton),),
                    ],
                  ) //
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 30, 144, 255)),
                  ),
                  onPressed: (){
                    Get.toNamed("/telaKmRodadoStepper?device=phone&id=${_id} &nome=${_nome}");
                  },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_car,
                          size: iconesize,
                          color: corFonte,
                        ),
                        Text("KM RODADO",style: TextStyle(color: corFonte,fontSize: fontSizeButton),),
                        Text("Carro Próprio",style: TextStyle(fontSize: 12,color: corFonte),),
                      ],
                    )),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 255, 191, 0)),
                  ),
                  onPressed: (){Get.toNamed("/telaHistoricoKm?device=phone&visualizada=sim&id=${_id}&nome=${_nome}");},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timelapse,
                          size: iconesize,
                          color: corFonte,
                        ),
                        Text("HISTÓRICO KM",style: TextStyle(color: corFonte,fontSize: fontSizeButton),),
                      ],
                    )),
                ElevatedButton(

                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Color.fromARGB(255,255, 100, 0)),
                    ),
                    onPressed: (){
                      if(_vist == "1"){
                        Get.toNamed("/telavistoria?device=phone&visualizada=sim&id=${_id}&nome=${_nome}");
                      }else{
                        Get.snackbar("Acesso negado!", "Só para Auditores!",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red);
                      }
                      //_mudaIcone();
                      //Get.snackbar("", "Opção indisponível!",colorText: Colors.white ,snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.black);
                    }, child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assistant_photo,size: iconesize,color: corFonte,),
                    Text("VISTORIA.",style: TextStyle(color: corFonte,fontSize: fontSizeButton),),
                  ],
                )
                ),
                ElevatedButton(

                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Color.fromARGB(255,128, 0, 128)),
                    ),
                    onPressed: (){
                      Get.toNamed("/telaComprovantes?device=phone&visualizada=sim&id=${_id}&nome=${_nome}");
                      //_mudaIcone();
                      //Get.snackbar("", "Opção indisponível!",colorText: Colors.white ,snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.black);
                    }, child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate,size: iconesize,color: corFonte,),
                    Text("Canhotos",style: TextStyle(color: corFonte,fontSize: fontSizeButton),),
                  ],
                )
                ),


                //Text("Teste",style: TextStyle(color: Colors.white),)

                /*ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: (){Get.toNamed("/telaConfig");},
                  child: Text("CONFIGURAÇÕES",style: TextStyle(color:Colors.black),),
                ),

                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.pink),
                  ),
                  onPressed: (){
                    Get.snackbar("", "Opção indisponível!",colorText: Colors.white ,snackPosition: SnackPosition.BOTTOM);
                  },
                  child: Text(""),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  void chamaTelaHistorico(){
    Get.toNamed("/telaHistoricoKm?device=phone&visualizada=sim&id=${_id}&nome=${_nome}");
  }

  //----------------------------------------------------------------Build------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
      appBar: AppBar(
        //leading: IconButton(icon: Icon(Icons.menu,color: Colors.white,), onPressed: (){Get.toNamed("/menu");}),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(_tt == 'true'  ? Icons.notifications_active : Icons.notifications_none),
              color: _tt == 'true' ? Colors.yellow : Colors.grey[800],
              onPressed: (){
              Get.toNamed("/despAlertas?device=phone&id=${_id}&nome=${_nome}");
                _mudaIcone();
          }),
          /*Visibility(
              visible: _tt == "true",
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  minRadius: 8,
                  backgroundColor: Colors.white,
                  child: Text(_qtdeEnv,
                  style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 12),),
                ),
              ),
              )*/
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Column(
          children: <Widget>[
            Shimmer.fromColors(child: Text("Olá! Bem vindo  ${_nome.toUpperCase()}.",
              style: TextStyle(
                //fontFamily: ,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.lightBlueAccent
              ),
            ),
                baseColor: Colors.white,
                highlightColor: Colors.green[100]
            ),
            Text("Despesas".toUpperCase(),style: TextStyle(fontSize: 13,color: Colors.white),),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              //versão 2.0.1 alteração de servidor
              child: Text("Versão 2.1.0",style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10
              ),
              ),
            )
          ],
        )
      ),
      /*drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Padding(padding: EdgeInsets.all (5),
          child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top:50,right: 20),
                      child: CircleAvatar(
                        backgroundColor: Colors.lightBlue,
                        backgroundImage: AssetImage('img/logo1.png'),
                        radius: 40,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 50),
                    child: Text("Opções",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black26
                      ),
                    ),
                    ),
                    //texto do drawer
                  ],
                ),
                Divider(),
                GestureDetector(
                  child: Container(
                      height: 70,
                    child: Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left:10,right: 20),
                            child: Icon(Icons.settings)),
                        Text(
                          "Configurações",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  ),
                  onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => TelaConfig()
                  ));
                  },
                ),
                Divider(),
                GestureDetector(
                  child: Container(
                    height: 70,
                      child: Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left:10,right: 20),
                              child: Icon(Icons.sim_card_alert,
                              color: Colors.red,
                              )
                          ),
                          Text(
                            "Alertas",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )
                  ),
                  onTap: (){
                    Get.toNamed("/despRecu?device=phone&visualizada=nao&id=${_id}");
                    //Navigator.pop(context);
                  },
                ),
                GestureDetector(
                  child: Container(
                      height: 70,
                      child: Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left:10,right: 20),
                              child: Icon(Icons.alarm_off,
                                color: Colors.red,
                              )
                          ),
                          Text(
                            "Sair",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )
                  ),
                  onTap: ()async{
                    _exitApp(context);
                  },
                ),
                Divider()
            ],
          ),
          ),
        ),
      ),*/
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                width:MediaQuery.of(context).size.width ,
                //height: MediaQuery.of(context).size.height/2.6,
                height: MediaQuery.of(context).size.height/5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin:Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors:[
                          Color(0xFF0000FF),
                          Color(0xFF0000FF),
                          Color(0xFF0000FF),
                          Color(0xFF0000FF),
                          Color(0xFF0011FF),
                          Color(0xFb0FAFFF)
                        ]
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Spacer(),
                    Align(
                        alignment:Alignment.center,
                        child: Image.asset("img/header.png", height: 150,)
                    ),

                  ],
                ),
              ),
            ),
            //layout3(Colors.blue,Colors.white),
            //layout2(context, corIcon, corTextIcon, Colors.white, Colors.black38),
            layoutAtual(Colors.blueGrey, corIconeMenu, corTextIcon, Colors.black45, context)
            /*Container(
              height: 10,
              color: Colors.transparent,
            ),*/
            //layout2(context,corIcon,corTextIcon,Colors.white12,Colors.grey[800],chamaTelaHistorico),
            /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 2,
                color: Colors.blue,
              ),
            ),*/

          ],
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: (){Get.toNamed("/menu");},
        child: Icon(Icons.menu,color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        );



        //com GridView
/*
      GridView.extent(maxCrossAxisExtent: 150,
      children: <Widget>[
        FlatButton(
            onPressed: (){},
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.home,color: Colors.white,
                ),
                Text("Home",style: TextStyle(color: Colors.white),),
              ],
            )
        ),
        FlatButton(
            onPressed: (){Get.toNamed("/despesa");},
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.monetization_on,color: Colors.white,
                ),
                Text("Despesa",style: TextStyle(color: Colors.white),),
              ],
            )
        ),
        FlatButton(
            onPressed: (){},
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.apps,color: Colors.white,
                ),
                Text("Outros",style: TextStyle(color: Colors.white),),
              ],
            )
        ),

        FlatButton(
            onPressed: (){Get.toNamed("/kilo");},
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.directions_car,color: Colors.white,
                ),
                Text("KM",style: TextStyle(color: Colors.white),),
              ],
            )
        ),

        FlatButton(
            onPressed: (){},
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.timeline,color: Colors.white,
                ),
                Text("Gráficos",style: TextStyle(color: Colors.white),),
              ],
            )
        ),
        FlatButton(
            onPressed: (){Get.toNamed("/telaConfig");},
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.settings,color: Colors.white,
                ),
                Text("Ajustes",style: TextStyle(color: Colors.white),),
              ],
            )
        ),
      ],*/



      //com Custom

      /*CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: <Widget>[
                    aqui os widgets
                ],
              ),
            ),
          ],
        ),*/

  }
}





Widget layout2(BuildContext context,Color corIcon,Color corTextIcon,Color corBackGrid,Color corContainer){
  return Container(
    color: corContainer,
    height: MediaQuery.of(context).size.height/2,
    child: CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: <Widget>[

              GestureDetector(
                  child: Container(
                      color: corBackGrid,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.notifications_none,color: corIcon),
                            color: Colors.white,
                            onPressed: null
                          ),
                          Text("Histórico2",style: TextStyle(color: corTextIcon),)
                        ],
                      )
                    //color: Colors.green[100],
                  ),
                  onTap: (){
                    Get.snackbar("", "Opção indisponível!",colorText: Colors.white ,snackPosition: SnackPosition.BOTTOM);
                  },
              ),
              GestureDetector(
                //onTap: _showDialogo,
                child: Container(
                    color: corBackGrid,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.monetization_on,color: corIcon,),
                          //color: Colors.white,
                          /*onPressed: (){
                                        _showDialogo();
                                      },*/
                        ),
                        Text("Despesas/Km",style: TextStyle(color: corTextIcon),)
                      ],
                    )
                  //color: Colors.green[100],
                ),
              ),
              GestureDetector(
                onTap: null,
                child: Container(
                    color: corBackGrid,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(Icons.apps,semanticLabel: "Locais",color:corIcon),
                        Text("Locais",style: TextStyle(color: Colors.white),)
                      ],
                    )
                  //color: Colors.green[100],
                ),
              ),
              Container(
                  color: corBackGrid,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.open_with,semanticLabel: "Outros",color: corIcon),
                      Text("Outros",style: TextStyle(color: corTextIcon),)
                    ],
                  )
                //color: Colors.green[100],
              ),
              Container(
                  color: corBackGrid,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.timeline,semanticLabel: "Gráficos",color: corIcon),
                      Text("Gráficos",style: TextStyle(color: corTextIcon),)
                    ],
                  )
                //color: Colors.green[100],
              ),
              Container(
                  color: corBackGrid,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.settings,semanticLabel: "Ajustes",color: corIcon),
                      Text("Ajustes",style: TextStyle(color: corTextIcon),)
                    ],
                  )
                //color: Colors.green[100],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}






//Modelo Antigo Com containers Despesa, KM etc...

/*
SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Image.asset("img/header.png"),
                ),
                Divider(),

                GestureDetector(
                  onTap: (){
                    Get.toNamed("/despesa");
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 1,bottom: 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top:1,right: 1),
                              child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: CircleAvatar(
                                  backgroundColor: Colors.orangeAccent,
                                  backgroundImage: AssetImage('img/moeda2.png'),
                                  radius: 40,
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 1,left: 10),
                              child: Text("INSERIR DESPESA",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),topRight: Radius.circular(20)),
                          color: Colors.white
                        //shape: BoxShape.circle
                      ),
                    ),
                  ),
                ),
                Divider(),
                GestureDetector(
                  onTap: (){
                    Get.toNamed("/kilo");
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 1,bottom: 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top:1,right: 1),
                              child: Padding(
                                padding: EdgeInsets.only(left: 20,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  backgroundImage: AssetImage('img/kilom.png'),
                                  radius: 40,
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 1,left: 10),
                              child: Text("INSERIR KM",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),topRight: Radius.circular(20)),
                          color: Colors.white
                        //shape: BoxShape.circle
                      ),
                    ),
                  ),
                ),
                Divider(),
                /*Visibility(
                  visible: _qtdLista == 0,
                    child: //_showDialog()
                  GestureDetector(
                      onTap: () {
                        Get.toNamed("/despRecu");
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 1,bottom: 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 120,
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(top:1,right: 1),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20,
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage(imgSino),
                                      radius: 40,
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 1,left: 10),
                                  child: Text("DESPESAS RECUSADAS",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),topRight: Radius.circular(20)),
                              color: Colors.white
                            //shape: BoxShape.circle
                          ),
                        ),
                      ),
                    ),
                )*/
              ],
            ),
          ),
        ),
*/
