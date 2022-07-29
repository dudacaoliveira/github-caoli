import 'package:flutter/material.dart';
import 'Bordas.dart';
import 'PessoaModel.dart';

class TelaAdicPessoas extends StatefulWidget {
  @override
  _TelaAdicPessoasState createState() => _TelaAdicPessoasState();
}

class _TelaAdicPessoasState extends State<TelaAdicPessoas> {
  TextEditingController _textEditingControllerNome = new TextEditingController();
  TextEditingController _textEditingControllerObs = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool visu = false;
  FocusNode focusLocal;
  FocusNode focusLugar;
  FocusNode focusTurno;
  //var pessoas  = [];
  Pessoa p = Pessoa(null,null);
  List<Pessoa> pessoas = new List();

  void limpaCampos (){
    _textEditingControllerNome.clear();
    _textEditingControllerObs.clear();
  }

  void inserePessoa(){
    if (_formKey.currentState.validate() ) {
      setState(() {
        //visu = false
        //pessoas.add(_textEditingControllerNome.text);
        p.nome = _textEditingControllerNome.text;
        p.observacao = _textEditingControllerObs.text;
        pessoas.add(p);
        limpaCampos();
      });
      print("Qtde de pessoas nessa lista = ${pessoas.length}");
    }
  }

  void imprime(){
    print("Aewewewweweew");
    setState(() {
      visu = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Pessoas"),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //Coluna Principal
        children: [
          SizedBox(height: 50,),//espaço no ínício do Body
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //decoration: myBoxDecoration2(Colors.black26),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: myButtonRed((){imprime();}, "Adicionar Pessoas"),
                  ),
                  Visibility(
                      visible: visu == true,
                      child: Form(
                        key:_formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    readOnly: false,
                                    onTap: (){
                                    },
                                    controller: _textEditingControllerNome,
                                    focusNode: focusLocal,
                                    textInputAction: TextInputAction.next,
                                    validator: (textEditingController) {
                                      if (textEditingController.isEmpty) {
                                        return 'Campo Obrigatório';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (v){
                                      FocusScope.of(context).requestFocus(focusLugar);
                                    },
                                    decoration: decorationCampo("Nome da Pessoa", "",Icon(Icons.person))
                                )
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    onTap: ()async{
                                    },
                                    controller: _textEditingControllerObs,
                                    focusNode: focusLugar,
                                    textInputAction: TextInputAction.done,
                                    validator: (textEditingController2) {
                                      if (textEditingController2.isEmpty) {
                                        return 'Campo Obrigatório';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (v){
                                      FocusScope.of(context).requestFocus(focusTurno);
                                    },
                                    decoration: decorationCampo("Observações", "Observações",null)
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: myButtonAzul(inserePessoa, "Salvar"),
                            ),
                          ],
                        ),
                      )
                  ),

                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: pessoas.length,
                  padding: const EdgeInsets.all(1.0),
                  itemBuilder: (context, position) {
                    return Column(
                      children: <Widget>[
                        //Divider(height: 2.0),
                        ListTile(
                            title: Card(
                              child: ListTile(
                                leading: Icon(Icons.access_time,size: 20,),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text("Nome: "),
                                      //Text("${pessoas[position].toString()}"),
                                      Text("${pessoas[position].nome}"),
                                    ],),
                                    Row(children: [
                                      Text("Obs: "),
                                      //Text("${pessoas[position].toString()}"),
                                      Text("${pessoas[position].observacao}"),
                                    ],),
                                  ],
                                ),
                                //subtitle:Text("${_textEditingController3.text}"),
                              ),
                            ),

                            //onTap: () => _navigateToNote(context, items[position]), para navegar para detalhes
                            onTap: ()async{

                            }
                        ),
                      ],
                    );
                  }),
            ),
          ),
          /*Card(
              child: ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text("Local:"),
                      Text("${_textEditingControllerCidade.text}"),
                    ],),
                    Row(children: [
                      Text("Lugar Específico(Hospial):"),
                      Text("${_textEditingController2.text}"),
                    ],),
                    Row(children: [
                      Text("Turno:"),
                      Text("${_textEditingController3.text}"),
                    ],),

                  ],
                ),
                //subtitle:Text("${_textEditingController3.text}"),
              ),
            )*/
          //Containers(context)
        ],
      ),
    );
  }
}
