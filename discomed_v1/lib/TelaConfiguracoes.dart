import 'dart:convert';
import 'package:discomedv1/ConexaoBd.dart';
import 'package:discomedv1/LocEspModel.dart';
import 'package:discomedv1/TiposModel.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;
import 'dart:async';
import 'CidadesModel.dart';
import 'Criptografia.dart';
import 'Urls.dart';

class TelaConfig extends StatefulWidget {

  @override
  _TelaConfigState createState() => _TelaConfigState();
}

class _TelaConfigState extends State<TelaConfig> {
  String _cidade;
  Conexao con = new Conexao();

  /*String criptografa(String cryp)  {
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
  }//func para dcriptografar*/

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

    if(decrip(response.body).substring(0,3)== '01.') {
      Map<String ,dynamic> retorno = json.decode(decrip(response.body).substring(3));
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      //mapeia para saber o conteúdo da ms e printar "+b"
      return "Erro: "+b;
    }
    else {
      return  decrip(response.body).substring(3);
    }
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

  Future <String> _getTables(Database db)async{
    var tableNames = (await db
        .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: false);
    print(tableNames);
  }

  listarLocaisEsp() async {
    Conexao con = Conexao();
    Database db = await con.recuperarBanco();
    String sql = "SELECT * FROM localEsp";
    List locais = await db.rawQuery(sql);
    //print da lista completa
    print("Locais = "+ locais.toString());
    //db.close();
  }

