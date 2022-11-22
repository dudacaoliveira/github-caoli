import 'package:discomedv1/ConexaoBd.dart';
import 'package:discomedv1/Cores.dart';
import 'package:discomedv1/TelaDespesa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'ConexaoBd.dart';
import 'CidadesModel.dart';

class ControllerSc extends GetxController{
  var count = 0.obs;
  String nomecidadeController = " ";
  String codcidadeController = " ";

  static ControllerSc get to => Get.find();
}

class TelaCidades extends StatefulWidget {
  final String text;
  TelaCidades({Key key, this.text}) : super(key: key);//construtor para receber param
  //TelaCidades();// contrutor  sem parametros
  @override
  //_TelaCidadesState createState() => _TelaCidadesState();
  _TelaCidadesState createState() {
    //print(text);
    print("teste");
    return _TelaCidadesState();
  }
}

class _TelaCidadesState extends State<TelaCidades> {

  static final ControllerSc c = Get.put(ControllerSc());

  List<Cidades> items = new List();
  //novo
  List<Cidades> filteredUsers = List();
  //novo
  Conexao db = new Conexao();

  @override
  void initState() {
    super.initState();
    //print(widget.text);
   if(widget.text == "SC"){
     db.getAllSC().then((notes) {
       setState(() {
         notes.forEach((note) {
           items.add(Cidades.fromMap(note));
           filteredUsers.add(Cidades.fromMap(note));
         });
       });
     });
   }else if(widget.text == "RS"){
     db.getAllRS().then((notes) {
       setState(() {
         notes.forEach((note) {
           items.add(Cidades.fromMap(note));
           filteredUsers.add(Cidades.fromMap(note));
         });
       });
     });
   }else{
     db.getAllPR().then((notes) {
       setState(() {
         notes.forEach((note) {
           items.add(Cidades.fromMap(note));
           filteredUsers.add(Cidades.fromMap(note));
         });
       });
     });
   }
  }

  //String codMunicipio = items

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: corFontAppBar,),
          onPressed: (){Navigator.pop(context);}
        ),
        //elevation: 1,
        //backgroundColor: Colors.white,
        title: Text(widget.text,
        style: TextStyle(
          color: corFontAppBar
        ),
        ),
        actions: <Widget>[
          /*IconButton(
            focusColor: Colors.pinkAccent,
              icon: Icon(Icons.search,
              color: Colors.black,
              ),
              onPressed: (){
              TextEditingController controler = new TextEditingController();
              db.listarCidadesBusca(controler.text);
              }
          )*/
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20,right: 20),
            child: TextField(
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                //icon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(10),
                  //hintText: 'Pesquisar'
                labelText: 'Pesquisar'
              ),
              onChanged: (string){
                setState(() {
                  filteredUsers = items.where((u)=>
                  (u.nomeMunicipio
                      .toLowerCase()
                      .contains(string.toLowerCase()) ||
                      u.nomeMunicipio.toLowerCase().contains(string.toLowerCase()))).toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: filteredUsers.length,
                padding: const EdgeInsets.all(1.0),
                itemBuilder: (context, position) {
                  return Column(
                    children: <Widget>[
                      //Divider(height: 2.0),
                      ListTile(
                          title: Text(
                            '${filteredUsers[position].nomeMunicipio}',
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.deepOrange,
                            ),
                          ),

                          /*subtitle: Text(
                        '${items[position].codMunicipioCompleto}',
                        style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                        ),
                      ),*/
                          /* leading: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(5)),
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 12.0,
                            child: Text(
                              '${items[position].id}',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),*/
                          //onTap: () => _navigateToNote(context, items[position]), para navegar para detalhes
                          onTap: ()async{
                            List listaCidades = new  List();
                            String nMun = filteredUsers[position].nomeMunicipio;
                            String cMunc = filteredUsers[position].codMunicipioCompleto;
                            listaCidades.add(nMun);
                            listaCidades.add(cMunc);
                            //Get.offNamed("/despesa?device=phone&nomeMun=${items[position].nomeMunicipio}&cMunc=${items[position].codMunicipioCompleto}");
                            //String nMunToSendBack = nMun;
                            //String cMuncToSendBack = cMunc;
                            Navigator.pop(context, listaCidades);
                          }
                      ),

                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}


