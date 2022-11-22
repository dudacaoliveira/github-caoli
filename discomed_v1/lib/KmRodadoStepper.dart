import 'dart:convert';
import 'dart:io';

import 'package:discomedv1/ConexaoBd.dart';
import 'package:discomedv1/TelaListaHospitais.dart';
import 'package:discomedv1/Urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snack.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'Criptografia.dart';
import 'ModelsKmRodado/Km.dart';
import 'ModelsKmRodado/Local.dart';
import 'ModelsKmRodado/LocalEsp.dart';
import 'PessoaModel.dart';
import 'TelaCidades.dart';
import 'TelaTurnos.dart';

class KmRodadoStepper extends StatefulWidget {
  @override
  _KmRodadoStepperState createState() => _KmRodadoStepperState();
}

class _KmRodadoStepperState extends State<KmRodadoStepper> {


  DateTime _date;
  String txtData = "";
  String _vardataPT;
  String _idRegistro = " ";
  String _objJsonGlobal = "";
  String _lblDataPicker = "Insira a data";
  String _txtCidade = "";
  String _dataCodMunicipio = " ";

  List _tarefas = [];
  Map<String,dynamic> pessoasMap = Map();
  List <Pessoa>contaPessoas = [];
  var locais = [];
  var lista = [];
  List<Pessoa> listaPessoa = new List();

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  String _id_Usuario = Get.parameters['id'];
  String _nome_Usuario = Get.parameters['nome'];

  final focusKmIni = FocusNode();
  final focusKmFinal = FocusNode();
  final focusKmLocal = FocusNode();
  final focusLocalEsp = FocusNode();
  final focusKmTurn = FocusNode();
  final focusKmPessoa = FocusNode();
  final focusObs = FocusNode();

  TextEditingController _textEditingControllerPessoa = new TextEditingController();
  TextEditingController _textEditingControllerLocal = new TextEditingController();
  TextEditingController _textEditingControllerObs = new TextEditingController();
  TextEditingController _textEditingControllerLocalEspec = new TextEditingController();
  TextEditingController _textEditingControllerTurno = new TextEditingController();
  TextEditingController _textEditingControllerKmIni = new TextEditingController();
  TextEditingController _textEditingControllerFinal = new TextEditingController();
//--------------------------------------------------------------------------------------------------------------------------------
  List<Step> steps= [
    Step(
        title: Text("LocalEspec"),
        isActive: true,
        state: StepState.complete,
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Password"),
            )
          ],
        )
    ),
    Step(
        title: Text("LocalEspec"),
        isActive: true,
        state: StepState.complete,
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Password"),
            )
          ],
        )
    ),
    Step(
        title: Text("Pessoas"),
        isActive: true,
        state: StepState.complete,
        content: Column(
          children: [
            Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email",border: OutlineInputBorder(),suffixIcon: Icon(Icons.email)),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Password",border: OutlineInputBorder(),suffixIcon: Icon(Icons.visibility)),
                  )
                ],
              ),
            )
          ],
        )
    ),
    Step(
        title: Text("Novo"),
        isActive: true,
        state: StepState.complete,
        content: Column(
          children: [
            Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email",border: OutlineInputBorder(),suffixIcon: Icon(Icons.email)),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Password",border: OutlineInputBorder(),suffixIcon: Icon(Icons.visibility)),
                  )
                ],
              ),
            )
          ],
        )
    ),
  ];
