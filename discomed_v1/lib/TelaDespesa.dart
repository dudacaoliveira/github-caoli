import 'dart:ui';

import 'package:discomedv1/CidadesModel.dart';
import 'package:discomedv1/ConexaoBd.dart';
import 'package:discomedv1/Cores.dart';
import 'package:discomedv1/TelaCidades.dart';
import 'package:discomedv1/Urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'Criptografia.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'TelaLoginNova.dart';
import 'TiposModel.dart';

class TelaDespesa extends StatefulWidget {
//variáveis que revcebem parametros da Tela Login
  //String _nomeUsuario;
  String codMunicipio;
  String nomeMunicipio;
  String idUsuario;
  String usuarioController;
  String tipo;

  //TelaDespesa(this.tipo,this.codMunicipio,this.nomeMunicipio,this.idUsuario);
  TelaDespesa();

  @override
  _TelaDespesaState createState() => _TelaDespesaState();
}

const String MIN_DATETIME = '2019-01-01';
const String MAX_DATETIME = '2021-11-25';
const String INIT_DATETIME = '2019-05-17';

class _TelaDespesaState extends State<TelaDespesa> {
  static final Controller c = Get.find();
  static final ControllerSc c1 = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  static TextEditingController _textEditingControllerData = new TextEditingController();
  static TextEditingController _textEditingControllerObs = new TextEditingController();
  static TextEditingController _textEditingControllerTipo = new TextEditingController();
  static TextEditingController _textEditingControllerCidade = new TextEditingController();
  TextEditingController _textEditingControllerTeste = new TextEditingController();
  //var maskTextInputFormatter = MaskTextInputFormatter(mask: "R\$ ###,##", filter: { "#": RegExp(r'[0-9]') });
  //var controller = new MoneyMaskedTextController(precision:2,leftSymbol: 'R\$ ');
  TextEditingController _textEditingControllerValor = new MoneyMaskedTextController(precision: 2, leftSymbol: 'R\$ ', decimalSeparator: ',',thousandSeparator: '.');
  TextEditingController _textEditingControllerKmIni = new TextEditingController();
  TextEditingController _textEditingControllerKmFinal = new TextEditingController();
  TextEditingController _textEditingControllerMultiplicador = new TextEditingController();

  String _txtTipo = "";
  String _txtCidade = "";
  String _vardata = "";
  String _vardataPT;
  Conexao con = new Conexao();
  List<Cidades> listaCid = List();
  String txtData = "";
  File _image;
  final picker = ImagePicker();
  String status = '';
  String errMessage = 'Error Uploading Image';
  String _dataTipo = " ";
  String _dataCodMunicipio = " ";
  String _wer;
  String _id_Usuario = Get.parameters['id']; //recebe o id passado na passagem de rota da index icone despesas
  String _nome_Usuario = Get.parameters['nome'];
  String msg_servidor = "";
  //essa variável conreola se está escolhendo o tipo KM e trans forma o textField Valor só leitura
  bool _mostraKM = false;
  double _resultSoma = 0;
  double _expessuraDivider = 0;
  Color _corDivider = Colors.grey;
  DateTime _date;

  //-----------------------------------------Parâmetros recebidos da tela Despesas para editar-------------------------

  String _id_DespesaRecu = Get.parameters[""];
  String _id_CidadeRecu = Get.parameters[""];
  String _id_TipoRecu = Get.parameters[""];
  String _valorRecu = Get.parameters[""];

  //-----------------------------------------------------------------------------------------------------------------

