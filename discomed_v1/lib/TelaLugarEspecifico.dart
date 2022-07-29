import 'package:discomedv1/LugarEspecifico.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Bordas.dart';
import 'PessoaModel.dart';
import 'TelaCidades.dart';
import 'TelaTurnos.dart';


class TelaLugarEspecifico extends StatefulWidget {
  @override
  _TelaLugarEspecificoState createState() => _TelaLugarEspecificoState();
}

class _TelaLugarEspecificoState extends State<TelaLugarEspecifico> {
  LugarEspecifico lug = LugarEspecifico();
  var turnos  = [];
  List<LugarEspecifico> lista = new List();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool visu = false;
  TextEditingController _textEditingController1 = new TextEditingController();
  TextEditingController _textEditingController2 = new TextEditingController();
  TextEditingController _textEditingController3 = new TextEditingController();
  TextEditingController _textEditingControllerCidade = new TextEditingController();
  FocusNode focusLocal;
  FocusNode focusLugar;
  FocusNode focusTurno;
  String _txtCidade = "";
  String _dataCodMunicipio = "";
  String _local = Get.parameters['local'];
  TextEditingController _textEditingControllerNome = new TextEditingController();
  TextEditingController _textEditingControllerObs = new TextEditingController();


  void imprime(){
    print("Aewewewweweew");
    setState(() {
      visu = true;
    });
  }

  void envia(){
    if (_formKey.currentState.validate()) {
      limpaCampos();
    }
  }

  void limpaCampos (){
    _textEditingControllerCidade.clear();
    _textEditingController2.clear();
    _textEditingController3.clear();
  }

  void adicionaLocal(){
    if (_formKey.currentState.validate() ) {
      setState(() {
        //visu = false;
        _textEditingController1.clear();
        turnos.add(_textEditingControllerCidade.text);
        limpaCampos();
      });
    }
    /*setState(() {
      turnos.add(_textEditingControllerCidade.text);
      limpaCampos();
    });*/
  }

  void insereLocal(){
    print("método insereLocal chamado");
    if (_formKey.currentState.validate() ) {
      setState(() {
        lug.local = _textEditingControllerCidade.text;
        lug.lugarEsp = _textEditingController2.text;
        lug.turno = _textEditingController3.text;
        lista.add(lug);
        print("Tamanho da lista ${lista.length}");
        //visu = false;
        //turnos.add(_textEditingControllerCidade.text);
        limpaCampos();
      });
    }
  }

