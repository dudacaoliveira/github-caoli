import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ConexaoBd.dart';
import 'TiposModel.dart';

class Cupper extends StatefulWidget {
  @override
  _CupperState createState() => _CupperState();
}

class _CupperState extends State<Cupper> {
  int selected = 0;
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
      body: Container(

        height: 300,
        child: CupertinoPicker(itemExtent: 50, onSelectedItemChanged: (int i){
          print(i);
          setState(() {
            selected = i;
          });
        }, children: <Widget>[
          Text("T1",
          style: TextStyle(color: selected == 0 ? Colors.blue : Colors.black),
          ),
          Text("T2",
            style: TextStyle(color: selected == 1 ? Colors.blue : Colors.black),
          ),
          Text("T3",
            style: TextStyle(color: selected == 2 ? Colors.blue : Colors.black),
          ),
          Text("T1",
            style: TextStyle(color: selected == 3 ? Colors.blue : Colors.black),
          ),
          Text("T2",
            style: TextStyle(color: selected == 4 ? Colors.blue : Colors.black),
          ),
          Text("T3"),
        ]
        ),
      ),
    );
  }
}