//---------------------------------------------------------------------------------------------------------------------------------

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
                      /*setState(() {
                        final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_date);
                        _vardataPT = datapt; // aqui a vardata recebe a data formatada pelo código acima
                        //txtData = _date.toString();
                        txtData = _vardataPT;
                        _lblDataPicker = txtData;
                      });*/
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
                              _lblDataPicker = txtData;
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

  StepperType stepperType = StepperType.horizontal;
  int currentStep = 0;
  bool complete =  false;
  
  next(){
    print("Tamanho da lista de steps " + steps.length.toString());
    currentStep + 1 != steps.length
        ? goTo(currentStep + 1)
        : setState(() => complete =  true);
  }

  calcel(){
    if(currentStep > 0){
      goTo(currentStep - 1);
    }
  }

   addNewLocal(){
     setState(() {
       goTo(currentStep - 2);
       _textEditingControllerLocal.clear();
       _textEditingControllerLocalEspec.clear();
       _textEditingControllerTurno.clear();
       _textEditingControllerPessoa.clear();
       _textEditingControllerObs.clear();
     });
  }

  addNewKm(){
    setState(() {
      goTo(currentStep - 3);
      _textEditingControllerLocal.clear();
      _textEditingControllerLocalEspec.clear();
      _textEditingControllerTurno.clear();
      _textEditingControllerPessoa.clear();
      _textEditingControllerObs.clear();
    });
  }

  addNewLocalEsp(){
    setState(() {
      goTo(currentStep - 1);
      _textEditingControllerLocalEspec.clear();
      _textEditingControllerTurno.clear();
      _textEditingControllerPessoa.clear();
      _textEditingControllerObs.clear();
    });
  }

  goTo(int step){
    setState(() => currentStep = step);
  }

  //função que troca os tipos "Horizontal ou Vertical"
  switchStepType(){
    setState(() => stepperType == StepperType.horizontal
        ? stepperType = StepperType.vertical
        : stepperType = StepperType.horizontal
    );

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
        _textEditingControllerTurno.text = result;
        //_txtCidade = result[0];
        //_dataCodMunicipio = result[1];
      });
    }
    //Navigator.pop(context); //fecha o bottomsheet
    return result;
  }

  //----------------------------------Cria Arquivo Local Com o Objeto Km-----------------
  /*void _addTodo2(){
    int contaPessoasAux = 0;
    int kmIaux;
    int kmFaux;
    print("CHAMADO O MÉTODO addtodo2! linha 304 arquivo KmRodadeStepper");
    setState(()async{
      Conexao con = new Conexao();
      Database db = await con.recuperarBanco();
      Map<String,dynamic> novaTarefa = Map();
      novaTarefa["kmIni"] = _textEditingControllerKmIni.text;
      novaTarefa["kmFinal"] = _textEditingControllerFinal.text;
      novaTarefa["idRegistro"] = _idRegistro;
      novaTarefa["dataEditada"] = txtData;
      novaTarefa["qtde"] = contaPessoas.length;
      novaTarefa["lista"] = contaPessoas;
      //_tarefas.add(novaTarefa);// adiciona o mapa newTodo na lista _todoList
      //_saveData();//método que escreve no arquivo
      contaPessoasAux = contaPessoas.length;
      kmIaux = int.parse(_textEditingControllerKmIni.text);
      kmFaux = int.parse(_textEditingControllerFinal.text);
      //verifica se a lista está vazia para gravar no banco
      if(contaPessoas.isNotEmpty){
        for(Pessoa p in contaPessoas){
          print(p.nome);
          con.salvarpessoa(p.nome, p.observacao ,int.parse(_idRegistro), db);
          //salva lista bde pessoas com o id da km retornado pela API
        }
      }else{
        print("Lista Vazia!!!!");
      }
      //salva km no banco
      con.salvarkmRodado(int.parse(_idRegistro) , kmIaux , kmFaux, txtData, contaPessoasAux,DateTime.now().toString().substring(0,19), db);
      _showModalBottomSheetKmEnv();
    });
    // variável a retorna verdadeiro se o métdo gravarPessoa foi executado com sucesso
    //bool a =   await gravaPessoas();
    //print(a);
    print("=======================================Qtde pessoas ${contaPessoasAux}");

  }*/


  void _addTodo2()async{
    int contaPessoasAux = 0;
    int kmIaux;
    int kmFaux;
    print("CHAMADO O MÉTODO addtodo2! linha 347 do  arquivo KmRodadeStepper");
    setState((){

      Map<String,dynamic> novaTarefa = Map();
      novaTarefa["kmIni"] = _textEditingControllerKmIni.text;
      novaTarefa["kmFinal"] = _textEditingControllerFinal.text;
      novaTarefa["idRegistro"] = _idRegistro;
      novaTarefa["dataEditada"] = txtData;
      novaTarefa["qtde"] = listaPessoaGlobal.length;
      novaTarefa["lista"] = listaPessoaGlobal;
      //_tarefas.add(novaTarefa);// adiciona o mapa newTodo na lista _todoList
      //_saveData();//método que escreve no arquivo
      contaPessoasAux = listaPessoaGlobal.length;
      kmIaux = int.parse(_textEditingControllerKmIni.text);
      kmFaux = int.parse(_textEditingControllerFinal.text);
      //verifica se a lista está vazia para gravar no banco

    });
    Conexao con = new Conexao();
    Database db = await con.recuperarBanco();
    if(listaPessoaGlobal.isNotEmpty){
      print("Pessoas para gravar no banco! Método addTodo2");
      for(Pessoa p in listaPessoaGlobal){
        print(p.nome);
        con.salvarpessoa(p.nome, p.observacao ,int.parse(_idRegistro), db);
        //salva lista bde pessoas com o id da km retornado pela API
      }
    }else{
      print("Lista Vazia!!!!");
    }
    //salva km no banco
    con.salvarkmRodado(int.parse(_idRegistro) , kmIaux , kmFaux, txtData, contaPessoasAux,DateTime.now().toString().substring(0,19), db);
    _showModalBottomSheetKmEnv();

    // variável a retorna verdadeiro se o métdo gravarPessoa foi executado com sucesso
    //bool a =   await gravaPessoas();
    //print(a);
    print("=======================================Qtde pessoas ${contaPessoasAux}");

  }


  void _addTodo()async{
    Conexao con = new Conexao();
    Database db = await con.recuperarBanco();
    int contaPessoasAux = 0;
    int kmIaux;
    int kmFaux;
    int fkaUX;
    print("CHAMADO O MÉTODO addtodo!");
    Map<String,dynamic> novaTarefa = Map();
    novaTarefa["kmIni"] = _textEditingControllerKmIni.text;
    novaTarefa["kmFinal"] = _textEditingControllerFinal.text;
    novaTarefa["idRegistro"] = _idRegistro;
    novaTarefa["dataEditada"] = txtData;
    novaTarefa["qtde"] = contaPessoas.length;
    novaTarefa["lista"] = contaPessoas;
    //_tarefas.add(novaTarefa);// adiciona o mapa newTodo na lista _todoList
    //_saveData();//método que escreve no arquivo
    contaPessoasAux = contaPessoas.length;
    kmIaux = int.parse(_textEditingControllerKmIni.text);
    kmFaux = int.parse(_textEditingControllerFinal.text);
    fkaUX = int.parse(_idRegistro);
    //verifica se a lista está vazia para gravar no banco
    if(contaPessoas.isNotEmpty){
      for(Pessoa p in contaPessoas){
        print(p.nome);
        con.salvarpessoa(p.nome, p.observacao ,fkaUX, db);
        //salva lista bde pessoas com o id da km retornado pela API
      }
    }else{
      print("Lista Vazia!!!!");
    }
    //salva km no banco
    con.salvarkmRodado(int.parse(_idRegistro) , kmIaux , kmFaux, txtData, contaPessoasAux,DateTime.now().toString().substring(0,19), db);
    // variável a retorna verdadeiro se o métdo gravarPessoa foi executado com sucesso
    //bool a =   await gravaPessoas();
    //print(a);
    print("=======================================Qtde pessoas ${contaPessoasAux}");

  }

  Future gravaPessoas()async{
    print("Entrou na func gravaPessoas");
    print("Qtde de pessoas na func gava pessoas ${contaPessoas.length}");
    Conexao con = new Conexao();
    if(contaPessoas.isNotEmpty){
      Database db2 = await con.recuperarBanco();
      for(Pessoa p in contaPessoas){
        print(p.nome);
        print(p.observacao);
        print(int.parse(_idRegistro));
        //con.salvarpessoa(x.nome, x.observacao, 123, db2);
        con.salvarpessoa("Cadu1000", "Obs 1000" ,19, db2);
      }
    }else{
      print("Lista Vazia!!!!");
    }
    return true;
  }

  Future<File> _getFile()async{
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }
  Future<File> _saveData() async{
    String data = json.encode(_tarefas); // pega a lista _todoList converte em um json e armazena na String para gravar no arquivo
    final file = await _getFile(); //o objeto aponta para o arquivo armazenado....
    return file.writeAsString(data); // função que escreve os dados da variável "data" no objeto file
  }

  Future<String> _readData()async{
    try{
      final file = await _getFile();
      return file.readAsString();
    }catch(e){
      print("Erro : ${e.toString()}");
    }
  }
  //---------------------------------------------------------------
  _showModalBottomSheetKmEnv() {
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
                    "Deseja enviar outra Kilometragem?",
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
                          Navigator.pop(context);//fecha o diálogo bottomsheet
                          Navigator.pop(context);//fecha a tela
                        },
                      ),
                      CupertinoButton(
                        //color: Colors.green,
                        child: Text("Sim",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green)),
                        onPressed: () {
                          addNewKm();
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

  _showModalBottomSheetAddPessoa(String p,List lista) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "${p} adicionado(a) a Lista",
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                  Text(
                    "Deseja inserir outra Pessoa?",
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
                          LocalEsp localEspObj = LocalEsp(_textEditingControllerLocalEspec.text, lista, _textEditingControllerTurno.text);
                          listaLocalEspcGlobal.add(localEspObj);
                          print(listaLocalEspcGlobal);
                          Navigator.pop(context);
                          contaPessoas = [];
                          _showModalBottomSheetAddLocEsp();

                        },
                      ),
                      CupertinoButton(
                        //color: Colors.green,
                        child: Text("Sim",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green)),
                        onPressed: () {
                          // adicionar pessoas aqui
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

  _showModalBottomSheetAddLocEsp() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Text(
                    "Inserir outro Local Específico?",
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
                          Local locObj = Local(_textEditingControllerLocal.text, listaLocalEspcGlobal);
                          listaLocalGlobal.add(locObj);
                          print(locObj);
                          Navigator.pop(context);
                          _showModalBottomSheetAddLocal();
                        },
                      ),
                      CupertinoButton(
                        //color: Colors.green,
                        child: Text("Sim",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green)),
                        onPressed: () {
                          print("lista PessoaGlobal limpa!");
                          //listaPessoaGlobal = [];//limpa lista global
                          addNewLocalEsp();
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

  _showModalBottomSheetAddLocal() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Text(
                    " Deseja Inserir outra Cidade ?",
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
                          //print(listaLocalGlobal);
                          Km kmObj = Km(int.parse(_textEditingControllerKmIni.text), int.parse(_textEditingControllerFinal.text), _date.toString().substring(0,10), listaLocalGlobal);
                          for(var x in kmObj.listaLocal){
                            print("For");
                            print(x);
                          }
                          _objJsonGlobal = base64Encode(utf8.encode(jsonEncode(kmObj)));
                          //print("Imprime do btn Não do Alert");
                          //print(jsonEncode(kmObj));
                          enviaDados();
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoButton(
                        //color: Colors.green,
                        child: Text("Sim",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green)),
                        onPressed: () {
                          print("lista LocalGlobal limpa!");
                          listaLocalEspcGlobal = [];
                          listaPessoaGlobal = [];
                          addNewLocal();
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

  //-------------------------------------Envio---------------------------------------

  enviaparametro(String _corpo_json) async {
    //ENVIA TEXTO CRIPTOGRAFADO E DESCRIPTOGRAFA RETORNO
    String url = Urls.url;
    final http.Response response = await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
    }, body: {
      'corpo': criptografa(_corpo_json)
    });
    print("Corpo do JSON from envia parametro" + _corpo_json);
    print(
        "Corpo do JSON enviado para webservice from metodo envia parametro Tela KmStepper linha 406 " +
            criptografa(_corpo_json));
    String a = decrip(response.body).substring(3);
    print("Variável a from enviaparâmetro" + a.toString());
    if (decrip(response.body).substring(0, 3) == '01.') {
      Map<String, dynamic> retorno =
      json.decode(decrip(response.body).substring(3));
      String c = retorno["status"].toString();
      String b = retorno["msg"];
      String id = retorno["idUsuario"];
      _idRegistro = retorno["lastId"];
      //mapeia para saber o conteúdo da ms e printar "+b"
      Get.snackbar("Falha", "Mensagem não enviada! ",
          backgroundColor: Colors.red,colorText: Colors.white);
      return "Erro no enviaparametro: " + b;
    } else {
      return decrip(response.body).substring(3);
    }
  }

  void enviaDados()async{

    setState(() {
      _date = DateTime.now();
        final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_date);

      String dataEditada = DateTime.now().toString();
    });

    //cria json para enviar
    String jsonEnviado = jsonEncode(<String,dynamic>{
      "modulo": "c2FsdmFyS21Sb2RhZG8=",
      "id": _id_Usuario,
      "kmObjJson" : _objJsonGlobal,
    });
    print("Imprime jsonEnviado método enviaDados TelaKmSteper linha 752");
    print(jsonEnviado);
    //limpaLista(listaPessoa);

    String a = await enviaparametro(jsonEnviado);

    if (a.substring(0, 1) == "E") {
      print("-------------Erro de envio--------------" + decrip(a).toString());
    } else {
      //if testa se deu algum erro no envio se não, tratar para decodificar json
      Map<String, dynamic> retornoDespesa = json.decode(a);
      String c = retornoDespesa["status"].toString();
      String id_reistro = retornoDespesa["lastId"].toString();
      _idRegistro = id_reistro;
      listaPessoa = [];
      //limpalistaview();                 Comentado
      String retornoCreate = a;
      print(
          "**********Else do método _enviaDados TelaKilomatragemStepper ***********  linha 477" + a.toString());
      print("Mensagem de Status da despesa venciada TelaKilomatragemStepper linha 478 " + c.toString());
      if (c.toString() == 'true') {
        _addTodo2();
        contaPessoas = [];
        //_showModalBottomSheetKmEnv();
        //_imprimeDadosEnviados();
        //Get.to(()=> TelaListaLocais());
      } else {
        print("Erro entrou no else do _enviaDados TelaKilomatragem!!!!");
        Get.snackbar("Falha", "Mensagem não enviada!",
            backgroundColor: Colors.red);
      }

    }
    //------------------------------------------------------------------------
    _textEditingControllerPessoa.clear();
    _textEditingControllerObs.clear();
    _textEditingControllerLocalEspec.clear();
    _textEditingControllerTurno.clear();
    _textEditingControllerLocal.clear();
    _textEditingControllerKmIni.clear();
    _textEditingControllerFinal.clear();
    /*_date = null;
    setState(() {
      txtData = "";
    });*/
  }

  void novoLocal(bool complete,int currentStep){
    if (complete){
      setState(() => currentStep = 1);
    }
  }

  List <Local> listaLocalGlobal = [];
  List  <LocalEsp>listaLocalEspcGlobal = [];
  List<Pessoa> listaPessoaGlobal = [];
  //--------------------------------------------------------------------------


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _date = DateTime.now();
    setState(() {
      final datapt = DateFormat(DateFormat.YEAR_MONTH_DAY, "pt_Br").format(_date);
      _vardataPT = datapt; // aqui a vardata recebe a data formatada pelo código acima
      //txtData = _date.toString();
      txtData = _vardataPT;
      _lblDataPicker = txtData;
    });

  }

  _showModalBottomSheetTipos() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child:Wrap(
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
                          _textEditingControllerLocal.text =
                          result[0];
                          _txtCidade = result[0];
                          _dataCodMunicipio = result[1];
                          print("Cidade escolhida: " + _txtCidade);
                          print("Código: " + _dataCodMunicipio);
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
                          _textEditingControllerLocal.text =
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
                          _textEditingControllerLocal.text =
                          result[0];
                          _txtCidade = result[0];
                          _dataCodMunicipio = result[1];
                        });
                      }
                      Navigator.pop(context); //fecha o bottomsheet
                    }),
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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),onPressed: (){
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
          },),
        //backgroundColor: Colors.white,
        title: Text("Cadastrar Km Rodado",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children:<Widget>[
          complete
              ? Expanded(
            child: Center(
              child: AlertDialog(
                title: new Text("Cadastrar novo Local?"),
                content: Text("Sucesso!"),
                actions: [
                  ElevatedButton(
                    child: Text("Sim"),
                    onPressed: (){
                      setState(() {
                        addNewLocal();
                        complete = false;
                        //calcel2();
                        //Navigator.pop(context);
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text("Não"),
                    onPressed: ()async{
                      setState(() {
                        //Aqui Insere o Envia
                        Km kmObj = Km(int.parse(_textEditingControllerKmIni.text), int.parse(_textEditingControllerFinal.text), _date.toString().substring(0,10), listaLocalGlobal);
                        print(kmObj);
                        print("Objeto em json Expanded/btn não");
                        _objJsonGlobal = base64Encode(utf8.encode(jsonEncode(kmObj)));
                        print("Imprime do btn 'Não' do Alert");
                        print(jsonEncode(kmObj));
                        enviaDados();
                      });
                      await _showModalBottomSheetKmEnv();
                    },
                  )
                ],
              ),
            ),
          )
              :Expanded(
            child: Stepper(
                controlsBuilder:
                      (BuildContext context, { VoidCallback onStepContinue, VoidCallback onStepCancel }) {
                          return Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
                                  onPressed: onStepCancel,
                                  child: const Text('RETORNAR',style: TextStyle(color: Colors.white),),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                    textStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                                onPressed: (){  if(currentStep == 0){
                                  print(_date);
                                  print(" if = 0 sim currenStep ${currentStep} complete = " + complete.toString());
                                  if(_formKey.currentState.validate()){

                                    if(_date != null){
                                      //Insere Local no objeto aqui
                                      onStepContinue();
                                    }else{
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      Get.snackbar("ATENÇÃO", "Data é requerida",colorText: Colors.white ,snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.black);
                                    }

                                  }else{
                                    print("Favor preencher todos os campos!");
                                  }
                                }else if(currentStep == 1){
                                  print(" if = 1 sim currenStep ${currentStep} complete = " + complete.toString());
                                  if(_formKey2.currentState.validate()){
                                    //Insere Local Esp no Objeto aqui
                                    onStepContinue();
                                  }else{
                                    print("Favor preencher todos os campos!");
                                  }
                                }else if(currentStep == 2){

                                    print(" if = 2 sim currenStep ${currentStep} complete = " + complete.toString());
                                    if(_formKey3.currentState.validate()){
                                      //Insere Pessoas na Lista aqui
                                      onStepContinue();
                                    }else{
                                      print("Favor preencher todos os campos!");
                                    }
                                  }else if(currentStep == 3){
                                  print("if = 3sim currenStep ${currentStep} complete = " + complete.toString());
                                  if(true){
                                    if(_formKey4.currentState.validate()){
                                      Pessoa pessoaObj = Pessoa(_textEditingControllerPessoa.text, _textEditingControllerObs.text);
                                      listaPessoaGlobal.add(pessoaObj);
                                      //pessoasMap["nome"] = _textEditingControllerPessoa.text;
                                      contaPessoas.add(pessoaObj);
                                      print(listaPessoaGlobal);// adiciona pessoas na lista para contar quantas pessoas foram adicionadas a km
                                      print("adicionado pessoa na lista");
                                      print("Qtde de pessoas igual a ${listaPessoaGlobal.length}");
                                      _showModalBottomSheetAddPessoa(_textEditingControllerPessoa.text,contaPessoas);
                                      _textEditingControllerObs.clear();
                                      _textEditingControllerPessoa.clear();
                                    }else{
                                      print("Não Adicionada!");
                                    }
                                    //onStepContinue();
                                  }else{
                                    print("Favor preencher todos os campos!");
                                  }
                                }
                                },
                                child:  currentStep == 3 ? Text("FINALIZAR",style: TextStyle(color: Colors.white),):Text("PRÓXIMO",style: TextStyle(color: Colors.white)),),

                           ],
                         );
                      },
                type: stepperType,
                steps: [
                  Step(
                    title: Text("Km",style: TextStyle(color: currentStep == 0 ? Colors.blue: Colors.grey,),),
                    isActive: currentStep == 0 ? true: false,
                    state: StepState.complete,
                    content: Column(
                      children: [
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
                              _lblDataPicker = txtData;
                            });
                            _show(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.date_range,color: Colors.grey[400],size:80),
                                      Text("${_lblDataPicker}",style: TextStyle(color: Colors.red,fontSize: 14,fontWeight: FontWeight.bold)),
                                    ],
                                  ),

                                  //Text("${_dateTime}"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  autofocus: false,
                                  keyboardType: TextInputType.number,
                                  controller: _textEditingControllerKmIni,
                                  validator: (_textEditingControllerKmIni){
                           if(_textEditingControllerKmIni.isEmpty){
                                      return "Campo Inválido!";
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (v){
                                    FocusScope.of(context).requestFocus(focusKmFinal);
                                  },
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    //suffixIcon: icon,
                                    border: OutlineInputBorder(),
                                    labelText: "Inserir Km Inicial",
                                    hintText: "Digite aqui",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: TextFormField(
                                    focusNode: focusKmFinal,
                                    keyboardType: TextInputType.number,
                                    controller: _textEditingControllerFinal,
                                    validator: (_textEditingControllerFinal){
                                      if(_textEditingControllerFinal.isEmpty){
                                        return "Campo Inválido!";
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (v){
                                      FocusScope.of(context).requestFocus(focusKmLocal);
                                    },
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      //suffixIcon: icon,
                                      border: OutlineInputBorder(),
                                      labelText: "Inserir KM Final",
                                      hintText: "Digite aqui",
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    )
                  ),
                  Step(
                    title: Text("Local",style: TextStyle(color: currentStep == 1 ? Colors.blue: Colors.grey,),),
                      isActive: currentStep == 1 ? true: false,
                    content: Form(
                      key: _formKey2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextFormField(
                          onTap: (){
                            _showModalBottomSheetTipos();
                          },
                          readOnly: true,
                          controller: _textEditingControllerLocal,
                          validator: (_textEditingControllerLocal){
                            if(_textEditingControllerLocal.isEmpty){
                              return "Campo Inválido!";
                            }
                            return null;
                          },
                          onFieldSubmitted: (v){
                            FocusScope.of(context).requestFocus(focusLocalEsp);
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            //suffixIcon: icon,
                            border: OutlineInputBorder(),
                            labelText: "Inserir Local",
                            hintText: "Digite aqui",
                          ),
                        ),
                      ),
                    )
                  ),
                  Step(
                      title: Text("LocEsp",style: TextStyle(color: currentStep == 2 ? Colors.blue: Colors.grey,)),
                      isActive: currentStep == 2 ? true: false,
                      state: StepState.complete,
                      content: Form(
                        key: _formKey3,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: TextFormField(
                                onTap: ()async{
                                  final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                           TelaListaHospitais()
                                      ));
                                  // after the SecondScreen result comes back update the Text widget with it
                                  if (result != null){
                                    setState(() {
                                      _textEditingControllerLocalEspec.text =
                                      result[0];
                                      _txtCidade = result[0];
                                      _dataCodMunicipio = result[1];
                                      print("Cidade escolhida: " + _txtCidade);
                                      print("Código: " + _dataCodMunicipio);
                                    });
                                  }
                                  //Navigator.pop(context); //fecha o bottomsheet
                                },
                                readOnly: true,
                                focusNode: focusLocalEsp,
                                controller: _textEditingControllerLocalEspec,
                                validator: (_textEditingControllerLocalEspec) {
                                  if (_textEditingControllerLocalEspec.isEmpty) {
                                    return 'Campo Obrigatório';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(focusKmTurn);
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  //suffixIcon: icon,
                                  border: OutlineInputBorder(),
                                  labelText: "Inserir Local Esp.",
                                  hintText: "Digite aqui",
                                  //suffixIcon: Icon(Icons.person_add),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: TextFormField(
                                readOnly: true,
                                focusNode: focusKmTurn,
                                onTap: (){chamaTurno();},
                                controller: _textEditingControllerTurno,
                                validator: (_textEditingControllerTurno) {
                                  if (_textEditingControllerTurno.isEmpty) {
                                    return 'Campo Obrigatório';
                                  }
                                  return null;
                                },
                                /*onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(focusKmPessoa);
                                },*/
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  //suffixIcon: icon,
                                  border: OutlineInputBorder(),
                                  labelText: "Inserir Turno",
                                  hintText: "Digite aqui",
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                  Step(
                      title: Text("Pessoas",style: TextStyle(color: currentStep == 3 ? Colors.blue: Colors.grey,)),
                      isActive: currentStep == 3 ? true: false,
                      state: StepState.complete,
                      content: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                      /*Padding(
                      padding: const EdgeInsets.only(left: 0,bottom:10.0),
                    child: ElevatedButton(
                      child: Text("New LocEsp",style: TextStyle(color: Colors.white),),
                      style: ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.brown)),
                      onPressed: (){
                        LocalEsp localEspObj = LocalEsp(_textEditingControllerLocalEspec.text, listaPessoaGlobal, _textEditingControllerTurno.text);
                        listaLocalEspcGlobal.add(localEspObj);
                        print("Teste AGORA!!!!!!");
                        print(listaLocalEspcGlobal);
                        setState(() {
                          print("add local esp novo");
                          addNewLocalEsp();
                        });
                      },
                    ),
                  ),*/
                              /*Padding(
                                padding: const EdgeInsets.only(left: 10,bottom:10.0),
                                child: ElevatedButton(
                                  child: Text("New Pessoa",style: TextStyle(color: Colors.white),),
                                  style: ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.orange)),
                                  onPressed: (){
                                    // adicionar na lista de pessoas aqui
                                    if(_formKey4.currentState.validate()){
                                      Pessoa pessoaObj = Pessoa(_textEditingControllerPessoa.text, _textEditingControllerObs.text);
                                      listaPessoaGlobal.add(pessoaObj);
                                      print(listaPessoaGlobal);
                                      print("adicionado pessoa na lista");
                                    }else{
                                      print("Não Adicionada!");
                                    }
                                  },
                                ),
                              ),*/
                            ],
                          ),
                          Form(
                            key: _formKey4,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: TextFormField(
                                    autofocus: false,
                                    controller: _textEditingControllerPessoa,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(labelText: "Nome",border: OutlineInputBorder(),suffixIcon: Icon(Icons.person)),
                                    validator: (_textEditingControllerPessoa){
                                      if(_textEditingControllerPessoa.isEmpty){
                                        return "Campo Inválido!";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                TextFormField(
                                  autofocus: false,
                                  minLines: 2,
                                  maxLines: 6,
                                  textInputAction: TextInputAction.newline,
                                  keyboardType: TextInputType.multiline,
                                  controller: _textEditingControllerObs,
                                  decoration: InputDecoration(labelText: "Observação",border: OutlineInputBorder()),
                                  validator: (_textEditingControllerObs){
                                    if(_textEditingControllerObs.isEmpty){
                                      return "Campo Inválido!";
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                ],
                currentStep: currentStep,
                onStepContinue: next,
                onStepCancel: calcel,
                onStepTapped: (step) => goTo(step)
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: complete,
        child: FloatingActionButton(
          child: Icon(Icons.list),
          onPressed: switchStepType,
        ),
      ),
    );
  }
}