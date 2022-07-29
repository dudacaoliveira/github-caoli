import 'package:flutter/material.dart';


class Pessoa{
  var _nome;
  var _observacao;

  Pessoa(this._nome, this._observacao);

  get observacao => _observacao;

  set observacao(value) {
    _observacao = value;
  }

  get nome => _nome;

  set nome(value) {
    _nome = value;
  }

  @override
  String toString() {
    return 'Pessoa{_nome: $_nome, _observacao: $_observacao}';
  }

}