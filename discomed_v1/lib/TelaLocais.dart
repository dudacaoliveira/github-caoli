/*
import 'package:discomedv1/TelaTurnos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'Bordas.dart';
import 'package:get/get.dart';
import 'PessoaModel.dart';
import 'TelaCidades.dart';

class TelaLocais extends StatefulWidget {
  @override
  _TelaLocaisState createState() => _TelaLocaisState();
}

class _TelaLocaisState extends State<TelaLocais> {
  var turnos  = [];
  final _formKey = GlobalKey<FormState>();
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
  DateTime _date;
  String txtData = "";





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
        turnos.add(_textEditingControllerCidade.text);
        _date = DateTime.now();
        final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_date);
        //_vardataPT = datapt; // aqui a vardata recebe a data formatada pelo código acima
        //txtData = _date.toString();
        txtData = datapt;
        limpaCampos();
        visu = false;
        _textEditingController1.clear();
        limpaCampos();
      });
    }

    /*setState(() {
      turnos.add(_textEditingControllerCidade.text);
      _date = DateTime.now();
      final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_date);
      //_vardataPT = datapt; // aqui a vardata recebe a data formatada pelo código acima
      //txtData = _date.toString();
      txtData = datapt;
      limpaCampos();
    });*/
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

  Widget getbotao(){
    return Container(
      decoration: myBoxDecoration2(Colors.black26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: myButtonRed(imprime, "Adicionar Local"),
          ),
          Visibility(
              visible: visu == true,
              child: Form(
                key:_formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //campoInput(null,context,"Digite o Local","Local",focusSenha,focusEmail,TextInputAction.next,_textEditingController1),
                    //campoInput(null,context, "Digite o nome", "Lugar Específico (Hospital)",focusEmail,focusTeste,TextInputAction.next,_textEditingController2),
                    //campoInput(chamaTurno,context, "Turno", "", focusTeste, null,TextInputAction.done,_textEditingController3)
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
                    /*Padding(
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
                                    decoration: decorationCampo("Lugar específico(Hospital)", "Digite o Lugar")
                                )
                            ),*/
                    /*Padding(
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
                                    decoration: decorationCampo("Turno", "")
                                )
                            ),*/
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myButtonAzul(adicionaLocal, "Salvar"),
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
        title: Text("Cadastrar KM Rodado",style: TextStyle(color: Colors.blue),),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //Coluna Principal
        children: [
          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: getbotao()
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: turnos.length,
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
                                Text("Data: "),
                                Text(txtData,style: TextStyle(color: Colors.pink),),
                              ],
                              ),
                            Row(children: [
                            Text("Local: "),
                            Text("${turnos[position].toString()}"),
                            ],
                            ),

                    ],
                    ),
                    //subtitle:Text("${_textEditingController3.text}"),
                    ),
                    ),

                            //onTap: () => _navigateToNote(context, items[position]), para navegar para detalhes

                            /*onTap: ()async{
                              String nMun = turnos[position].toString();
                              Get.toNamed("/lugarEspeci?device=phone&local=${nMun}");
                              //Get.to(TelaLugarEspecifico());
                              //Navigator.pop(context, nMun);
                            }*/
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


class KmRodado{
  var data;
  var local;
  var x;
}

 */