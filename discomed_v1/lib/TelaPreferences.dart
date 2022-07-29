import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaPreferences extends StatefulWidget {
  @override
  _TelaPreferencesState createState() => _TelaPreferencesState();
}

class _TelaPreferencesState extends State<TelaPreferences> {

  TextEditingController textEditingController = new TextEditingController();
  String _textoSalvo = "Texto Salvo";

  _salvar() async {
    String valDigitado = textEditingController.text;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("nome", valDigitado);
    print("Valor salvo ${valDigitado}");
  }

  _recuperar()async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _textoSalvo = prefs.getString("nome") ?? "Sem Valor!!!!";
    });
    print("Texto Salvo! ${_textoSalvo}");
  }

  _remover()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("nome");

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Salvando Preferencias"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Padding(
                padding:EdgeInsets.all(10),
                child: Text(_textoSalvo,
                  style: TextStyle(
                      color: Colors.blue
                  ),
                )
            ),
            TextField(
              controller:textEditingController ,
              decoration: InputDecoration(
                labelText: "Digite algo",
                //hintText: "Digite aqui"
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                      padding: EdgeInsets.all(16),
                      color: Colors.blue,
                      child: Text("Salvar",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                      onPressed: (){
                        _salvar();
                        textEditingController.clear();
                      }
                  ),
                  RaisedButton(
                      padding: EdgeInsets.all(16),
                      color: Colors.blue,
                      child: Text("Recuperar",
                        style:TextStyle(
                            color: Colors.white
                        ) ,
                      ),
                      onPressed: (){
                        _recuperar();
                        textEditingController.clear();
                      }
                  ),
                  RaisedButton(
                      padding: EdgeInsets.all(16),
                      color: Colors.blue,
                      child: Text("Excluir",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                      onPressed: (){
                        _remover();
                        textEditingController.clear();
                      }
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
