import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //---------------------------------métodos----------------------------------

  Future<Map> _recuperarPreco() async {
    String url = "https://blockchain.info/ticker";
    http.Response response = await http.get(url);
    print("${response.body}");
    return json.decode(response.body);
  }

  Future<Map> _recuperarPrecoETH() async {
    String url = "https://www.mercadobitcoin.net/api/ETH/ticker/";
    http.Response response = await http.get(url);
    print("${response.body}");
    return json.decode(response.body);
  }

  Future<Map> _recuperarPrecoSHIBA() async {
    String url = "https://www.mercadobitcoin.net/api/SHIB/ticker/";
    http.Response response = await http.get(url);
    print("${response.body}");
    return json.decode(response.body);
  }

  Future<Map> _recuperarPrecoDollar() async {
    String url = "https://economia.awesomeapi.com.br/json/last/USD-BRL";
    http.Response response = await http.get(url);
    print("Preço do Dollar hoje: ${response.body}");
    return json.decode(response.body);
  }

  Widget exibeBitCoin(){
    return FutureBuilder<Map>(
      future: _recuperarPreco(),
      // ignore: missing_return
      builder: (context, snapshot){
        String resultado;
        String moedaBra;
        String moedaAmericana;
        String resultadoDollar;
        switch (snapshot.connectionState){
          case ConnectionState.none :
            print("Sem conexão!");
            break;
          case ConnectionState.waiting :
            print("Aguardando conexão case 1");
            resultado = "Carregando...";
            moedaBra = "";
            resultadoDollar = "";
            moedaAmericana = "";
            //CircularProgressIndicator();
            break;
          case ConnectionState.active :
            print("Case 2 Conexão active");
            resultado = "Ativa...";
            moedaBra = "";
            resultadoDollar = "";
            moedaAmericana = "";
            break;
          case ConnectionState.done :
            print("Conexao Done");
            if(snapshot.hasError){
              resultado = "Erro ao carregar...";
              moedaBra = "";
              resultadoDollar = "";
              moedaAmericana = "";
            }else{
              String moeda2 =  snapshot.data ["USD"]["symbol"];
              double valDollar = snapshot.data["USD"]["buy"];
              double valor = snapshot.data["BRL"]["buy"];
              String moeda = snapshot.data["BRL"]["symbol"];

              resultado = " = ${valor.toString()}";
              moedaBra = "${moeda.toString()}";
              resultadoDollar = " = ${valDollar.toString()}";
              moedaAmericana = "${moeda2.toString()}";
              print("Teste git");
            }
            break;
        }
        return  Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            /*decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("img/bitcoin.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),*/
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("BitCoin hoje",style:TextStyle(fontSize: 20,color: Color.fromARGB(255,218,165,32),fontWeight: FontWeight.bold)),
                  Text(moedaBra + resultado,style:TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold),),
                  Text( moedaAmericana + resultadoDollar,style:TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          );
      },
    );
  }

  Widget exibeEth(){
    return FutureBuilder<Map>(
      future: _recuperarPrecoETH(),
      // ignore: missing_return
      builder: (context, snapshot){
        String volume;
        String moedaBra;
        String moedaETH;
        String resultadoDollar;
        switch (snapshot.connectionState){
          case ConnectionState.none :
            print("Sem conexão!");
            break;
          case ConnectionState.waiting :
            print("sdfsdf");
            volume = "Carregando...";
            moedaBra = "";
            resultadoDollar = "";
            moedaETH = "";
            //CircularProgressIndicator();
            break;
          case ConnectionState.active :
            print("sdfsdf");
            volume = "Ativa...";
            moedaBra = "";
            resultadoDollar = "";
            moedaETH = "";
            break;
          case ConnectionState.done :
            print("sdff");
            if(snapshot.hasError){
              volume = "Erro ao carregar...";
              moedaBra = "";
              resultadoDollar = "";
              moedaETH = "";
            }else{
              String moedaHigh =  snapshot.data ["ticker"]["high"].substring(0,8);
              String valDollar = snapshot.data["ticker"]["low"];
              String _volume = snapshot.data["ticker"]["vol"].substring(0,10);
              String moeda = snapshot.data["ticker"]["last"];

              volume = "Vol = ${_volume.toString()}";
              moedaBra = "${moeda.toString()}";
              resultadoDollar = " = ${valDollar.toString()}";
              moedaETH = "R\$ = ${moedaHigh.toString()}";
            }
            break;
        }
        return  Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              /*decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("img/bitcoin.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),*/
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ethereum hoje!",style:TextStyle(fontSize: 20,color: Color.fromARGB(255,218,165,32),fontWeight: FontWeight.bold)),
                    Text( moedaETH,style:TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold),),
                    Text(volume,style:TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            );
      },
    );
  }


  Widget exibeDollar(){
    return FutureBuilder<Map>(
      future: _recuperarPrecoDollar(),
      // ignore: missing_return
      builder: (context, snapshot){
        String moedaAmericana;
        switch (snapshot.connectionState){
          case ConnectionState.none :
            print("Sem conexão!");
            break;
          case ConnectionState.waiting :
            print("sdfsdf");
            moedaAmericana = "";
            //CircularProgressIndicator();
            break;
          case ConnectionState.active :
            print("sdfsdf");
            moedaAmericana = "";
            break;
          case ConnectionState.done :
            print("sdff");
            if(snapshot.hasError){
              moedaAmericana = "";
            }else{
              //Aqui são os parâmetros recebidos pela API
             /* bid/Compra
              ask/Venda
              varBid/Variação
              pctCh/Porcentagem de Variação
              high/Máximo
              low/Mínimo*/
              moedaAmericana =  snapshot.data ["USDBRL"]["low"];
              //moedaAmericana = "R\$ = ${moedaHigh.toString()}";
              print("Valor do dollar hoje!");
              print(moedaAmericana);
            }
            break;
        }
        return  Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              /*decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("img/bitcoin.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),*/
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Dollar hoje!",style:TextStyle(fontSize: 20,color: Color.fromARGB(255,218,165,32),fontWeight: FontWeight.bold)),
                    Text(moedaAmericana,style:TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            );

      },
    );
  }

  Widget exibeShib(){
    return FutureBuilder<Map>(
      future: _recuperarPrecoSHIBA(),
      // ignore: missing_return
      builder: (context, snapshot){
        String volume;
        String moedaBra;
        String moedaAmericana;
        String resultadoDollar;
        switch (snapshot.connectionState){
          case ConnectionState.none :
            print("Sem conexão!");
            break;
          case ConnectionState.waiting :
            print("sdfsdf");
            volume = "Carregando...";
            moedaBra = "";
            resultadoDollar = "";
            moedaAmericana = "";
            //CircularProgressIndicator();
            break;
          case ConnectionState.active :
            print("sdfsdf");
            volume = "Ativa...";
            moedaBra = "";
            resultadoDollar = "";
            moedaAmericana = "";
            break;
          case ConnectionState.done :
            print("sdff");
            if(snapshot.hasError){
              volume = "Erro ao carregar...";
              moedaBra = "";
              resultadoDollar = "";
              moedaAmericana = "";
            }else{
              String moedaHigh =  snapshot.data ["ticker"]["high"].substring(0,9 );
              String valDollar = snapshot.data["ticker"]["low"];
              String _volume = snapshot.data["ticker"]["vol"].substring(0,10);
              String moeda = snapshot.data["ticker"]["last"];

              volume = "Vol = ${_volume.toString()}";
              moedaBra = "${moeda.toString()}";
              resultadoDollar = " = ${valDollar.toString()}";
              moedaAmericana = "R\$ = ${moedaHigh.toString()}";
            }
            break;
        }
        return  Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              /*decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("img/bitcoin.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),*/
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ShibaInu hoje!",style:TextStyle(fontSize: 20,color: Color.fromARGB(255,218,165,32),fontWeight: FontWeight.bold)),
                    Text( moedaAmericana,style:TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold),),
                    Text(volume,style:TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            );

      },
    );
  }


  Future<Null> _refresh() async{
    await Future.delayed(Duration(seconds: 1));
    Get.offAll(Home());//Chama a mesma tela para atualizar os dados e remove a tela anterior da árvore
    print("Deslizou o dedo para Atualizar!");
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    //_recuperarPrecoDollar();
    super.initState();
  }

  //---------------------------------métodos----------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      /*appBar: AppBar(
        backgroundColor:Colors.transparent,
        title: Text("Consumo Bitcoin"),
      ),*/
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(

            child: Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                /* new Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(image: new AssetImage("img/bitcoin.jpg"), fit: BoxFit.cover,),
                  ),
                ),*/
                //Imagem da moeda que fica de fundo
                new Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(image: new AssetImage("img/bitcoin.jpg"), fit: BoxFit.fill),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30,left: 10),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("img/logo_crip.jpg"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 180),
                  child: exibeEth(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 110),
                  child: exibeBitCoin(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 260),
                  child: exibeShib(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 360),
                  child: exibeDollar(),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 490),
                  child: new Center(
                    child:Shimmer.fromColors(child: Text("Arraste para Atualizar",
                      style: TextStyle(
                        //fontFamily: ,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.lightBlueAccent
                      ),
                    ),
                        baseColor: Colors.white,
                        highlightColor: Color.fromARGB(255,218,165,32)
                    ),
                    //Text("Arraste para Atualizar",style: TextStyle(color: Colors.white,fontSize: 20),),
                  ),
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}
