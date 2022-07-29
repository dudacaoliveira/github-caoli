import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'CidadesModel.dart';
import 'ConexaoBd.dart';
import 'TiposModel.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;

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
  String url2 = "https://discomed.mlsistemas.com/ws.php";
  final http.Response response = await http.post(
      url2,
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
    //_showDialogcarregaCidades();
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