  enviaparametro(String _corpo_json) async {
    //ENVIA TEXTO CRIPTOGRAFADO E DESCRIPTOGRAFA RETORNO
    String url = Urls.url;
    String url2 = "https://discomed.mlsistemas.com/ws.php";
    final http.Response response = await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
    }, body: {
      'corpo': criptografa(_corpo_json)
    });
    print("Corpo do JSON from envia parametro" + _corpo_json);
    print(
        "Corpo do JSON enviado para webservice from envia parametro @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!!!!!" +
            criptografa(_corpo_json));
    String a = decrip(response.body).substring(3);
    print("Variável a from enviaparâmetro" + a.toString());
    if (decrip(response.body).substring(0, 3) == '01.') {
      Map<String, dynamic> retorno =
          json.decode(decrip(response.body).substring(3));
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      String id = retorno["idUsuario"];
      //mapeia para saber o conteúdo da ms e printar "+b"
      Get.snackbar("Falha", "Mensagem não enviada! Verifique a Data e etc... ",
          backgroundColor: Colors.red,colorText: Colors.white);
      return "Erro no enviaparametro: " + b;
    } else {
      return decrip(response.body).substring(3);
    }
  }

  Future<String> _enviaDespesa() async {
    String getVal = _textEditingControllerValor.text;
    print("***************************** ${getVal}");
    String getObs = _textEditingControllerObs.text;
    String imagem;
    if(_textEditingControllerTipo.text != "km"){
      if(_image!=null){
        imagem = base64Encode(_image.readAsBytesSync());//var do método upload no EnviarFoto
      }
    }
    //teste utf8 obsevação

    String _corpo_json = jsonEncode(<String, dynamic>{
      "custo": getVal,
      //"custo": _resultSoma,
      "modulo": "c2FsdmFyRGVzcGVzYXM=",
      "id": _id_Usuario,
      "obs": _textEditingControllerObs.text,
      "municipio": "${_dataCodMunicipio}",
      "tipoId": _dataTipo,
      //"data": "${_vardata}",
      "data": "${_date.toString()}",
      "image": imagem,
      "idDespesa": "",
      "kmF": _textEditingControllerKmFinal.text,
      "KmI": _textEditingControllerKmIni.text,
      "mult": _textEditingControllerMultiplicador.text,
    });
    Conexao con = new Conexao(); //Instacia objeto "con"
    Database db = await con.recuperarBanco(); // objeto "con" abre a conexão
    //con.salvarDespesa(int.parse(_dataTipo), int.parse(_dataCodMunicipio), _vardata, 4002587841,getVal,_textEditingControllerObs.text, db);
    print("Print do valor dentro do Create Tela Despesa " + getVal);
    print("Print da Obs dentro do Create Tela Despesa " + getObs);
    //print(_corpo_json);
    //envia corpo json webservice
    String a = await enviaparametro(_corpo_json);

    if (a.substring(0, 1) == "E") {
      print("-------------Erro de envio--------------" + decrip(a).toString());
    } else {
      //if testa se deu algum erro no envio se não tratar para decodificar json
      Map<String, dynamic> retornoDespesa = json.decode(a);
      String c = retornoDespesa["status"].toString();
      String retornoCreate = a;
      print(
          "**********Else do método _enviaDespesa *********** " + a.toString());
      print("Mensagem de Status da despesa venciada " + c.toString());
      if (c.toString() == 'true') {
        //CircularProgressIndicator(value: 20,);
       // _textEditingControllerValor.clear();
         await _showModalBottomSheetDespEnv();
        _imprimeDadosEnviados();
      } else {
        print("Erro entrou no else do envia despesas!!!!");
        Get.snackbar("Falha", "Mensagem não enviada! Verifique data, imagem etc.",
            backgroundColor: Colors.red);
      }
      // _showDialogDespesaEnviada();
    }
  } //_enviaDespesa

  //------------------------------------------------------EnviaImagens---------------------------------------------------------------------

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera,
        maxHeight: 1024,
        maxWidth: 768,
        imageQuality: 80);
    setState(() {
      _image = new File(pickedFile.path);
    });
    setStatus('');
  }

  Future getImageGalery() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        maxHeight: 1024,
        maxWidth: 768,
        imageQuality: 80);

    setState(() {
      _image = new File(pickedFile.path);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  //-------------------------------------------------------

  //Drop Dow
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _statusSel;

  List<DropdownMenuItem<String>> _getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    items.add(new DropdownMenuItem(
        onTap: () {
          print("Clicou");
        },
        value: '',
        child: new Text(
          "Selecione",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black26,
          ),
        )));
    items.add(new DropdownMenuItem(
        value: 'RS', child: new Text("Rio Grande do Sul")));
    items.add(
        new DropdownMenuItem(value: 'SC', child: new Text("Santa Catarina")));
    items.add(new DropdownMenuItem(value: 'PR', child: new Text("Paraná")));
    return items;
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      _statusSel = selectedItem;
    });
  }

  List<TiposDespesa> items = new List();
  Conexao db = new Conexao();

  @override
  void initState() {
    super.initState();
    //_dateTime = DateTime.now();
    db.getAllTiposDesp().then((notes) {
      setState(() {
        notes.forEach((note) {
          items.add(TiposDespesa.fromMap(note));
          _wer = items[0].tipo;
        });
      });
    });
  }

  void limpaCampos() {
    setState(() {
      _image =
          null; //aqui eu mudo o estado da foto para null depois que foi enviada
      _txtTipo = "";
      _txtCidade = "";
      _dataTipo = "";
      _vardata = "";
      _dataCodMunicipio = "";
      txtData = '';
      _textEditingControllerData.clear();
      _textEditingControllerObs.clear();
      _textEditingControllerValor.clear();
      _textEditingControllerCidade.clear();
      _textEditingControllerTipo.clear();
      _textEditingControllerKmFinal.clear();
      _textEditingControllerKmIni.clear();
      _textEditingControllerMultiplicador.clear();
      _mostraKM = false;
      _resultSoma = 0;

    });
  }

  _showDialogDespesaEnviada() {
    Get.defaultDialog(
      backgroundColor: Colors.white70,
      radius: 20,
      //onConfirm: () =>  Get.toNamed("/index"),
      onConfirm: () {
        Get.toNamed("/index");
        limpaCampos();
      },
      onCancel: () {
        limpaCampos();
        print("Clicou Sim");
      },
      //onCancel: () => (){},
      //buttonColor: Colors.yellowAccent,
      title: "Despesa Enviada",
      //textConfirm: "Confirma?",
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.green,
      middleText: "Deseja enviar Outra?",
      textCancel: "Sim",
      textConfirm: "Não",
    );
  }

  _showModalBottomSheetDespEnv() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Enviada com sucesso",
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                  Text(
                    "Deseja enviar outra Despesa?",
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CupertinoButton(
                        //color: Colors.red,
                        child: Text(
                          "Não",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        onPressed: () {
                          limpaCampos();
                          Get.offAllNamed(
                              "/index?device=phone&id=${_id_Usuario} &nome=${_nome_Usuario}");
                          //Navigator.pop(context);
                        },
                      ),
                      CupertinoButton(
                        //color: Colors.green,
                        child: Text("Sim",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          limpaCampos();
                          /*Get.offAllNamed(
                              "/despesa?device=phone&id=${_id_Usuario} &nome=${_nome_Usuario}");*/
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
          );
        });
  }

  _showModalBottomSheetTipos() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(

            child:
                Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      //color: Colors.red,
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        _textEditingControllerTipo.clear();
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoButton(
                      //color: Colors.green,
                      child: Text("Ok"),
                      onPressed: () {
                        //se não escolher a opção ao clicar, esse if peará o primeiro item da lista!
                        if (_textEditingControllerTipo.text.isEmpty) {
                          setState(() {
                            _dataTipo = items[0].id;
                            _textEditingControllerTipo.text = items[0].tipo;
                          });
                        }
                        else if(_textEditingControllerTipo.text == "Km"){
                          setState(() {
                            print(_dataTipo);
                            _mostraKM = true;
                          });
                        }else{
                          setState(() {
                            _mostraKM = false;
                          });
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: CupertinoPicker(
                        itemExtent: 48,
                        onSelectedItemChanged: (dynamic index) {
                          setState(() {
                            _dataTipo = items[index].id;
                            _textEditingControllerTipo.text = items[index].tipo;
                          });
                        },
                        children: new List<Widget>.generate(items.length,
                            (int index) {
                          return new Center(
                            child: new Text(
                              "${items[index].tipo}",
                              style: TextStyle(color: Colors.orange),
                            ),
                          );
                        })),
                  ),
                ),
              ],
            ),
            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
          );
        });
  }

  _showEnviando(){
    Get.snackbar("Aguarde!", "ENVIANDO...!",
    colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.greenAccent,
        backgroundColor: Colors.black,
        overlayColor: Colors.orange,
        duration: Duration(milliseconds: 5000)
    );
  }

  showMensagemImagem(){
    Get.snackbar("", "Favor escolher uma imagem da Nota!",
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.red,
        backgroundColor: Colors.transparent,
        overlayColor: Colors.orange,
        duration: Duration(milliseconds: 10000));
  }

  void validador() {
    if(_textEditingControllerTipo.text != "Km"){
      if (_image.isNull) {
        setState(() {
          _corDivider = Colors.red;//avisa para adicionar foto!
          _expessuraDivider = 5;
        });
        showMensagemImagem();
      } else {
        if(_date != null){
          _enviaDespesa();
        }else{
          Get.defaultDialog(
              title: "Data é Obrigatório!",
              middleText: "Favor Escolher uma data",
              middleTextStyle: TextStyle(color: Colors.red));
        }
        print("Entrou no Else! do Validador verifica se é KM linha 534 ");
      }
    }else{
      if(verificaKmini(int.parse(_textEditingControllerKmIni.text), int.parse(_textEditingControllerKmFinal.text))){
        print("Verificação  de Km verdadeira nop Validador");
        Get.defaultDialog(
          //onConfirm: () => Get.to(Other()),
          onCancel: () => print("Cancelado"),
          buttonColor: Colors.blue,
          title: "Atenção!",
          //textConfirm: "Confirma?",
          confirmTextColor: Colors.white,
          middleText: "Inicial não pode ser Maior que o Final",
          textCancel: "Ok",
        );
      }else{
        if(_date != null){
          _enviaDespesa();
        }else{
          Get.defaultDialog(
              title: "Data é Obrigatório!",
              middleText: "Favor Escolher uma data",
              middleTextStyle: TextStyle(color: Colors.red));
        }
      }
    }
  } //fim validator

  void _imprimeDadosEnviados() {
    print("-------------------------------------------------");
    print("*************Dados enviados************** !");
    print("código da cidade ${_dataCodMunicipio}");
    print("Id do tipo:${_dataTipo}");
    print("Valor" + _textEditingControllerValor.text);
    print("id do usuário ${_id_Usuario}");
    print("Obs: " + _textEditingControllerObs.text);
    //print(_dateTime);
    print("Data Cupertino ${_date}");
    print("Multiplicador ${_textEditingControllerMultiplicador.text}");
    print("-------------------------------------------------");
  }

  double soma(int fi, int ini, double mul) {
    double res;
    res = (((fi - ini)/10) * mul);
    return res;
  }
  _fieldFocusChange (BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus ();
    FocusScope.of (context) .requestFocus (nextFocus);
  }

  final focus = FocusNode();
  final focusKm = FocusNode();
  final focusKm1 = FocusNode();
  final focusKm2 = FocusNode();

  void _show(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Container(
            height: 300,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlatButton(child: Text("Cancel",style:TextStyle(color: Colors.deepOrange)),onPressed: (){
                      Navigator.pop(context);
                    },),
                    //Text(dataText),
                    FlatButton(child: Text("Ok",style:TextStyle(color: Colors.green),),onPressed: (){
                      setState(() {
                        final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_date);
                        _vardataPT = datapt; // aqui a vardata recebe a data formatada pelo código acima
                        //txtData = _date.toString();
                        txtData = _vardataPT;
                      });
                      Navigator.pop(context);
                    },
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                  child: Container(
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle:
                            TextStyle(color: Colors.black,fontSize: 15),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          initialDateTime: DateTime.now(),
                          onDateTimeChanged:(DateTime newDate){
                            setState(() {
                              _date = newDate;
                              final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_date);
                              _vardataPT = datapt; // aqui a vardata recebe a data formatada pelo código acima
                              txtData = _vardataPT;
                              //_date = newDate;
                            });
                          } ,
                          use24hFormat: true,
                          minimumYear: 2020,
                          maximumYear: 2028,
                          mode: CupertinoDatePickerMode.date,
                        ),
                      )
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  Widget bottomSheetCidades(){
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
          )
      ),
    );
}

