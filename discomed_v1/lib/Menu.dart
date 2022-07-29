import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ConexaoBd.dart';
import 'LayoutCards.dart';
import 'TelaConfiguracoes.dart';
import 'UsuarioModel.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  String _nome = "";
  String _id = "";

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
              Navigator.of(context).pop(false);//Nada faz e fica na mesma tela
              //Get.offAllNamed("/index?device=phone&id=${_id} &nome=${_nome}");--------------------------------------------------------------------------------
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


  void chamaWhatsapp ({@required number, @required massage})async{
      String url = 'whatsapp://send?phone=$number&text = $massage';
      await canLaunch(url) ? launch(url): print("Erro ao tentar abrie Whatsapp");
  }

  @override
  void initState() {
    List usus = new List();
    Conexao db = new Conexao();
    db.getAllUsuario().then((notes) {
      setState(() {
        notes.forEach((note) {
          usus.add(Usuario.fromMap(note));
          print("----------------Procura usuários no banco na splashScrenn-------------------");
          print("usuários cadastrados = ${usus.length}");
          for(Usuario u in usus){
            print("Nome: " + u.nome + "|" + "ID: " + u.id + "|" + "Status Logado: " + u.status);
          }
        });
      });
      for(var u in usus){
        print("Nome do usuario dentro do initState " + u.nome);
        print("----------------Procura usuários no banco-------------------");
        _nome = u.nome;
        _id = u.id;
      }
    });
    super.initState();
  }

  Widget layoutContainer (){
    return Column(
      children: [
        GestureDetector(
          child: Container(
              color: Colors.transparent,
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
              color: Colors.transparent,
              height: 70,
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left:10,right: 20),
                      child: Icon(Icons.sim_card_alert,
                      )
                  ),
                  Text(
                    "Hístorico Despesas",
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
        Divider(),
        GestureDetector(
          child: Container(
              color: Colors.transparent,
              height: 70,
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left:10,right: 20),
                      child: Icon(Icons.close,
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
    );
  }

  Widget layoutCard(){
    return Column(
      children: [
        GestureDetector(
          child: MyCardMenu("Configurações",Icon(Icons.settings),Colors.blueGrey),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => TelaConfig()
            ));
          },
        ),
        GestureDetector(
          child: MyCardMenu("Histórico de Despesas",Icon(Icons.assignment),Colors.blueGrey),
          onTap: (){
            Get.toNamed("/despRecu?device=phone&visualizada=nao&id=${_id}&nome=${_nome}");
            //Navigator.pop(context);
          },
        ),
        GestureDetector(
          child: MyCardMenu("Vistoria",Icon(Icons.assistant_photo),Colors.blueGrey),
          onTap: (){
            //Get.snackbar("Em breve!", "Em construção!",backgroundColor: Colors.white);
            Get.toNamed("/telavistoria2");
            //Navigator.pop(context);
          },
        ),
        GestureDetector(
          child: MyCardMenu("Fale com o desenvolvedor", Icon(Icons.message,color: Colors.teal,),Colors.teal),
          onTap: ()async{
            chamaWhatsapp(number:'+5551992603380', massage: "Hello!");
          },
        ),
        GestureDetector(
          child: MyCardMenu("Comprovantes Recep.....", Icon(Icons.note,color: Colors.black54,),Colors.black54),
          onTap: ()async{
            Get.toNamed("/telaComprovantes");
          },
        ),
        GestureDetector(
          child: MyCardMenu("Sair", Icon(Icons.assignment_returned,color: Colors.red,),Colors.red),
          onTap: ()async{
            _exitApp(context);
          },
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.close,color: Colors.white,), onPressed: (){Navigator.pop(context);}),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Padding(padding: EdgeInsets.all (10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top:0,right:20,left:10),
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 0, 128,155),
                        backgroundImage: AssetImage('img/logo1.png'),
                        radius: 40,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 50),
                      child: Text("Menu",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    //texto do drawer
                  ],
                ),
                Divider(),
                layoutCard()
              ],
            ),
          ),
        ),
      )
    );
  }
}
