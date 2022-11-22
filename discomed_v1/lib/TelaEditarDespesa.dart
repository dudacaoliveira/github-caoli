import 'package:discomedv1/CidadesModel.dart';
import 'package:discomedv1/ConexaoBd.dart';
import 'package:discomedv1/EnviarFoto.dart';
import 'package:discomedv1/ListaCidadesRoll.dart';
import 'package:discomedv1/TelaCidades.dart';
import 'package:discomedv1/TelaListarTipos.dart';
import 'package:discomedv1/Urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'Criptografia.dart';
import 'IndexOLD.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'TelaCidadesNovo.dart';
import 'TelaConfiguracoes.dart';
import 'TelaLoginNova.dart';
import 'TiposModel.dart';
import 'UsuarioModel.dart';





class TelaEditarDespesa extends StatefulWidget {
//variáveis que revcebem parametros da Tela Login
  //String _nomeUsuario;
  String codMunicipio;
  String nomeMunicipio;
  String idUsuario;
  String usuarioController;
  String tipo;


  //TelaDespesa(this.tipo,this.codMunicipio,this.nomeMunicipio,this.idUsuario);
  TelaEditarDespesa();

  @override
  _TelaEditarDespesaState createState() => _TelaEditarDespesaState();
}

class _TelaEditarDespesaState extends State<TelaEditarDespesa> {
  static final Controller c = Get.find();
  final _formKey = GlobalKey<FormState>();
  static TextEditingController _textEditingControllerData = new TextEditingController();
  static TextEditingController _textEditingControllerObs = new TextEditingController();
  //static TextEditingController _textEditingControllerValor = new TextEditingController();
  static TextEditingController _textEditingControllerTipo = new TextEditingController();
  static TextEditingController _textEditingControllerCidade = new TextEditingController();
  TextEditingController _textEditingControllerTeste = new TextEditingController();
  //var maskTextInputFormatter = MaskTextInputFormatter(mask: "R\$ ###,##", filter: { "#": RegExp(r'[0-9]') });
  //var controller = new MoneyMaskedTextController(precision:2,leftSymbol: 'R\$ ');
  static TextEditingController _textEditingControllerValor = new MoneyMaskedTextController(precision:2,leftSymbol: 'R\$ ');

  String _vardata = "";
  String _vardataPT;
  Conexao con = new Conexao();
  List<Cidades> listaCid = List();
  String txtData = "";
  File _image = null;
  final picker = ImagePicker();
  String status = '';
  String errMessage = 'Error Uploading Image';
  //String _dataTipo = "";
  String _dataCodMunicipio = Get.parameters["codigoCidade"];
  String _id_Usuario =  Get.parameters['id'];//recebe o id passado na passagem de rota da index icone despesas
  String _nome_Usuario =  Get.parameters['nome'];
  String msg_servidor = "";
  bool visualizaContainer = true;
  String img = "";//variável para imprimir o que tem na var imagem
  String teste1000 = "1000";
  String visiaavel = "KM";//var de teste para mostrar form2
  //-----------------------------------------Parâmetros recebidos da tela Despesas para editar-------------------------

  String _id_DespesaRecu = Get.parameters["_id_DespesaRecu"];
  String  _id_CidadeRecu = Get.parameters["_nome_CidadeRecu"];
  String _id_TipoRecu = Get.parameters["id_TipoRec"];
  String _valorRecu = Get.parameters["_valorRecu"];
  String _imageRecu = Get.parameters["image"];
  String _nomeTipoRecu = Get.parameters["nome_tipo"];
  String _dataTipo = Get.parameters["id_TipoRec"];
  String _Observacao = Get.parameters["obs"];
  String _codigoCidade = Get.parameters["codigoCidade"];
  String _nome = "";
  String _id = "";
  DateTime _date;
  bool dataContainerRed = false;

  //-----------------------------------------------------------------------------------------------------------------