bool verificaKmini(int ini,int fina){
  if(ini > fina){
    return true;
  }
  return false;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
          //onPressed: ()=> Get.toNamed("/index?device=phone&nome=${_nome_Usuario}&id=${_id_Usuario}"),
          //onPressed: ()=> Navigator.pop(context),
          onPressed: (){
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          }
        ),
        //elevation: 1,
        //backgroundColor: Colors.white,
        title: Text("Cadastrar despesa",style: TextStyle(color: corFontAppBar),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Center(
                    child: _image == null
                        ? Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        'Selecione uma imagem.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                        : Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.file(
                        _image,
                        //height: 280,
                        fit: BoxFit.fill,
                      ),
                    )),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                //border: Border.all(color: Colors.black12)
              ),
              //color: Colors.black12,
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    //color: Colors.amberAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(1),
                          child: IconButton(
                              icon: Icon(
                                Icons.photo,
                                size: 50,
                                color: Colors.lightBlueAccent,
                              ),
                              onPressed: (){
                                setState(() {
                                  _corDivider = Colors.grey;
                                  _expessuraDivider = 0;
                                });
                                getImageGalery();
                              }
                              ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(1),
                          child: IconButton(
                              icon: Icon(
                                Icons.photo_camera,
                                size: 50,
                                color: Colors.lightBlueAccent,
                              ),
                              onPressed:(){
                                setState(() {
                                  _corDivider = Colors.grey;
                                  _expessuraDivider = 0;
                                });
                                getImageCamera();
                              }
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: _expessuraDivider,
              height: 80,
              color: _corDivider,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                   /* _showDatePicker(context);
                    final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_dateTime);
                    _vardataPT = datapt; // aqui a vardata recebe a data formatada pelo código acima
                    setState(() {
                      txtData = _vardataPT;
                    });*/
                    _date = DateTime.now();
                    setState(() {
                      final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_date);
                      _vardataPT = datapt; // aqui a vardata recebe a data formatada pelo código acima
                      //txtData = _date.toString();
                      txtData = _vardataPT;
                    });
                   _show(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.date_range,color: Colors.blue[400],),
                            Text("Inserir Data",style: TextStyle(color: Colors.grey),),
                          ],
                        ),
                        Text(txtData,style: TextStyle(color: Colors.orange,fontSize: 16),),
                        //Text("${_dateTime}"),
                      ],
                    ),
                  ),
                ),

                //-------------------------

                Divider(),

                Container(
                  height: 10,
                  color: Colors.black12,
                ),
                Divider(),
                //-----------------------------------------------Form--------------------------------------------------------
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
                        child: TextFormField(
                          readOnly: true,
                          onTap: () {
                              bottomSheetCidades();
                          },
                          controller: _textEditingControllerCidade,
                          cursorColor: Colors.black45,
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Cidade',
                            hintText: 'Selecione a Cidade',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Campo Obrigatório';
                            }
                            return null;
                          },
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
                        child: TextFormField(
                          readOnly: true,
                          onTap: () async {
                            _showModalBottomSheetTipos(); //chama o BottomSheet tipos
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Campo Obrigatório';
                            }
                            return null;
                          },
                          controller: _textEditingControllerTipo,
                          cursorColor: Colors.black45,
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Tipo despesa',
                            hintText: 'Café,Trasporte e etc.',
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          autofocus: true,
                          onFieldSubmitted: (v){
                            FocusScope.of(context).requestFocus(focus);
                          },
                          readOnly: _mostraKM,
                          controller: _textEditingControllerValor,
                          //inputFormatters: [maskTextInputFormatter],
                          cursorColor: Colors.black45,
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                          decoration: InputDecoration(
                            //icon: Icon(Icons.monetization_on,color: Colors.black26,size: 20,),
                            border: OutlineInputBorder(),
                            labelText: 'Valor da Nota',
                            hintText: "Digite o valor",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == "R\$ 0,00") {
                              return 'Campo Obrigatório';
                            }
                            return null;
                          },
                        ),
                      ),

                    ],
                  ),
                ),
                //-------------switch--------------
                /*Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("INSERIR KM"),
                      Switch(
                          value: _mostraKM,
                          onChanged: (value) {
                            setState(() {
                              _mostraKM = value;
                              print(_mostraKM.toString());
                            });
                          })
                    ],
                  ),
                ),*/
                //-------------switch--------------
                //---------------------------------------------------------Form KM-------------------------------------------------------
                Visibility(
                    visible: _mostraKM == true,
                    child:Form(
                      key: _formKey2,
                      child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin:
                          const EdgeInsets.only(left: 16, top: 5, right: 16),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focusKm);
                            },
                            onChanged: (value) {
                             _textEditingControllerMultiplicador.clear();
                            },
                            controller: _textEditingControllerKmIni,
                            //inputFormatters: [maskTextInputFormatter],
                            cursorColor: Colors.black45,
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                            decoration: InputDecoration(
                              //icon: Icon(Icons.monetization_on,color: Colors.black26,size: 20,),
                              border: OutlineInputBorder(),
                              labelText: 'KM Inicial',
                              hintText: "Digite o valor",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Campo Obrigatório';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin:
                          const EdgeInsets.only(left: 16, top: 5, right: 16),
                          child: TextFormField(
                            focusNode: focusKm,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focusKm1);
                            },
                            onChanged: (value) {
                              _textEditingControllerMultiplicador.clear();
                            },
                            controller: _textEditingControllerKmFinal,
                            //inputFormatters: [maskTextInputFormatter],
                            cursorColor: Colors.black45,
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                            decoration: InputDecoration(
                              //icon: Icon(Icons.monetization_on,color: Colors.black26,size: 20,),
                              border: OutlineInputBorder(),
                              labelText: 'KM Final',
                              hintText: "Digite o valor",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Campo Obrigatório';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin:
                          const EdgeInsets.only(left: 16, top: 5, right: 16),
                          child: TextFormField(
                            focusNode: focusKm1,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focus);
                            },
                            onChanged: (value) {
                              int ini = int.parse(
                                  _textEditingControllerKmIni.text);
                              int fina = int.parse(
                                  _textEditingControllerKmFinal.text);
                              print("${ini} + ${fina}");
                              /*if(ini > fina){
                                verificaKmini();
                              }*/
                              double result = soma(fina,ini, double.parse(_textEditingControllerMultiplicador.text));
                              setState(() {
                                _resultSoma = result;
                               // _textEditingControllerValor.text = (result.roundToDouble()*10).toString();
                                _textEditingControllerValor.text = result.toStringAsFixed(2);
                              });
                              print(" Resultado da soma round ${result.roundToDouble()}");
                              print(" Resultado da soma AsString ${result.toStringAsFixed(2)}");
                            },
                            controller: _textEditingControllerMultiplicador,
                            //inputFormatters: [maskTextInputFormatter],
                            cursorColor: Colors.black45,
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                            decoration: InputDecoration(
                              //icon: Icon(Icons.monetization_on,color: Colors.black26,size: 20,),
                              border: OutlineInputBorder(),
                              labelText: 'Média/Valor Combus.',
                              hintText: "Digite o valor (Use ponto)",
                            ),
                            keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Campo Obrigatório';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    )
                ),

                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        /*RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.green)
                                ),
                                color: Colors.orange,
                                child: Text(
                                  "Limpar",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  _textEditingControllerKmIni.clear();
                                  _textEditingControllerKmFinal.clear();
                                  _textEditingControllerMultiplicador.clear();
                                  setState(() {
                                    _resultSoma = 0;
                                  });
                                }),*/

                        //Mostra valor
                       /* Visibility(
                            visible: _resultSoma > 0,
                            child: Text(
                              "Valor do KM rodado R\$ " + _resultSoma.toString(),
                              style:
                              TextStyle(color: Colors.blue, fontSize: 20),
                            )
                        ) */
                        //Mostra valor

                      ],
                    )
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  margin: const EdgeInsets.only(
                      left: 16, top: 6, right: 16, bottom: 16),
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    focusNode: focus,
                    maxLines: 3,
                    controller: _textEditingControllerObs,
                    cursorColor: Colors.black45,
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Obs',
                      hintText: 'Descrição em 3 linhas ',
                    ),
                    keyboardType: TextInputType.text,
                    validator: (_textEditingControllerObs) {
                      if (_textEditingControllerObs.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                ),

                Container(
                  height: 10,
                  color: Colors.black12,
                ),
                /*Padding(padding: EdgeInsets.all(10),
                child: OutlineButton(
                  onPressed: (){
                      //con.listarCidadesFormat();
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => TelaCidades()
                    ));
                  },
                  child: Text('Tela cidades'),
                ),
                ),*/
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //backgroundColor: Colors.green,
        onPressed: () {
          //verificaKmini(int.parse(_textEditingControllerKmIni.text), int.parse(_textEditingControllerKmFinal.text));
          if(_textEditingControllerTipo.text == "Km"){
            if (_formKey.currentState.validate() && _formKey2.currentState.validate()) {
              _imprimeDadosEnviados();
              Center(child: CircularProgressIndicator());
              _showEnviando();
              validador();
            }
          }else{
            if (_formKey.currentState.validate()) {
              _imprimeDadosEnviados();
              Center(child: CircularProgressIndicator());
              /*Get.snackbar("", "ENVIANDO...!",
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  isDismissible: true,
                  dismissDirection: SnackDismissDirection.HORIZONTAL,
                  showProgressIndicator: true,
                  progressIndicatorBackgroundColor: Colors.greenAccent,
                  backgroundColor: Colors.black,
                  overlayColor: Colors.orange,
                  duration: Duration(milliseconds: 3000)
              );*/
              _showEnviando();
              validador();
            }
          }

        },
        //tooltip: 'Pick Image',
        child: Icon(Icons.send,color: Colors.white),
      ),
    );
  }
}