  void chamaTurno()async {
    //Navigator.push(context, MaterialPageRoute(builder: (context) => TelaListaTurnos()));
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TelaTurnos(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    if (result != null) {
      setState(() {
        _textEditingController3.text =
            result;
        //_txtCidade = result[0];
        //_dataCodMunicipio = result[1];
      });
    }
    //Navigator.pop(context); //fecha o bottomsheet
    return result;
  }

  Pessoa p = Pessoa(null,null);
  List<Pessoa> pessoas = new List();

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

  Widget getBotaoAddPessoa(){
    return Container(
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
                key:_formKey2,
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
    );
  }

  Widget getBotaoAddLugar(){
    return Container(
      decoration: myBoxDecoration2(Colors.black26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: myButtonRed(imprime, "Adicionar Lugar"),
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
                            readOnly: true,
                            onTap: (){
                              Get.bottomSheet(
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  height: 210,
                                  child: Wrap(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 10, left: 150),
                                        child: Text(
                                          "Selecione o Estado",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      ),
                                      ListTile(
                                          leading: Icon(
                                            Icons.public,
                                            //color: Colors.white,
                                          ),
                                          title: Text(
                                            'PR',
                                            style: TextStyle(color: Colors.deepOrange),
                                          ),
                                          onTap: () async {
                                            final result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TelaCidades(text: "PR"),
                                                ));
                                            // after the SecondScreen result comes back update the Text widget with it
                                            if (result != null){
                                              setState(() {
                                                _textEditingControllerCidade.text =
                                                result[0];
                                                _txtCidade = result[0];
                                                _dataCodMunicipio = result[1];
                                              });
                                            }
                                            Navigator.pop(context); //fecha o bottomsheet
                                          }),
                                      ListTile(
                                          leading: Icon(Icons.public),
                                          title: Text(
                                            'SC',
                                            style: TextStyle(color: Colors.deepOrange),
                                          ),
                                          onTap: () async {
                                            final result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TelaCidades(text: "SC"),
                                                ));

                                            // after the SecondScreen result comes back update the Text widget with it
                                            if (result != null) {
                                              setState(() {
                                                _textEditingControllerCidade.text =
                                                result[0];
                                                _txtCidade = result[0];
                                                _dataCodMunicipio = result[1];
                                              });
                                            }
                                            Navigator.pop(context); //fecha o bottomsheet
                                          }),
                                      ListTile(
                                          leading: Icon(Icons.public),
                                          title: Text(
                                            'RS',
                                            style: TextStyle(color: Colors.deepOrange),
                                          ),
                                          onTap: () async {
                                            final result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TelaCidades(text: "RS"),
                                                ));

                                            // after the SecondScreen result comes back update the Text widget with it
                                            if (result != null) {
                                              setState(() {
                                                _textEditingControllerCidade.text =
                                                result[0];
                                                _txtCidade = result[0];
                                                _dataCodMunicipio = result[1];
                                              });
                                            }
                                            Navigator.pop(context); //fecha o bottomsheet
                                          }),
                                    ],
                                  ),
                                ),
                              );

                            },
                            controller: _textEditingControllerCidade,
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
                            decoration: decorationCampo("Local", "Digite o local",Icon(Icons.arrow_forward))
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            onTap: ()async{


                            },
                            controller: _textEditingController2,
                            focusNode: focusLugar,
                            textInputAction: TextInputAction.next,
                            validator: (textEditingController2) {
                              if (textEditingController2.isEmpty) {
                                return 'Campo Obrigatório';
                              }
                              return null;
                            },
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focusTurno);
                            },
                            decoration: decorationCampo("Lugar específico(Hospital)", "Digite o Lugar",null)
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            readOnly:true,
                            onTap: (){chamaTurno();},
                            controller: _textEditingController3,
                            focusNode: focusTurno,
                            textInputAction: TextInputAction.done,
                            validator: (textEditingController3) {
                              if (textEditingController3.isEmpty) {
                                return 'Campo Obrigatório';
                              }
                              return null;
                            },
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focusLugar);
                            },
                            decoration: decorationCampo("Turno", "",Icon(Icons.arrow_forward))
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myButtonAzul(insereLocal, "Salvar"),
                    ),
                  ],
                ),
              )
          ),

        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(color: Colors.blue, icon: Icon(Icons.arrow_back_ios),onPressed: (){Navigator.pop(context);}),
        title: Row(
          children: [
            Text("Lugar Específico:  ",style: TextStyle(color: Colors.blue),),
            Text(" ${_local} ",style: TextStyle(color: Colors.orange,fontSize: 12),),
          ],
        )
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //Coluna Principal
        children: [
          SizedBox(height: 10,),//espaço no ínício do Body
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: getBotaoAddLugar()
          ),
          Expanded(
            child: Container(
              decoration:myBoxDecoration2(Colors.black26) ,
              child: ListView.builder(
                  itemCount: lista.length,
                  padding: const EdgeInsets.all(1.0),
                  itemBuilder: (context, position) {
                    return Column(
                      children: <Widget>[
                        //Divider(height: 2.0),
                        ListTile(
                            title: Card(
                              child: ListTile(
                                //leading: Icon(Icons.access_time,size: 15,),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text("Local:"),
                                      Text("${lista[position].local}"),
                                    ],),
                                    Row(children: [
                                      Text("Lugar espec.:"),
                                      Text("${lista[position].lugarEsp}"),
                                    ],),
                                    Row(children: [
                                      Text("Turno"),
                                      Text("${lista[position].turno}"),
                                    ],),
                                    //Expanded(child: getBotaoAddPessoa())
                                  ],
                                ),
                                //subtitle:Text("${_textEditingController3.text}"),
                              ),

                            ),

                            //onTap: () => _navigateToNote(context, items[position]), para navegar para detalhes
                            onTap: ()async{
                              String nMun = lista[position].local;
                              Get.toNamed("/adicionarPessoas?device=phone&local=${nMun}");
                            }
                        ),
                      ],
                    );
                  }),
            ),
          ),
          //Containers(context)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          if (_formKey.currentState.validate() ) {
            setState(() {
              visu = false;
              _textEditingController1.clear();
              limpaCampos();
            });
          }
        },
        //tooltip: 'Pick Image',
        child: Icon(Icons.send),
      ),
    );
  }
}