  Future listarLocaisFormat() async {
    Conexao con = Conexao();
    Database db = await con.recuperarBanco();
    String sql = "SELECT * FROM localEsp";
    var result = await db.rawQuery(sql);
    //print da lista completa
    List itens = new List();
    if (result.length != 0) {
      Map<String, dynamic> item = Map();
      for (var data in result) {
        item["id_locEsp"] = data['id_locEsp'];
        item["locEsp"] = data['locEsp'];
        itens.add(item);
        //print(itens[0]);
        print("Id: " + data['id_locEsp'].toString() + ", " + "Local: " + data['locEsp'].toString() );
      }
    } else {
      print("A Tabela  de Despesas está vazia!!!!");
    }
  }
 /* Future <String> _carregaCidades()async{

    String _corpo_json = jsonEncode(<String, String>{
      'modulo':"cmV0b3JuYU11bmljaXBpb3M="
    });

    String url = "http://discomed.com.br/webService/";
    final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8',
        },
        body: {
          'corpo': criptografa(_corpo_json)
        }
    );
    print("teste ${response.body}");
    //String a = decrip("Decrip aqui "+ response.body);
  }*/

//----------------------BD---------------------------------------------
 /* recuperarBanco() async {
    final caminhoBanco = await getDatabasesPath();
    final localBanco = join(caminhoBanco, "banco.db");
    var db = await openDatabase(
        localBanco,
        version: 1,
        onCreate: (db, dbVersaoRecente) {
          String sql = "CREATE TABLE enderecos(id INTEGER PRIMARY KEY AUTOINCREMENT, uf VARCHAR, nomeUf VARCHAR, municipio VARCHAR, codMunicipioCompleto VARCHAR, nomeMunicipio VARCHAR)";
          db.execute(sql);
        }
    );
    //print("aberto " + db.isOpen.toString());
    //db.close();
    return db;
  }*/


/*
  listarCidades() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM enderecos";
    List cidades = await db.rawQuery(sql);
    //print da lista completa
    print("Cidades = "+ cidades.toString());
    //db.close();
  }

  listarCidadesFormat() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM enderecos";
    List cidades = await db.rawQuery(sql);
    //print da lista completa
    for(var cid in cidades ){
      print("Id: " + cid['id'].toString() +", "+ cid['uf'] +" "+ cid['nomeUf'] +", "+ cid['nomeMunicipio'] +", "+ cid['municipio'] +", "+ cid['codMunicipioCompleto']);
    }
  }

  listarCidadesRS() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM enderecos where uf = '43' ";
    List cidades = await db.rawQuery(sql);
    //print da lista completa
    //print("Cidades = "+ cidades.toString());
    //print da lista editada
    for(var cid in cidades ){
      print("Id: " + cid['id'].toString() +", "+ cid['uf'] +" "+ cid['nomeUf'] +", "+ cid['nomeMunicipio'] +", "+ cid['municipio'] +", "+ cid['codMunicipioCompleto']);
    }
  }

  listarCidadesSC() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM enderecos where uf = '42' ";
    List cidades = await db.rawQuery(sql);
    //print da lista completa
    //print("Cidades = "+ cidades.toString());
    //print da lista editada
    for(var cid in cidades ){
      print("Id: " + cid['id'].toString() +", "+ cid['uf'] +" "+ cid['nomeUf'] +", "+ cid['nomeMunicipio'] +", "+ cid['municipio'] +", "+ cid['codMunicipioCompleto']);
    }
  }

  listarCidadesPR() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM enderecos where uf = '41' ";
    List cidades = await db.rawQuery(sql);
    //print da lista completa
    //print("Cidades = "+ cidades.toString());
    //print da lista editada
    for(var cid in cidades ){
      print("Id: " + cid['id'].toString() +", "+ cid['uf'] +" "+ cid['nomeUf'] +", "+ cid['nomeMunicipio'] +", "+ cid['municipio'] +", "+ cid['codMunicipioCompleto']);
    }
  }

  salvarCidade(String uf, String nomeUf, String municipio, String codMunicipioCompleto, String nomeMunicipio, Database db) async {

    Map<String, dynamic> dadosCidade = {
      "uf": uf,
      "nomeUf": nomeUf,
      "municipio": municipio,
      "codMunicipioCompleto": codMunicipioCompleto,
      "nomeMunicipio": nomeMunicipio
    };
    int id = await db.insert("enderecos", dadosCidade);
    //db.close();
    //print("Salvo Cód Estado $nomeUf com id: $id ");
    //print(n);
  }

  remover(int id)async{
    Database db = await recuperarBanco();
    db.delete(
      "enderecos",
      where: "id = ?",
      whereArgs: [id]
    );
  }

  buscarPorId(int id)async{
    Database db = await recuperarBanco();
    List cidades = await db.query(
      "enderecos",
      columns: ["id","uf","nomeUf","municipio","codMunicipioCompleto","nomeMunicipio"],
      where: "id = ?",
      whereArgs: [id]
    );
    for(var cidade in cidades){
      print("Id: " + cidade['id'].toString() +
          " UF: " + cidade['uf'] +
          " Nome Uf: " + cidade['nomeUf'] +
          " Municipio: " + cidade['municipio'] +
          " Cód Municipio: " + cidade['codMunicipioCompleto'] +
          " Nome Município: " + cidade['nomeMunicipio']
      );
    }
  }
*/
  /*criaCidades()async{
    Database db1 = await recuperarBanco();
    salvarCidade("PR", "Vitória", "PR", "6000", "PR",db1);
    salvarCidade("AM", "Vitória", "AM", "6300", "AM",db1);
    salvarCidade("AC", "Vitória", "AC", "6550", "AC",db1);
    salvarCidade("MT", "Vitória", "MT", "6011", "MT",db1);
  }//função para testar inserts*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    //salvarCidade("Pi", "Piauí", "TO", "9000", "Pi");
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(child: Icon(Icons.arrow_back_ios,color: Colors.white),onTap: (){Navigator.pop(context);},),
        backgroundColor: Colors.black,
       title: Text("Configurações",style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Listar Vistorias",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    //listarLocaisEsp();
                    Conexao con = Conexao();
                    con.listarVistoria();

                  }
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 50,bottom: 10,left: 10,right: 10),
            child: RaisedButton(
                color: Colors.amber,
                child: Text("Carrega Cidades",
                style: TextStyle(
                  color: Colors.black
                )),
                onPressed: (){

                  _carregaCidades();

                }
            ),
            ),
            Padding(padding: EdgeInsets.only(top:50,bottom: 100,left: 10,right: 10),
              child: RaisedButton(
                  color: Colors.amber,
                  child: Text("Carrega Tipos Desp",
                      style: TextStyle(
                          color: Colors.black
                      )),
                  onPressed: (){
                    _carregaTiposDesp();
                  }
              ),
            ),
            Padding(padding: EdgeInsets.only(top:50,bottom: 100,left: 10,right: 10),
                
              child: RaisedButton(
                  color: Colors.amber,
                  child: Text("Busca Tabelas",
                      style: TextStyle(
                          color: Colors.black
                      )),
                  onPressed: (){
                    Conexao con = Conexao();
                    con.getTables();
                  }
              ),
            ),
            Padding(padding: EdgeInsets.only(top:50,bottom: 100,left: 10,right: 10),

              child: RaisedButton(
                  color: Colors.amber,
                  child: Text("Salvar Dados Vistoria",
                      style: TextStyle(
                          color: Colors.black
                      )),
                  onPressed: (){
                    Conexao con = Conexao();
                    con.salvarTipoVistoria(1, "NICHOS");
                    con.salvarTipoVistoria(2, "CARROS");
                    con.salvarTipoVistoria(3, "TEMPERATURA");
                    con.salvarTipoVistoria(4, "ESTOQUE");

                    con.salvarStatusVistoria(1, "CONFORME", "C");
                    con.salvarStatusVistoria(2, "ATENDE PARCIALMENTE", "AP");
                    con.salvarStatusVistoria(3, "NÃO CONFORME", "NC");
                    con.salvarStatusVistoria(4, "NÃO SE APLICA", "NA");

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

                    con.salvarOfensorVistoria(1, "MESA");
                    con.salvarOfensorVistoria(2, "GAVETA");
                    con.salvarOfensorVistoria(3, "ALIMENTO");
                    con.salvarOfensorVistoria(4, "TODOS");

                    //con.listarTiposVist();
                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Carrega Locais Específicos",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    _carregaLocEsp();
                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Listar Locais",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    //listarLocaisEsp();
                    listarLocaisFormat();

                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Listar Km",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    //listarLocaisEsp();
                    Conexao con = Conexao();
                    con.listarKmRodado();

                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Cadastrar pessoa",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: ()async{
                    Database db = await con.recuperarBanco();
                    //listarLocaisEsp();
                    con.salvarpessoa("André", "Obs" ,18, db);
                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Listar Tabelas",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    //listarLocaisEsp();
                    con.listarTabelas();

                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Listar Pessoas",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    //listarLocaisEsp();
                    con.listarPessoas();

                  }
              ),
            ),

            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Listar Pessoas",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    //listarLocaisEsp();
                    con.listarPessoas2();
                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Deleter Pessoas por id",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    //listarLocaisEsp();
                    con.deletarPessoasId(163);
                  }
              ),
            ),
            /*Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Listar Tipos Despesa",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    //listarCidades();
                    //buscarPorId(1010);
                    con.listarTiposFormat();
                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Listar Cidades",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    //listarCidades();
                    //buscarPorId(1010);
                    con.listarCidadesFormat();
                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Deletar",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    con.remover(2);
                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Cidades RS",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    con.listarCidadesRS();
                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Cidades SC",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    con.listarCidadesSC();
                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Cidades PR",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    con.listarCidadesPR();
                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Truncate",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    con.limpaTabela();
                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Listar Despesa",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    //listarCidades();
                    //buscarPorId(1010);
                    con.listarDespesasFormat();
                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Listar usuarios",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    con.listarUsuario();
                  }
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Limpar Tabela despesas",
                      style: TextStyle(
                          color: Colors.white
                      )),
                  onPressed: (){
                    //listarCidades();
                    //buscarPorId(1010);
                    con.limpaTabelaDespesas();
                  }
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
