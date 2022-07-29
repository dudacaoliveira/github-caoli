import 'package:discomedv1/LocEspModel.dart';
import 'package:flutter/material.dart';

import 'ConexaoBd.dart';

class TelaListaHospitais extends StatefulWidget {
  @override
  _TelaListaHospitaisState createState() => _TelaListaHospitaisState();
}

class _TelaListaHospitaisState extends State<TelaListaHospitais> {

  List<LocESp> items = [];
  List<LocESp> filteredUsers = List();
  Conexao db = new Conexao();

  @override
  void initState() {
    super.initState();
    db.getAllLocais().then((notes) {
      setState(() {
        notes.forEach((note) {
          items.add(LocESp.fromMap(note));
          filteredUsers.add(LocESp.fromMap(note));
          print(note);
        });
        print(items.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
            onPressed: (){Navigator.pop(context);}
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text("Hospitais",
          style: TextStyle(
              color: Colors.blue
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
                  (u.nome
                      .toLowerCase()
                      .contains(string.toLowerCase()) ||
                      u.nome.toLowerCase().contains(string.toLowerCase()))).toList();
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
                            '${filteredUsers[position].nome}',
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
                            String nHosp = filteredUsers[position].nome;
                            String idHosp = filteredUsers[position].id.toString();
                            listaCidades.add(nHosp);
                            listaCidades.add(idHosp);
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



    /*Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Hospitais",
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
                        '${items[position].nome}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.deepOrange,
                        ),
                      ),
                      *//*subtitle: Text(
                      '${items[position].codMunicipioCompleto}',
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                      ),
                    ),*//*
                      *//* leading: Column(
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
                    ),*//*
                      //onTap: () => _navigateToNote(context, items[position]), para navegar para detalhes
                      onTap: (){
                        String nMun = items[position].nome;
                        String cMunc = items[position].id;
                        print(items[position].nome);
                        //Get.toNamed("/despesa/$cMunc");
                      }
                  ),
                ],
              );
            }),
      ),
    );*/
  }
}
