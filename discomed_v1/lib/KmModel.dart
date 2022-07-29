import 'package:flutter/material.dart';
import 'dart:convert';
import 'LugarEspecModel.dart';

//part 'Km.g.dart';

//@JsonSerializable()
class Km{
  var _kmIni;
  var _kmFinal;
  var _data;
  var _local;
  var _lista = [];
  var _listaLocaisEsp = [];
  LugarEsp lugarEspec;


  Km(this._kmIni, this._kmFinal, this._data, this._local,
      this._lista, this._listaLocaisEsp, this.lugarEspec);

  get kmIni => _kmIni;

  set kmIni(value) {
    _kmIni = value;
  }

  get local => _local;

  set local(value) {
    _local = value;
  }

  get data => _data;

  set data(value) {
    _data = value;
  }

  get listaEnd => _listaLocaisEsp;

  set listaEnd(value) {
    _listaLocaisEsp = value;
  }

  /*factory Km.fromJson(Map<String, dynamic> json) => _$KmFromJson(json);
  Map<String, dynamic> toJson() => _$KmToJson(this);*/
 factory Km.toJson(){

 }

  get lista => _lista;

  set lista(value) {
    _lista = value;
  }


  @override
  String toString() {
    return 'Km{_kmIni: $_kmIni, _kmFinal: $_kmFinal, _data: $_data, _local: $_local, _listaLocaisEsp: $_listaLocaisEsp}';
  }

  get kmFinal => _kmFinal;

  set kmFinal(value) {
    _kmFinal = value;
  }
}

