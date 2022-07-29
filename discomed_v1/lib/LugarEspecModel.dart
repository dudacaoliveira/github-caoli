import 'package:flutter/material.dart';

import 'PessoaModel.dart';

class LugarEsp {
  String _lugarEsp;
  String _turno;
  List<Pessoa> listpessoa;

  LugarEsp(this._lugarEsp, this._turno, this.listpessoa);


  String get lugarEsp => _lugarEsp;

  set lugarEsp(String value) {
    _lugarEsp = value;
  }

  @override
  String toString() {
    return 'localEspecifico{Lugar/Hospital: $_lugarEsp, turno: $_turno, listapessoa: $listpessoa}';
  }

  String get turno => _turno;

  set turno(String value) {
    _turno = value;
  }
}