 /* String criptografa(String cryp)  {
    var encodedKey = 'FCAcEA0HBAoRGyALBQIeCAcaDxYWEQQPBxcXHgAFDgY='; //CHAVE EM 256
    var encodedIv = 'DB4gHxkcBQkKCxoRGBkaFA=='; //VETOR INICIALIZAÇÃO
    final Chave = enc.Key.fromBase64(encodedKey); //CRIA CHAVE COM BASE NA STRING EM 256
    final Vetor = IV.fromBase64(encodedIv); //CRIA VETOR COM BASE NA STRING VETOR
    final TipoCriptografia = Encrypter(AES(Chave, mode: AESMode.cbc)); //DEFINE TIPO DE CRIPTOGRAFIA
    final TextoCriptografado = TipoCriptografia.encrypt(cryp, iv: Vetor); //GERA TEXTO CRIPTOGRAFADO
    final String retorno = TextoCriptografado.base64;
    //print("Aqui Cripografa ${retorno}");
    return retorno;
  }//func para descriptografar

  String decrip(String cryp) {
    var encodedKey = 'FCAcEA0HBAoRGyALBQIeCAcaDxYWEQQPBxcXHgAFDgY='; //CHAVE EM 256
    var encodedIv = 'DB4gHxkcBQkKCxoRGBkaFA=='; //VETOR INICIALIZAÇÃO
    final Chave = enc.Key.fromBase64(encodedKey); //CRIA CHAVE COM BASE NA STRING EM 256
    final Vetor = IV.fromBase64(encodedIv); //CRIA VETOR COM BASE NA STRING VETOR
    final TipoCriptografia = Encrypter(AES(Chave, mode: AESMode.cbc)); //DEFINE TIPO DE CRIPTOGRAFIA
    final TextoDescriptografado = TipoCriptografia.decrypt64(cryp, iv: Vetor);
    print("resposta na função decrip: ${TextoDescriptografado.toString()}");
    return TextoDescriptografado;
  }*/

