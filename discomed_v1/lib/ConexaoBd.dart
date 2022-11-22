import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'DespesaModel.dart';

class Conexao {

/*  void chamaBanco(){
    recuperarBanco();
  }*/

//-----------------------------------------

  Future recuperarBanco() async {
    final caminhoBanco = await getDatabasesPath();
    final localBanco = join(caminhoBanco, "banco.db");
    var db = await openDatabase(
      localBanco,
      version: 1,
      onCreate: _criarBanco,
    );
    print("Chamado metodo recuperarBanco Arq ConexãoBd: aberto = " + db.isOpen.toString());
    //db.close();
    return db;
  }

  //----------------------------------------------------------------------------------

  Future<void> _criarBanco(Database db, int novaVersao) async {
    List<String> queryes = [
      "CREATE TABLE IF NOT EXISTS enderecos (id INTEGER PRIMARY KEY AUTOINCREMENT, uf VARCHAR, nomeUf VARCHAR, municipio VARCHAR, codMunicipioCompleto VARCHAR, nomeMunicipio VARCHAR);",
      "CREATE TABLE IF NOT EXISTS tipos (id INTEGER PRIMARY KEY , tipo VARCHAR);",
      "CREATE TABLE IF NOT EXISTS despesas (id INTEGER PRIMARY KEY AUTOINCREMENT,idTipoDespesa INTEGER, idCidade INTEGER, data VARCHAR,codMunicipioCompleto INTEGER, valor REAL, observacao TEXT, nomeImagem VARCHAR,"
          " FOREIGN KEY (idTipoDespesa) REFERENCES tipos (id),"
          " FOREIGN KEY (idCidade) REFERENCES enderecos (id) );",
      "CREATE TABLE IF NOT EXISTS usuario (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, status VARCHAR);",
      "CREATE TABLE IF NOT EXISTS local (id_local INTEGER PRIMARY KEY , local VARCHAR);",
      "CREATE TABLE IF NOT EXISTS lugar (id_lugar INTEGER PRIMARY KEY , lugar VARCHAR);",
      "CREATE TABLE IF NOT EXISTS localEsp (id_locEsp INTEGER PRIMARY KEY , locEsp VARCHAR);",
      "CREATE TABLE IF NOT EXISTS kmRodado (idRegistro INTEGER PRIMARY KEY , kmIni INTEGER , kmFinal INTEGER , dataEditada VARCHAR , qtde INTEGER , dataRegistro VARCHAR);",
      "CREATE TABLE IF NOT EXISTS pessoa (id_pessoa INTEGER PRIMARY KEY , nome VARCHAR , obs VARCHAR , fk_idRegistro INTEGER);",
      "CREATE TABLE IF NOT EXISTS teste (id INTEGER PRIMARY KEY , nome VARCHAR , obs VARCHAR , fk_idRegistro INTEGER);",
      "CREATE TABLE IF NOT EXISTS ofensorVistoria (id INTEGER PRIMARY KEY , ofensor VARCHAR);",
      "CREATE TABLE IF NOT EXISTS setorVistoria (id INTEGER PRIMARY KEY , setor VARCHAR);",
      "CREATE TABLE IF NOT EXISTS statusVistoria (id INTEGER PRIMARY KEY , status VARCHAR , sigla VARCHAR);",
      "CREATE TABLE IF NOT EXISTS tipoVistoria (id INTEGER PRIMARY KEY , tipo VARCHAR);",
      "CREATE TABLE IF NOT EXISTS vistoria (id INTEGER PRIMARY KEY , vistoria VARCHAR);",
      "CREATE TABLE IF NOT EXISTS objVistoria (id INTEGER PRIMARY KEY , tipo VARCHAR , nome VARCHAR , ofensor VARCHAR , descricao VARCHAR , resultado VARCHAR, FOREIGN KEY (id) REFERENCES vistoria (id));"
    ];
    for (String query in queryes) {
      await db.execute(query);
    }
    var tableNames = (await db
        .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: false);
    print(tableNames);
  }



  //----------------------------------------------------------------------------------

