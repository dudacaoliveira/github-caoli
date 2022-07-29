import 'package:discomedv1/ConexaoBd.dart';
import 'package:discomedv1/TelaDespesa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'ConexaoBd.dart';
import 'TiposModel.dart';

class TelaListarTipos extends StatefulWidget {
  @override
  _TelaListarTiposState createState() {
    return _TelaListarTiposState();
  }
}

class _TelaListarTiposState extends State<TelaListarTipos> {

  List<TiposDespesa> items = new List();
  Conexao db = new Conexao();


  @override
  void initState() {
    super.initState();
    db.getAllTiposDesp().then((notes) {
      setState(() {
        notes.forEach((note) {
          items.add(TiposDespesa.fromMap(note));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Tipos Despesa",
          style: TextStyle(
              color: Colors.black
          ),),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search,
                color: Colors.black,
              ),
              onPressed: (){}
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(1.0),
            itemBuilder: (context, position) {
              return Column(
                children: <Widget>[
                  Divider(height: 2.0),
                  ListTile(
                      title: Text(
                        '${items[position].tipo}',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.deepOrange,
                        ),
                      ),
                      /*subtitle: Text(
                      '${items[position].id}',
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
                      onTap: (){
                        List tipos = new List();
                        String tipo = items[position].tipo;
                        String id = items[position].id;
                        tipos.add(tipo);
                        tipos.add(id);
                        //Get.toNamed("/despesa/${items[position].tipo}");
                        String textToSendBack = id;

                        Navigator.pop(context, tipos);
                        //Get.offNamed("/despesa?device=phone&tipo=${items[position].tipo}");
                        /*Navigator.push(context, MaterialPageRoute(
                            builder: (context) => TelaDespesa("${tipo}","","","")
                        ));*/
                      }
                  ),
                ],
              );
            }),
      ),
    );
  }
}