  enviaparametro(String _corpo_json) async {
    //ENVIA TEXTO CRIPTOGRAFADO E DESCRIPTOGRAFA RETORNO
    String url = Urls.url;
    final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
        },
        body: {
          'corpo': criptografa(_corpo_json)
        }
    );

    //------------------Bloco de testes-----------------------
    print("Corpo do JSON from envia parametro"+ _corpo_json);
    print("Corpo do JSON enviado para webservice from envia parametro @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!!!!!"+ criptografa(_corpo_json));
    String a = decrip(response.body).substring(3);
    print("Variável a from enviaparâmetro" + a.toString());
    //------------------Bloco de testes-----------------------

    if(decrip(response.body).substring(0,3)== '01.') {
      Map<String ,dynamic> retorno = json.decode(decrip(response.body).substring(3));
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      String id = retorno["idUsuario"];
      //mapeia para saber o conteúdo da ms e printar "+b"
      Get.defaultDialog(title: "Despesa não enviada!",middleText: "Favor Preencher todos os campos!",middleTextStyle: TextStyle(color: Colors.red));
      return "Erro no enviaparametro: "+b;

}
    else {
      return  decrip(response.body).substring(3);
    }

  }

  void chamaMsgEnviando(){
    Get.snackbar("", "ENVIANDO...!",
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.greenAccent,
        backgroundColor: Colors.black,
        overlayColor: Colors.orange,
        duration: Duration(milliseconds: 3000)
    );
}


  Future <String> _enviaDespesa() async{
    String getVal = _textEditingControllerValor.text;
    String getObs = _textEditingControllerObs.text;
    String imagem;
    print("Imagemmmmmmmmmmmmmmmmmmmm ${_image.toString()}");
    //verifica se tem alguma imagem para codificar para envio
    if(_image!=null){
      print("********* _image não nulla  Criptografa imagem em base64  no enviaDesp Editar");
      imagem = base64Encode(_image.readAsBytesSync());//var do método upload no EnviarFoto
    }

    img = imagem;
    print(" Variável imagem = ${imagem}");
    print(" Variável dataTipo  = ${_dataTipo}");
    //String _fileName = _image.path;
    //_dataTipo = _id_TipoRecu;
      String _corpo_json = jsonEncode(<String, dynamic>{
      //"custo":getVal,
        "custo": _textEditingControllerValor.text,
      "modulo":"c2FsdmFyRGVzcGVzYXM=",
      "id": _id_Usuario,
      "obs": _textEditingControllerObs.text,
      "municipio":"${_dataCodMunicipio}",
      "tipoId":_dataTipo,
      //"tipoId":teste1000,
      "data":"${_date.toString()}",
      "image": imagem,
      "idDespesa":_id_DespesaRecu,
        "kmF": _textEditingControllerKmIni.text,
        "KmI": _textEditingControllerKmFinal.text,
        "mult": _textEditingControllerMultiplicador.text,
    });
    Conexao con =  new Conexao();//Instacia objeto "con"
    Database db = await con.recuperarBanco();// objeto "con" abre a conexão
    //con.salvarDespesa(int.parse(_dataTipo), int.parse(_dataCodMunicipio), _vardata, 4002587841,getVal,_textEditingControllerObs.text, db);
    print("************* Print do valor dentro do Create Tela Despesa " + getVal);
    print("************* Print da Obs dentro do Create Tela Despesa " + getObs);
    //print(_corpo_json);
    //envia corpo json webservice
    String a = await enviaparametro(_corpo_json);

    if (a.substring(0,1) == "E") {
      print ("-------------Erro de envio--------------" + decrip(a).toString());
    }
    else  {
      //tratar para decodificar json
      Map<String ,dynamic> retornoDespesa = json.decode(a);
      String c = retornoDespesa["status"].toString();
      String retornoCreate = a;
      print("**********Else do método _enviaDespesa *********** " + a.toString());
      print("Mensagem de Status da despesa evnciada " + c.toString());
      if(c.toString() == 'true'){
        _showModalBottomSheetDespEnv();
      }else{
        Get.snackbar("Falha", "Mensagem não enviada!",
            backgroundColor: Colors.red);
      }
      // _showDialogDespesaEnviada();
    }

  }//enviaDespesa

  //------------------------------------------------------EnviaImagens---------------------------------------------------------------------

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera,
        maxHeight: 1024,
        maxWidth: 768,
        imageQuality: 80);
    setState(() {
      _image =  new File(pickedFile.path);
      print("EEEEEEEEEEEEEEE${_image.toString()}");
    });
    setStatus('');
  }

  Future getImageGalery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,
        maxHeight: 1024,
        maxWidth: 768,
        imageQuality: 80);

    setState(() {
      _image =  new File(pickedFile.path);
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

  List<DropdownMenuItem<String>> _getDropDownMenuItems(){
    List<DropdownMenuItem<String>> items = new List();
    items.add(new DropdownMenuItem(
        onTap:(){
          print("Clicou");
        },
        value: '',
        child: new Text("Selecione",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black26,
          ),
        )
    )
    );
    items.add(new DropdownMenuItem(
        value: 'RS',
        child: new Text("Rio Grande do Sul")));
    items.add(new DropdownMenuItem(
        value: 'SC',
        child: new Text("Santa Catarina")));
    items.add(new DropdownMenuItem(
        value: 'PR',
        child: new Text("Paraná")));
    return items;
  }

  void changedDropDownItem(String selectedItem){
    setState(() {
      _statusSel = selectedItem;
    });
  }


/*  @override
  void initState() {
    _dropDownMenuItems = _getDropDownMenuItems();
    _statusSel = _dropDownMenuItems[0].value;
    super.initState();
  }*/


  List<TiposDespesa> items = new List();
  Conexao db = new Conexao();


  @override
  void initState() {
    super.initState();
    _textEditingControllerObs.text = utf8.decode(_Observacao.toString().codeUnits);
    _textEditingControllerCidade.text = _id_CidadeRecu;
    _textEditingControllerValor.text = _valorRecu;
    _textEditingControllerTipo.text = _nomeTipoRecu;
    print("###### Valor da variável _nomeTipoRecu no initState TelaEditarDespesa para tetar no Visibility Form2= ${_nomeTipoRecu} ");
    db.getAllTiposDesp().then((notes) {
      setState(() {
        notes.forEach((note) {
          items.add(TiposDespesa.fromMap(note));

        });
      });
    });
  }


/*  void textoCidade(){
    if((Get.parameters['nomeMun'])!=null){
      _txtCidade = "${Get.parameters['nomeMun']}";
    }
  }*/

  /*void textoCidade(){
    if("{${c1.nomecidadeController}" !=null){
      _txtCidade = "${c1.nomecidadeController}";
    }else{
      _txtCidade = "";
    }
  }*/

  /*void textoTipo(){
    if((Get.parameters['tipo'])!=null){
      _txtTipo = "${Get.parameters['tipo']}";
    }
  }*/

  void limpaCampos(){
    setState(() {
      _image = null;//aqui eu mudo o estado da foto para null depois que foi enviada
      //_txtTipo = " ";
      //_txtCidade = " ";
      _dataTipo = "";
      _dataCodMunicipio = " ";
      txtData = '';
      _textEditingControllerData.clear();
      _textEditingControllerObs.clear();
      _textEditingControllerValor.clear();
      _textEditingControllerCidade.clear();
      _textEditingControllerTipo.clear();
    });
  }

  _showDialogDespesaEnviada(){
    Get.defaultDialog(
      backgroundColor: Colors.white70,
      radius: 20,
      //onConfirm: () =>  Get.toNamed("/index"),
      onConfirm: (){
        Get.toNamed("/index");
        limpaCampos();
      },
      onCancel:  () {
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

  _showModalBottomSheetDespEnv(){
    String nomeUsuario = _buscaUsuario();
    showModalBottomSheet(context: context,
        builder: (BuildContext context){
          return Container(
            child:Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Text("Enviada com sucesso",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black
                    ),
                  ),
                  Text("Despesa Editada com Sucesso!",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CupertinoButton(
                        //color: Colors.red,
                        child: Text("OK",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                          ),
                        ),
                        onPressed: () {
                          limpaCampos();
                          List<Usuario> usus = new List();
                          db.getAllUsuario().then((notes) {
                            setState(() {
                              notes.forEach((note) {
                                usus.add(Usuario.fromMap(note));
                                print("{----------------Procura usuários no banco no método _buscaUsuario tela editarDespesa-------------------");
                                print("usuários cadastrados = ${usus.length}");
                                for(Usuario u in usus){
                                  _nome = u.nome;
                                  _id = u.id;
                                  print("Nome: " + u.nome + "|" + "ID: " + u.id + "|" + "Status Logado: " + u.status);
                                  print("Nome do usuario que o método retorna = " + u.nome + _nome);
                                  print("----------------Procura usuários no banco no método _buscaUsuario-------------------}");
                                }
                                print("Nome buscado = " + _nome );
                                Get.offAllNamed("/index?device=phone&nome=${_nome}&id=${_id}");
                              });
                            });
                          });
                          //Navigator.pop(context);
                        },
                      ),
                      /*CupertinoButton(
                        //color: Colors.green,
                        child: Text("Sim",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            )
                        ),
                        onPressed: () {
                          limpaCampos();
                          Navigator.pop(context);

                        },
                      ),*/
                    ],
                  )
                ],
              ),
            ),

            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
            ),
          );
        });
  }


  _showModalBottomSheetTipos(){
    _textEditingControllerTipo.text = items[0].tipo;
    showModalBottomSheet(context: context,
        builder: (BuildContext context){

          return Container(
            child:
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    CupertinoButton(
                      //color: Colors.red,
                      child: Text("Cancel",
                        style: TextStyle(
                            color: Colors.red
                        ),
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
                        if(_textEditingControllerTipo.text.isEmpty){
                          setState(() {
                            setState(() {
                              _dataTipo = items[0].id;
                              _textEditingControllerTipo.text = items[0].tipo;
                            });
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
                    child: CupertinoPicker(itemExtent: 48,onSelectedItemChanged: (dynamic index){
                      setState(() {
                        _dataTipo = items[index].id;
                        _textEditingControllerTipo.text = items[index].tipo;
                      });

                    }, children: new List<Widget>.generate(
                        items.length, (int index) {
                      return new Center(
                        child: new Text("${items[index].tipo}",
                          style: TextStyle(
                              color: Colors.orange
                          ),
                        ),
                      );
                    })
                    ),
                  ),
                ),
              ],
            ),

            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
            ),
          );
        });
  }

  void validadorEditaDesp(){
    print("Imprime Cidade em ValidadorEditaDesp ${_textEditingControllerCidade.text}");
    if(_textEditingControllerValor.text.isEmpty ||
        _vardataPT == null || _textEditingControllerCidade.text.isEmpty){
      Get.defaultDialog(title: "Há campos vazios!",middleText: "Favor Preencher todos os campos!",middleTextStyle: TextStyle(color: Colors.red));
      setState(() {
        dataContainerRed = true;
       // pintar o container de red para avisar
      });
    }
    else{
      _enviaDespesa();
    }
  }//fim validator

  void _imprimeDadosEnviados(){
    print("-------------------------------------------------");
    print("*************Dados capturados para enviar Edita _imprimeDadosEnviados() ************** !");
    print("código da cidade ${_dataCodMunicipio}");
    print("Id do tipo:${_dataTipo}");
    print("Valor" + _textEditingControllerValor.text);
    print("${_date}");
    print(_vardataPT);
    print("id do usuário ${_id_Usuario}");
    print("Obs: " + _textEditingControllerObs.text);
    print("Var img: ${img}");
    print("-------------------------------------------------");
  }

    String _buscaUsuario(){
    String _nome = "";
    String _id = "";
    List<Usuario> usus = new List();
    db.getAllUsuario().then((notes) {
      setState(() {
        notes.forEach((note) {
          usus.add(Usuario.fromMap(note));
          print("----------------Procura usuários no banco no ## método ## _buscaUsuario-------------------");
          print("usuários cadastrados = ${usus.length}");
          for(Usuario u in usus){
            print("Nome: " + u.nome + "|" + "ID: " + u.id + "|" + "Status Logado: " + u.status);
          }
        });
      });
      for(var u in usus){
        print("Nome do usuario que o método retorna = " + u.nome);
        print("----------------Procura usuários no banco no ## método ## _buscaUsuario-------------------");
        _nome = u.nome;
        _id = u.id;
      }
    });
    return _nome;
  }

  void _showDatePicker(BuildContext context){
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
                              //txtData = _date.toString();
                              txtData = _vardataPT;
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

  double soma(int fi, int ini, double mul) {
    double res;
    res = (((fi - ini)/10) * mul);
    return res;
  }

  final _formKey2 = GlobalKey<FormState>();
  double _resultSoma = 0;
  final focus = FocusNode();
  final focusKm = FocusNode();
  final focusKm1 = FocusNode();
  final focusKm2 = FocusNode();
  //static TextEditingController _textEditingControllerValor = new MoneyMaskedTextController(precision: 2, leftSymbol: 'R\$ ');
  TextEditingController _textEditingControllerKmIni = new TextEditingController();
  TextEditingController _textEditingControllerKmFinal = new TextEditingController();
  TextEditingController _textEditingControllerMultiplicador = new TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.blue,),onPressed: (){Navigator.pop(context);},),
        title: Text("Editar Despesa",style: TextStyle(color: Colors.blue),),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[

          Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Center(
                  child: _image == null
                      ? null
                      : Padding(padding: EdgeInsets.all(10),
                    child: Image.file(_image,
                      //height: 280,
                      fit: BoxFit.fill,
                    ),
                  )
              ),
              Visibility(
                visible: visualizaContainer == true,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Image.network(
                      //'http://discomed.com.br/extranet/modulos/despesas/imgs/8090066655f5f9777ca9f05.29638799.jpg',
                      'https://discomed.com.br/extranet/modulos/despesas/imgs/${_imageRecu}',
                      fit: BoxFit.fill,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace){
                    return Text("Recuperou uma despesa sem Imagem!!!");
                    },
                      //height: 400,
                    )
                  ),
                ),
              )
            ],
          ),
          Container(
            decoration: BoxDecoration(
              //border: Border.all(color: Colors.black12)
            ),
            //color: Colors.black12,
            width:MediaQuery.of(context).size.width,
            height:70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width:MediaQuery.of(context).size.width,
                  //color: Colors.amberAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(1),
                        child:IconButton(icon: Icon(Icons.photo,
                          size:50,
                          color: Colors.lightBlueAccent,
                        ),
                            onPressed: (){
                              getImageGalery();
                              setState(() {
                                visualizaContainer = false;
                              });
                            }
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(1),
                        child: IconButton(icon: Icon(Icons.photo_camera,
                          size: 50,
                          color: Colors.lightBlueAccent,
                        ),
                            onPressed: (){
                              getImageCamera();
                              setState(() {
                                visualizaContainer = false;
                              });
                            }
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //DataPicker Aqui existe um container acima do textfield Data para inserir uma data também
              /*Padding(
                padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    child:Container(
                      color: Colors.black12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Clique para inserir uma data"),
                          IconButton(icon: Icon(Icons.date_range),
                            onPressed: null
                          ),
                        ],
                      ),
                    ),
                    onTap: ()async{

                      final data = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2029),
                        //locale: Locale("pt","BR"),
                        locale: Localizations.localeOf(context),

                      );
                      _vardata = data.toString();
                      *//*if(data!= null){
                        final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY,"pt_Br").format(data);
                        _vardataPT = datapt; // aqui a vardata recebe a data formatada pelo código acima
                      }*//*
                      final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY,"pt_Br").format(data);
                      _vardataPT = datapt; // aqui a vardata recebe a data formatada pelo código acima
                      setState(() {
                       // _textEditingControllerData.text = _vardataPT;
                        txtData = _vardataPT;
                      });//seta a data no campo Data
                    },

                  ),
              ),*/
              /*Padding(
                padding: EdgeInsets.all(5),
                child: OutlineButton(
                  color: Colors.transparent,
                    child: Text("Inserir Data",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink
                    ),
                    ),
                    onPressed: ()async{
                  final data = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2029),
                    //locale: Locale("pt","BR"),
                    locale: Localizations.localeOf(context),
                  );
                  _vardata = data.toString();
                  *//*if(data!= null){
                          final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY,"pt_Br").format(data);
                          _vardataPT = datapt; // aqui a vardata recebe a data formatada pelo código acima
                        }*//*
                  final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY,"pt_Br").format(data);
                  _vardataPT = datapt; // aqui a vardata recebe a data formatada pelo código acima
                  setState(() {
                    // _textEditingControllerData.text = _vardataPT;
                    txtData = _vardataPT;
                  });
                }
                ),
              ),*/
              GestureDetector(
                onTap: ()async{
                  _date = DateTime.now();
                      setState(() {
                        dataContainerRed = false;
                        final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_date);
                        _vardataPT = datapt; // aqui a vardata recebe a data formatada pelo código acima
                        //txtData = _date.toString();
                        txtData = _vardataPT;
                      });
                  _showDatePicker(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2,color:dataContainerRed == true ? Colors.red :Colors.black12),
                          /*gradient: LinearGradient(colors:[
                          Color(0xFF00BFFF),
                          Color(0xFFFFDDDD)
                        ]
                        ),*/
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)
                          )
                      ),
                      //color: Colors.blueGrey,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Clique para inserir uma data",
                                style: TextStyle(
                                    color: Colors.black45
                                ),
                              ),
                              IconButton(
                                //onPressed: (){},
                                icon: Icon(Icons.date_range),
                                color: Colors.black45,
                                iconSize: 30,
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10),
                            child: Text(txtData,
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                              textAlign: TextAlign.center,),
                          ),
                        ],
                      )
                  ),
                ),
              ),
              Visibility(
                visible: dataContainerRed == true,
                child: Container(

                  color: Colors.red,
                  height: 2,
                ),
              ),

              //-------------------------

              Divider(),

              Container(
                height: 10,
                color: Colors.black12,
              ),
              Divider(),
              /*GestureDetector(
                onTap: (){
                  Get.bottomSheet(
                      Container(
                        color: Colors.blue,// cor do bottomsheet
                        height: 200,
                        child: Wrap(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top:10,left: 150),
                              child: Text("Selecione o Estado",
                                textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                              ),
                            ),
                            Divider(
                              color: Colors.blue[100],
                            ),
                            ListTile(
                                leading: Icon(Icons.public,
                                  //color: Colors.white,
                                ),
                                title: Text('PR',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),),
                                onTap: () async{
                                  final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TelaCidades(text:"PR"),
                                      ));

                                  // after the SecondScreen result comes back update the Text widget with it

                                  if(result!=null){
                                    setState(() {
                                      _txtCidade = result[0];
                                      _dataCodMunicipio = result[1];
                                    });
                                  }
                                  Navigator.pop(context);//fecha o bottomsheet
                                }
                            ),
                            ListTile(
                                leading: Icon(Icons.public),
                                title: Text('SC',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                onTap:  () async{
                                  final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TelaCidades(text:"SC"),
                                      ));

                                  // after the SecondScreen result comes back update the Text widget with it
                                  if(result!=null){
                                    setState(() {
                                      _txtCidade = result[0];
                                      _dataCodMunicipio = result[1];
                                    });
                                  }
                                  Navigator.pop(context);//fecha o bottomsheet
                                }
                            ),
                            ListTile(
                                leading: Icon(Icons.public),
                                title: Text('RS',
                                style: TextStyle(
                                    color: Colors.white
                                ),),
                                onTap: () async{
                                  final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TelaCidades(text:"RS"),
                                      ));

                                  // after the SecondScreen result comes back update the Text widget with it
                                  if(result!=null){
                                    setState(() {
                                      _txtCidade = result[0];
                                      _dataCodMunicipio = result[1];
                                    });
                                  }
                                  Navigator.pop(context);//fecha o bottomsheet
                                }

                            ),
                          ],
                        ),
                      ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(width: 2,color: Colors.black12),

                          borderRadius: BorderRadius.all(
                              Radius.circular(10)
                          )
                      ),
                      //color: Colors.blueGrey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 22),
                                child: Text("Cidade",
                                  style: TextStyle(
                                      color: Colors.black45
                                  ),
                                ),
                              ),
                              Text("${_txtCidade}")
                            ],
                          ),
                        ],
                      )
                  ),
                ),
              ),*/
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
                child: TextFormField(
                  readOnly: true,
                  onTap: (){
                    Get.bottomSheet(
                      Container(

                        decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)
                            )
                        ),
                        height: 210,
                        child: Wrap(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top:10,left: 150),
                              child: Text("Selecione o Estado",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            ListTile(
                                leading: Icon(Icons.public,
                                  //color: Colors.white,
                                ),
                                title: Text('PR',
                                  style: TextStyle(
                                      color: Colors.deepOrange
                                  ),
                                ),
                                onTap: () async{
                                  final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TelaCidades(text:"PR"),
                                      ));

                                  if(result!=null){
                                    setState(() {
                                      _textEditingControllerCidade.text = result[0];//pega o nome da cidade
                                      //_txtCidade = result[0];
                                      _dataCodMunicipio = result[1];// pega o código da cidade
                                    });
                                  }
                                  Navigator.pop(context);//fecha o bottomsheet
                                }
                            ),
                            ListTile(
                                leading: Icon(Icons.public),
                                title: Text('SC',
                                  style: TextStyle(
                                      color: Colors.deepOrange
                                  ),
                                ),
                                onTap:  () async{
                                  final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TelaCidades(text:"SC"),
                                      ));

                                  // after the SecondScreen result comes back update the Text widget with it
                                  if(result!=null){
                                    setState(() {
                                      _textEditingControllerCidade.text = result[0];//pega o nome da cidade
                                      //_txtCidade = result[0];
                                      _dataCodMunicipio = result[1];// pega o código da cidade
                                    });
                                  }
                                  Navigator.pop(context);//fecha o bottomsheet
                                }
                            ),
                            ListTile(
                                leading: Icon(Icons.public),
                                title: Text('RS',
                                  style: TextStyle(
                                      color: Colors.deepOrange
                                  ),
                                ),
                                onTap: () async{
                                  final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TelaCidades(text:"RS"),
                                      ));

                                  // after the SecondScreen result comes back update the Text widget with it
                                  if(result!=null){
                                    setState(() {
                                      _textEditingControllerCidade.text = result[0];// pega o nome da cidade
                                      //_txtCidade = result[0];
                                      _dataCodMunicipio = result[1];// pega o código da cidade
                                    });
                                  }
                                  Navigator.pop(context);//fecha o bottomsheet
                                }

                            ),
                          ],
                        ),

                      ),
                    );
                  },
                  controller: _textEditingControllerCidade,
                  cursorColor: Colors.black45,
                  style: TextStyle(
                    color: Colors.black45,
                  ),
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

              /*GestureDetector(
                onTap: () async{
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaListarTipos(),
                      ));

                  // after the SecondScreen result comes back update the Text widget with it
                  if(result!=null){
                    setState(() {
                      _txtTipo = result[0];
                      _dataTipo = result[1];
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                      height: 50,

                      decoration: BoxDecoration(
                          border: Border.all(width: 2,color: Colors.black12),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)
                          )
                      ),
                      //color: Colors.blueGrey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(

                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left:10,right: 22),
                                child: Text("Tipo Despesa",
                                  style: TextStyle(
                                      color: Colors.black45
                                  ),
                                ),
                              ),
                              Text("${_txtTipo}"),
                            ],
                          ),
                        ],
                      )
                  ),
                ),
              ),*/
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
                child: TextFormField(
                  readOnly: true,
                  onTap: ()async{
                    _showModalBottomSheetTipos();//chama o BottomSheet tipos
                  },
                  controller: _textEditingControllerTipo,
                  cursorColor: Colors.black45,
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tipo despesa',
                    hintText: 'Café,Trasporte etc.',
                  ),

                ),

              ),


              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
                child: TextFormField(
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
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Campo Obrigatório';
                    }
                    return null;
                  },
                ),
              ),
              Visibility(
                visible: _nomeTipoRecu  == "Km",
                child: Form(
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
                            /*double result = soma(
                                int.parse(
                                    _textEditingControllerKmFinal.text),
                                int.parse(_textEditingControllerKmIni.text),
                                double.parse(
                                    _textEditingControllerMultiplicador.text));
                            setState(() {
                              _resultSoma = result;
                              _textEditingControllerValor.text = (result*10).toString();
                            });
                            print(result);*/
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
                           /* double result = soma(
                                int.parse(
                                    _textEditingControllerKmFinal.text),
                                int.parse(_textEditingControllerKmIni.text),
                                double.parse(
                                    _textEditingControllerMultiplicador.text));
                            setState(() {
                              _resultSoma = result;
                              _textEditingControllerValor.text = (result*10).toString();
                            });
                            print(result);*/
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
                            double result = soma(
                                int.parse(
                                    _textEditingControllerKmFinal.text),
                                int.parse(_textEditingControllerKmIni.text),
                                double.parse(
                                    _textEditingControllerMultiplicador.text));
                            setState(() {
                              _resultSoma = result;
                              //_textEditingControllerValor.text = (result.roundToDouble()*10).toString();
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
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: const EdgeInsets.only(left: 16, top: 6, right: 16,bottom: 16),
                child: TextFormField(
                  //autofocus: false,
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
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: (){
          /*if (_formKey.currentState.validate()) {
          }*/
          _imprimeDadosEnviados();
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
          chamaMsgEnviando();
          validadorEditaDesp();

          /*List<Usuario> usus = new List();
          db.getAllUsuario().then((notes) {
            setState(() {
              notes.forEach((note) {
                usus.add(Usuario.fromMap(note));
                print("{----------------Procura usuários no banco no método _buscaUsuario-------------------");
                print("usuários cadastrados = ${usus.length}");
                for(Usuario u in usus){
                  _nome = u.nome;
                  _id = u.id;
                  print("Nome: " + u.nome + "|" + "ID: " + u.id + "|" + "Status Logado: " + u.status);
                  print("Nome do usuario que o método retorna = " + u.nome + _nome);
                  print("----------------Procura usuários no banco no método _buscaUsuario-------------------}");
                }
                print("Nome buscado = " + _nome );
                Get.toNamed("/index?device=phone&nome=${_nome}&id=${_id}");
              });
            });
          });*/
        },
        //tooltip: 'Pick Image',
        child: Icon(Icons.send,color: Colors.white,),
      ),

    );
  }
}