  Future listarTabelas()async{

    Database db = await recuperarBanco();
    String sql = "SELECT * FROM sqlite_master WHERE type='table'";
    List tabelas = await db.rawQuery(sql);
    //print da lista completa
    for(var data in tabelas){
      print(data);
    }
    print("Tabelas = " + tabelas.toString());
  }

  void getTables()async{
    Database db = await recuperarBanco();
    var tableNames = (await db
            .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: false);
    print(tableNames);
  }


  //------------------------------------Vistoria--------------------------------------------

  Future listarTiposVist() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM statusVistoria";
    List tipos = await db.rawQuery(sql);
    //print da lista completa
    print("Tipos Vistoria = " + tipos.toString());
    //db.close();
  }

  Future listarVistoria() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM objVistoria";
    List tipos = await db.rawQuery(sql);
    //print da lista completa
    print("Vistorias = " + tipos.toString());
    //db.close();
  }



  salvarVistoria (String tipo ,String nome, String ofensor, String descricao, String resultado )async{
    Database db = await recuperarBanco();
    Map<String, dynamic> dados = {
      "tipo" :tipo,
      "nome" :nome,
      "ofensor" :ofensor,
      "descricao" :descricao,
      "resultado" : resultado
    };
    int id = await db.insert("objVistoria", dados);
    print("Salvo Vistoria com a id: $id");
  }

  salvarTipoVistoria (int idTpo, String tipo )async{
    Database db = await recuperarBanco();
    Map<String, dynamic> dados = {
      "id" :idTpo,
      "tipo" : tipo
    };
    int id = await db.insert("tipoVistoria", dados);
    print("Salvo Tipo Vistoria com a id: $id");
  }

  salvarStatusVistoria (int idStatus, String status, String sigla )async{
    Database db = await recuperarBanco();
    Map<String, dynamic> dados = {
      "id" :idStatus,
      "status" : status,
      "sigla" : sigla
    };
    int id = await db.insert("statusVistoria", dados);
    print("Salvo Status com a id: $id");
  }

  salvarSetorVistoria (int idSetor, String setor )async{
    Database db = await recuperarBanco();
    Map<String, dynamic> dados = {
      "id" :idSetor,
      "setor" : setor
    };
    int id = await db.insert("setorVistoria", dados);
    print("Salvo Setor com a id: $id");
  }


  salvarOfensorVistoria (int idOfensor, String ofensor )async{
    Database db = await recuperarBanco();
    Map<String, dynamic> dados = {
      "id" :idOfensor,
      "ofensor" : ofensor
    };
    int id = await db.insert("ofensorVistoria", dados);
    print("Salvo Ofensor com a id: $id");
  }

  Future limpaTabela() async {
    Database db = await recuperarBanco();
    String sql = "Delete from enderecos";
    print("Tabela Limpa!!!!");
    db.execute(sql);
  }




  Future listarCidades() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM enderecos";
    List cidades = await db.rawQuery(sql);
    //print da lista completa
    print("Cidades = " + cidades.toString());
    //db.close();
  }

  Future listarCidadesFormat() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM enderecos";
    var result = await db.rawQuery(sql);
    //print da lista completa
    List itens = new List();
    if (result.length != 0) {
      Map<String, dynamic> item = Map();
      for (var cid in result) {
        item["Cidade"] = cid['nomeMunicipio'];
        item["Cód"] = cid['codMunicipioCompleto'];
        item["UF"] = cid['nomeUf'];
        itens.add(item);
        //print(itens[0]);
        print("Id: " + cid['id'].toString() + ", " + cid['uf'] + " " +
            cid['nomeUf'] + ", " + cid['nomeMunicipio'] + ", " +
            cid['municipio'] + ", " + cid['codMunicipioCompleto']);
      }
    } else {
      print("A lista está vazia!!!!");
    }
    //print(cidades.length);
    return result.toList();
  }

  Future listarPessoas() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM pessoa ";
    var result = await db.rawQuery(sql);
    //print da lista completa
    List itens = new List();
    if (result.length != 0) {
      Map<String, dynamic> item = Map();
      for (var data in result) {
        item["nome"] = data['nome'];
        item["obs"] = data['obs'];
        item["fk_idRegistro"] = data['fk_idRegistro'];
        itens.add(item);
        //print(itens[0]);
        print("Nome: " + data['nome'].toString() + ", " + data['obs'].toString() + ", ID Km = " +
            data['fk_idRegistro'].toString());
      }
    } else {
      print("A lista está vazia!!!!");
    }
    //print(result.toList());
    return result.toList();

  }



  Future deletarPessoasId(int idRegistro) async {
    Database db = await recuperarBanco();
    String sql = "Delete from pessoa"
        " where pessoa.fk_idRegistro = ${idRegistro} ";
    var result = await db.rawQuery(sql);
    print(result);
    print("Pessoas  com o Fk ${idRegistro} deletadas com sucesso!");
    return result.toList();
  }


  Future listarPessoasId(int idRegistro) async {
    Database db = await recuperarBanco();
    String sql = "SELECT pessoa.id_pessoa, pessoa.fk_idRegistro, pessoa.nome, pessoa.obs"
        " FROM pessoa join kmRodado"
        " on pessoa.fk_idRegistro = kmRodado.idRegistro where pessoa.fk_idRegistro = ${idRegistro} ";
    var result = await db.rawQuery(sql);
    print(result);
    //print da lista completa
    List itens = new List();
    if (result.length != 0) {
      Map<String, dynamic> item = Map();
      for (var data in result) {
        item["nome"] = data['nome'];
        item["obs"] = data['obs'];
        item["fk_idRegistro"] = data['fk_idRegistro'];
        itens.add(item);
        //print(itens[0]);
        print("IDPessoa: " + data['id_pessoa'].toString() + ", " + "Nome: " + data['nome'].toString() + ", " + "Obs: "  + data['obs'].toString() + ", ID Km = " +
            data['fk_idRegistro'].toString());
      }
    } else {
      print("A lista está vazia!!!!");
    }
    //print(result.toList());
    return result.toList();

  }

  Future listarPessoas2() async {
    Database db = await recuperarBanco();
    String sql = "SELECT pessoa.id_pessoa, pessoa.fk_idRegistro, pessoa.nome, pessoa.obs"
        " FROM pessoa join kmRodado"
        " on pessoa.fk_idRegistro = kmRodado.idRegistro ";
    var result = await db.rawQuery(sql);
    print(result);
    //print da lista completa
    List itens = new List();
    if (result.length != 0) {
      Map<String, dynamic> item = Map();
      for (var data in result) {
        item["nome"] = data['nome'];
        item["obs"] = data['obs'];
        item["fk_idRegistro"] = data['fk_idRegistro'];

        itens.add(item);
        //print(itens[0]);
        print("IDPessoa: " + data['id_pessoa'].toString() + ", " + "Nome: " + data['nome'].toString() + ", " + "Obs: "  + data['obs'].toString() + ", ID Km = " +
            data['fk_idRegistro'].toString());
      }
    } else {
      print("A lista está vazia!!!!");
    }
    //print(result.toList());
    return result.toList();

  }

  Future listarKmRodado() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM kmRodado order by idRegistro desc ";
    var result = await db.rawQuery(sql);
    //print da lista completa
    List itens = new List();
    if (result.length != 0) {
      Map<String, dynamic> item = Map();
      for (var km in result) {
        item["Cidade"] = km['nomeMunicipio'];
        item["Cód"] = km['codMunicipioCompleto'];
        item["UF"] = km['nomeUf'];
        itens.add(item);
        //print(itens[0]);
        print("IMPRIME dentro do método listarKmRodado" + "Id: " + km['idRegistro'].toString() + ", " + "Km Ini = "+ km['kmIni'].toString() + " ," +
           "Km Final = " + km['kmFinal'].toString() + ", " + "Qtde Pessoas = " + km['qtde'].toString() + ", " +
            "Data: "+ km['dataEditada'] + ", Log:" + km['dataRegistro']);
      }
    } else {
      print("A lista está vazia!!!!");
    }
    //print(result.toList());
    return result.toList();
  }



  Future<List> getCidadesforId(int id) async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery('SELECT nomeMunicipio FROM enderecos where $id = codMunicipioCompleto');
    return result.toList();
  }

  Future<List> getAllCidades() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery('SELECT * FROM enderecos');

    return result.toList();
  }

  Future<List> getAllRS() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery(
        "SELECT * FROM enderecos where uf = '43'");

    return result.toList();
  }

  Future<List> getAllSC() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery(
        "SELECT * FROM enderecos where uf = '42'");

    return result.toList();
  }

  Future<List> getAllPR() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery(
        "SELECT * FROM enderecos where uf = '41'");
    //"SELECT * FROM enderecos where uf = '41'
    return result.toList();
  }

  Future listarCidadesRS() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM enderecos where uf = '43' ";
    List cidades = await db.rawQuery(sql);
    //print da lista completa
    //print("Cidades = "+ cidades.toString());
    //print da lista editada
    for (var cid in cidades) {
      print(cid['nomeMunicipio']);
      //print("Id: " + cid['id'].toString() +", "+ cid['uf'] +" "+ cid['nomeUf'] +", "+ cid['nomeMunicipio'] +", "+ cid['municipio'] +", "+ cid['codMunicipioCompleto']);
    }
  }

  Future listarCidadesSC() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM enderecos where uf = '42' ";
    List cidades = await db.rawQuery(sql);
    //print da lista completa
    //print("Cidades = "+ cidades.toString());
    //print da lista editada
    for (var cid in cidades) {
      print(cid['nomeMunicipio']);
      //print("Id: " + cid['id'].toString() +", "+ cid['uf'] +" "+ cid['nomeUf'] +", "+ cid['nomeMunicipio'] +", "+ cid['municipio'] +", "+ cid['codMunicipioCompleto']);
    }
  }

  Future listarCidadesPR() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM enderecos where uf = '41' ";
    List cidades = await db.rawQuery(sql);
    //print da lista completa
    //print("Cidades = "+ cidades.toString());
    //print da lista editada
    for (var cid in cidades) {
      print(cid['nomeMunicipio']);
      //print("Id: " + cid['id'].toString() +", "+ cid['uf'] +" "+ cid['nomeUf'] +", "+ cid['nomeMunicipio'] +", "+ cid['municipio'] +", "+ cid['codMunicipioCompleto']);
    }
  }

  removerKm(int id) async {
    Database db = await recuperarBanco();
    db.delete(
        "kmRodado",
        where: "idRegistro = ?",
        whereArgs: [id]
    );
    print("Registro com id: ${id} deletado");
  }


  salvarpessoa(String nome, String obs , int fk_idRegistro , Database db)async{
    Map<String, dynamic> dados = {
      "nome" : nome,
      "obs" : obs,
      "fk_idRegistro" : fk_idRegistro
    };
    int id = await db.insert("pessoa", dados);
    print("Salvo pessoa com a fk: $fk_idRegistro");
  }



  salvarkmRodado(int idRegistro, int kmIni, int kmFinal, String dataEditada, int qtde, String dataRegistro, Database db) async {
    Map<String, dynamic> dados = {
      "idRegistro" :idRegistro,
      "kmIni": kmIni,
      "kmFinal": kmFinal,
      "dataEditada": dataEditada,
      "qtde": qtde,
      "dataRegistro": dataRegistro
    };
    int id = await db.insert("kmRodado", dados);
    //db.close();
    print("Salvo Km com a data: $dataEditada com id: $id ");
    //print(n);
  }

  salvarCidade(String uf, String nomeUf, String municipio,
      String codMunicipioCompleto, String nomeMunicipio, Database db) async {
    Map<String, dynamic> dadosCidade = {
      "uf": uf,
      "nomeUf": nomeUf,
      "municipio": municipio,
      "codMunicipioCompleto": codMunicipioCompleto,
      "nomeMunicipio": nomeMunicipio
    };
    int id = await db.insert("enderecos", dadosCidade);
    //db.close();
    //print("Salvo Cód Estado $nomeUf com id: $id ");
    //print(n);
  }

  salvarLocalEsp(var id_LocEsp, String locEsp, Database db) async {
    Map<String, dynamic> dados = {
      "id_locEsp": id_LocEsp,
      "locEsp": locEsp,
    };
    int id = await db.insert("localEsp", dados);
    //db.close();
    print("Salvo Local Esp $locEsp com id: $id ");
    //print(n);
  }

  remover(int id) async {
    Database db = await recuperarBanco();
    db.delete(
        "enderecos",
        where: "id = ?",
        whereArgs: [id]
    );
  }

  Future buscarPorId(int id) async {
    Database db = await recuperarBanco();
    List cidades = await db.query(
        "enderecos",
        columns: [
          "id",
          "uf",
          "nomeUf",
          "municipio",
          "codMunicipioCompleto",
          "nomeMunicipio"
        ],
        where: "id = ?",
        whereArgs: [id]
    );
    for (var cidade in cidades) {
      print("Id: " + cidade['id'].toString() +
          " UF: " + cidade['uf'] +
          " Nome Uf: " + cidade['nomeUf'] +
          " Municipio: " + cidade['municipio'] +
          " Cód Municipio: " + cidade['codMunicipioCompleto'] +
          " Nome Município: " + cidade['nomeMunicipio']
      );
    }
  }

  Future listarCidadesBusca(String a) async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM enderecos where nomeMunicipio like '$a%' ";
    List cidades = await db.rawQuery(sql);
    //print da lista completa
    //print("Cidades = "+ cidades.toString());
    //print da lista editada
    for (var cid in cidades) {
      print(cid['nomeMunicipio']);
      //print("Id: " + cid['id'].toString() +", "+ cid['uf'] +" "+ cid['nomeUf'] +", "+ cid['nomeMunicipio'] +", "+ cid['municipio'] +", "+ cid['codMunicipioCompleto']);
    }
  }

  //------------------CRUD TIPOSDESP---------------------------------------

  salvarTiposDesp(String nome, Database db) async {
    Map<String, dynamic> dadosTipoDesp = {
      "tipo": nome,
    };
    int id = await db.insert("tipos", dadosTipoDesp);
    //print("Salvo Cód Tipo $id com id: $id ");
  }



  Future listarTipos() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM tipos";
    List listatipos = await db.rawQuery(sql);
    //print da lista completa
    print("Tipos de Despesa = " + listatipos.toString());
    //db.close();
  }

  Future<List> getTipos() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery(
        "SELECT * FROM tipos");
    //"SELECT * FROM enderecos where uf = '41'
    return result.toList();
  }

  Future<List> getAllTiposDesp() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery('SELECT * FROM tipos');
    print("Método getAllTiposDesp");
    return result.toList();
  }

  Future<List> getTiposVist() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery('SELECT * FROM tipoVistoria');
    print("Método getTiposVist");
    return result.toList();
  }

  Future<List> getOfensorVist() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery('SELECT * FROM ofensorVistoria');
    print("Método getOfensorDesp");
    return result.toList();
  }

  Future<List> getSetorVist() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery('SELECT * FROM setorVistoria');
    print("Método getSetorVist");
    return result.toList();
  }

  Future<List> getStatusVist() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery('SELECT * FROM statusVistoria');
    print("Método getStatusVist");
    return result.toList();
  }


  Future listarTiposFormat() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM tipos";
    var result = await db.rawQuery(sql);
    //print da lista completa
    List itens = new List();
    if (result.length != 0) {
      Map<String, dynamic> item = Map();
      for (var data in result) {
        item["Tipo_Despesa"] = data['tipo'];
        itens.add(item);
        //print(itens[0]);
        print("Id: " + data['id'].toString() + ", " + data['tipo']);
      }
    } else {
      print("A lista está vazia!!!!");
    }
  }

  salvarDespesa(int idTipoDespesa, int idCidade,String data,
      int codMunicipioCompleto,String valor,String observacao, Database db) async {
    Map<String, dynamic> dadosDespesa = {
      "idTipoDespesa": idTipoDespesa,
      "idCidade":idCidade,
      "data": data,
      "codMunicipioCompleto":codMunicipioCompleto,
      "valor":valor,
      "observacao": observacao,
    };
    int id = await db.insert("despesas", dadosDespesa);
    //db.close();
    print("Despesa Salva Id Despesa: $id Id Cidade: $idCidade Data: $data Valor: $valor  ID Tipo Despesa: $idTipoDespesa");
    //print(n);
  }
