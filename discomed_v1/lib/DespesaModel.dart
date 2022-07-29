import 'dart:ffi';

class Despesa {
  String id;
  String idTipoDespesa;
  String data;
  String idCidade;
  String valor;
  String observacao;
  String nomeImagem;
  String obsRetorno;
  String status;
  String kmInicial;
  String kmFinal;

  Despesa(
      { this.status,this.id ,this.idTipoDespesa,this.data,this.idCidade,this.valor,this.observacao,this.nomeImagem, this.obsRetorno,
        this.kmInicial,this.kmFinal
      });

  factory Despesa.fromJson(Map<String, dynamic> json) {
    return Despesa(
        status: json["status"],
        id: json["id"],
        idTipoDespesa: json["idTipoDespesa"],
        data:json["data"],
        idCidade:json["idCidade"],
        valor:json["valor"],
        observacao:json["observacao"],
        nomeImagem:json["nomeImagem"],
        obsRetorno:json["obsRetorno"],
        kmInicial: json["kmInicial"],
        kmFinal: json["kmFinal"],
    );

  }

  Despesa.map(dynamic obj) {
    this.status = obj['status:'];
    this.id = obj['id:'];
    this.idTipoDespesa = obj['tipo:'];
    this.data = obj["data"];
    this.idCidade = obj["idCidade"];
    this.valor = obj["valor"];
    this.observacao = obj["observacao"];
    this.nomeImagem = obj["nomeImagem"];
    this.obsRetorno = obj['obsRetorno'];
    this.kmInicial = obj["kmInicial"];
    this.kmFinal = obj["kmFinal"];
  }

  Despesa.fromMap(Map<String, dynamic> map) {

    this.status = map["status"].toString();
    this.id = map["id"].toString();
    this.idTipoDespesa = map['idTipoDespesa'].toString();
    this.data = map["data"];
    this.idCidade = map["idCidade"].toString();
    this.valor = map["valor"];
    this.observacao = map["observacao"];
    this.nomeImagem = map['nomeImagem'];
    this.obsRetorno = map['obsRetorno'];
    this.kmFinal = map["kmFinal"];
  }
}