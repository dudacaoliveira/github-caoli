import 'package:flutter/material.dart';
//Pojo
class Pessoa {

  var _nome;
  var _obs;


  Pessoa(this._nome, this._obs);


  get observacao => _obs;

  set observacao(value) {
    _obs = value;
  }

  get nome => _nome;

  set nome(value) {
    _nome = value;
  }


  /*Map toJson() => {
    'nome': _nome,
    'observacao': _observacao,
  };*/

  Pessoa.fromJson(Map<String, dynamic> json) {
    _nome = json['nome'];
    _obs = json['observacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this._nome;
    data['observacao'] = this._obs;
    return data;
  }

  Pessoa.fromMap(Map<String, dynamic> map) {
    this._nome = map['nome'];
    this._obs = map['obs'];
  }


  @override
  String toString() {
    return '{nome: $_nome, observacao: $_obs}';
  }
}