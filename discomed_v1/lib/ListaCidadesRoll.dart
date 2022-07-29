import 'package:discomedv1/ConexaoBd.dart';
import 'package:discomedv1/TelaDespesa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'ConexaoBd.dart';
import 'CidadesModel.dart';

/*class ControllerSc extends GetxController{
  var count = 0.obs;
  String nomecidadeController = " ";
  String codcidadeController = " ";

  static ControllerSc get to => Get.find();
}*/

class ListaCidadesRoll extends StatefulWidget {
  final String text;
  ListaCidadesRoll({Key key, this.text}) : super(key: key);//construtor para receber param
  //TelaCidades();// contrutor  sem parametros
  @override
  //_TelaCidadesState createState() => _TelaCidadesState();
  _ListaCidadesRollState createState() {
    //print(text);
    print("teste");
    return _ListaCidadesRollState();
  }
}

class _ListaCidadesRollState extends State<ListaCidadesRoll> {

  //static final ControllerSc c = Get.put(ControllerSc());

  List<Cidades> items = new List();
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
         });
       });
     });
   }else if(widget.text == "RS"){
     db.getAllRS().then((notes) {
       setState(() {
         notes.forEach((note) {
           items.add(Cidades.fromMap(note));
         });
       });
     });
   }else{
     db.getAllPR().then((notes) {
       setState(() {
         notes.forEach((note) {
           items.add(Cidades.fromMap(note));
         });
       });
     });
   }
  }

  List<String> nameList = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appbar"),
      ),
      body: ListWheelScrollView(
        squeeze: 1.0,
          itemExtent: 102,
          useMagnifier: false,
          magnification: 1.5,
          diameterRatio: 2.0,
          children: <Container>[
            ...items.map((Cidades cid) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1, color: CupertinoColors.inactiveGray)),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(cid.municipio.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),),
                ),
              );
            })
          ]),
    );
  }
}


