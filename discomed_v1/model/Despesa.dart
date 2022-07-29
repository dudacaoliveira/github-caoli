import 'package:flutter/material.dart';


class Despesa {
  var _idVendedor;
 var _idDespesa;
 var _valor;
 var _endereco;
 List<String> notas;

  Despesa(this._idVendedor, this._idDespesa, this._valor, this._endereco);

  get endereco => _endereco;

  set endereco(value) {
    _endereco = value;
  }

  get valor => _valor;

  set valor(value) {
    _valor = value;
  }

  get idDespesa => _idDespesa;

  set idDespesa(value) {
    _idDespesa = value;
  }

  get idVendedor => _idVendedor;

  set idVendedor(value) {
    _idVendedor = value;
  }

  @override
  String toString() {
    return 'Despesa{_idVendedor: $_idVendedor, _idDespesa: $_idDespesa, _valor: $_valor, _endereco: $_endereco}';
  }
}