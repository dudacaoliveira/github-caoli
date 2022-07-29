import 'package:flutter/material.dart';

Widget layoutPessoas(var pessoas, var obsevacao){
  return Expanded(
    child: Container(
      child: ListView.builder(itemCount:pessoas.length,itemBuilder: (context,position){
        return Column(
          children: <Widget>[
            ListTile(
              title: Card(
                child: ListTile(
                  title: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Nome:"),
                          Text("${pessoas[position].toString()}"),
                        ],
                      ),
                      Text("${obsevacao}")
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    ),
  );
}

Widget layoutLocal(var locais,var lista,Color color){
  return Expanded(
    child: Container(
      child: ListView.builder(itemCount:locais.length,itemBuilder: (context,position){
        return Column(
          children: <Widget>[
            ListTile(
              title: Card(
                child: ListTile(
                  title: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Local:"),
                          Text("${locais[position].toString()}",style: TextStyle(color: color),)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    ),
  );
}

Widget listaPessoasCustom(var lista){
  return SliverList(
    delegate: SliverChildBuilderDelegate((context,index){
      return Column(
        children: [
          Card(
            child: ListTile(
              title: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("${index + 1} - "),
                      Text("${lista[index].toString()}"),
                    ],
                  ),
                  //Text(_textEditingControllerObs.text)
                ],
              ),
            ),
          ),
        ],
      );
    },childCount: lista.length
    ),
  );
}

Widget listaTarefasCustom(var lista){
  return SliverList(
    delegate: SliverChildBuilderDelegate((context,index){
      return Column(
        children: [
          ListTile(
            title: Card(
              child: ListTile(
                title: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Data:"),
                        Text("${lista[index]["data"]}"),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Local:"),
                        Text("${lista[index]["local"]}"),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("LocalEsp:"),
                        Text("${lista[index]["localEspec"]}"),
                      ],
                    ),
                    //Text(_textEditingControllerObs.text)
                  ],
                ),
              ),
            ),
          )
        ],
      );
    },childCount: lista.length
    ),
  );
}

Widget teste(){
  return Container();
}

Widget listaTarefa2(context,index,var lista,Map _lastRemoved,int _lastremovedPos,Function _saveData,Function setState){
  return Dismissible(
    key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
    background: Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment(-0.9,0.0),
        child: Icon(Icons.delete,color: Colors.white,),
      ),
    ),
    direction: DismissDirection.startToEnd,
    child: ListTile(
      title: Card(
        child: ListTile(
          title: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Data:"),
                  Text("${lista[index]["data"]}"),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Local:"),
                  Text("${lista[index]["local"]}"),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("LocalEsp:"),
                  Text("${lista[index]["localEspec"]}"),
                ],
              ),
              //Text(_textEditingControllerObs.text)
            ],
          ),
        ),
      ),
    ),
    onDismissed: (direction){
      setState(() {
        print("   " + _lastRemoved["local"]);
        _lastremovedPos = index;
        lista.removeAt(index);
        _saveData();
        //Chama SnackBar
        final snack = SnackBar(
          content: Text("Tarefa ${_lastRemoved["local"]} removida"),
          action: SnackBarAction(label: "Desfazer",
            onPressed: (){
              setState(() {
                lista.insert(_lastremovedPos, _lastRemoved);
                _saveData();
              });
            },

          ),
          duration: Duration(seconds: 5),
        );
        Scaffold.of(context).removeCurrentSnackBar();//para remover o sback quando outro for chamado! Eliminando a pilha!
        Scaffold.of(context).showSnackBar(snack);//Chama o snack!
      });

    },
  );


}