////id INTEGER PRIMARY KEY AUTOINCREMENT,idTipoDespesa INTEGER, idCidade INTEGER, data VARCHAR,codMunicipioCompleto INTEGER, valor REAL, observacao TEXT, nomeImagem VARCHAR,

  Future<List> getAllDespesas() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery('SELECT * FROM depesas');

    return result.toList();
  }


  Future listarDespesasFormat() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM despesas";
    var result = await db.rawQuery(sql);
    //print da lista completa
    List itens = new List();
    if (result.length != 0) {
      Map<String, dynamic> item = Map();
      for (var data in result) {
        item["id"] = data['id'];
        item["idCidade"] = data['idCidade'];
        item["data"] = data['data'];
        item["valor"] = data['valor'];
        item["observacao"] = data['observacao'];
        itens.add(item);
        //print(itens[0]);
        print("Id: " + data['id'].toString() + ", " + data['idCidade'].toString() + ","
            + data['data'] + "," + data['valor'].toString()+","+data['observacao'].toString() );
      }
    } else {
      print("A Tabela  de Despesas está vazia!!!!");
    }
  }


  Future limpaTabelaDespesas() async {
    Database db = await recuperarBanco();
    String sql = "Delete from despesas";
    print("Tabela Limpa!!!!");
    db.execute(sql);
    print("Tabela Limpa!!!!");
  }

  salvarUsuario(String id,String nome,String status, Database db) async {
    Map<String, dynamic> dadosUsuario = {
      "id":id,
      "nome": nome,
      "status": status,
    };
    //int id = await
    db.insert("usuario", dadosUsuario);
    print("Salvo Usuario ID: $id"+","+"com nome: $nome status: $status ");
  }
  
  Future listarUsuario() async {
    Database db = await recuperarBanco();
    String sql = "SELECT * FROM usuario";
    List usuarios = await db.rawQuery(sql);
    //print da lista completa
    if (usuarios.length == 0) {
      print("A Tabela de Usuários está vazia!");
    }else{
      for (var usuario in usuarios){
        print("---------------- Método Listar usuários-------------------");
        print("usuario = " + usuario.toString());
        print(usuario['nome'] +","+ usuario['id'].toString() + "," + usuario['status'].toString());
        print("---------------- Método Listar usuários-------------------");
      }
    }
  }

  Future<List> getAllUsuario() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery('SELECT * FROM usuario');
    return result.toList();
  }


  Future limpaTabelaUsuario() async {
    Database db = await recuperarBanco();
    String sql = "Delete from usuario";
    db.execute(sql);
    print("Tabela Limpa!!!!Id excluído ${db.execute(sql).toString()}");
  }

  Future buscarTipoPorId(int id) async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery('SELECT * FROM tipos WHERE id = ${id}');
    //print(result);
    return result;
  }


  Future<List> getAllLocais() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery(
        "SELECT * FROM localEsp");
    //"SELECT * FROM enderecos where uf = '41'
    return result.toList();
  }

  Future<List> BuscaTiposVist() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery(
        "SELECT * FROM tipoVistoria");
    return result.toList();
  }

  Future<List> BuscaStatusVist() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery(
        "SELECT * FROM statusVistoria");
    return result.toList();
  }

  Future<List> BuscaOfensorVist() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery(
        "SELECT * FROM ofensorVistoria");
    return result.toList();
  }

  Future<List> BuscaSetorVist() async {
    var dbClient = await recuperarBanco();
    //var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery(
        "SELECT * FROM setorVistoria");
    return result.toList();
  }

  /*ofensorVistoria
 setorVistoria
  statusVistoria
   tipoVistoria*/

}//fim da ClasseConexão



