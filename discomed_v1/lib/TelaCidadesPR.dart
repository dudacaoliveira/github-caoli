import 'package:discomedv1/ConexaoBd.dart';
import 'package:discomedv1/TelaDespesa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'ConexaoBd.dart';
import 'CidadesModel.dart';

class TelaCidadesPR extends StatefulWidget {
  @override
  _TelaCidadesPRState createState() => _TelaCidadesPRState();
}

class _TelaCidadesPRState extends State<TelaCidadesPR> {

  List<Cidades> items = new List();
  Conexao db = new Conexao();

  @override
  void initState() {
    super.initState();
    db.getAllPR().then((notes) {
      setState(() {
        notes.forEach((note) {
          items.add(Cidades.fromMap(note));
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
        title: Text("Cidades",
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
                        '${items[position].nomeMunicipio}',
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
                      onTap: (){
                        String nMun = items[position].nomeMunicipio;
                        String cMunc = items[position].codMunicipioCompleto;
                        Get.toNamed("/despesa/$cMunc");
                      }
                  ),
                ],
              );
            }),
      ),
    );
  }
}
