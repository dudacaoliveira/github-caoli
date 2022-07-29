import 'package:flutter/material.dart';

class TelaTurnos extends StatefulWidget {
  @override
  _TelaTurnosState createState() => _TelaTurnosState();
}

class _TelaTurnosState extends State<TelaTurnos> {

  var turnos  = ["MANHÃ","MANHÃ/TARDE","MANHÃ,TARDE,NOITE","TARDE","TARDE/NOITE","NOITE"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Turnos"),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: turnos.length,
            padding: const EdgeInsets.all(1.0),
            itemBuilder: (context, position) {
              return Column(
                children: <Widget>[
                  //Divider(height: 2.0),
                  ListTile(
                    leading: Icon(Icons.access_time),
                      title: Text(
                        '${turnos[position].toString()}',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.deepOrange,
                        ),
                      ),

                      //onTap: () => _navigateToNote(context, items[position]), para navegar para detalhes
                      onTap: ()async{
                        String nMun = turnos[position].toString();
                        Navigator.pop(context, nMun);
                      }
                  ),
                ],
              );
            }),
      ),
    );
  }
}
