import 'package:flutter/material.dart';

class LugarEspecifico{
  var _local;
  var _lugarEsp;
  var _turno;


  LugarEspecifico();

  //LugarEspecifico(this._local, this._lugarEsp, this._turno);


  get turno => _turno;

  set turno(value) {
    _turno = value;
  }

  get lugarEsp => _lugarEsp;

  set lugarEsp(value) {
    _lugarEsp = value;
  }

  get local => _local;

  set local(value) {
    _local = value;
  }

  @override
  String toString() {
    return 'LugarEspecifico{_local: $_local, _lugarEsp: $_lugarEsp, _turno: $_turno}';
  }
}
