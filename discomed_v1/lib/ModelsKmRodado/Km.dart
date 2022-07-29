import 'Local.dart';

class Km {

  int _kmIni;
  int _kmFinal;
  var _data;
  List<Local> listaLocal;

  Km(this._kmIni, this._kmFinal, this._data, this.listaLocal);

  get data => _data;

  set data(value) {
    _data = value;
  }

  int get kmFinal => _kmFinal;

  set kmFinal(int value) {
    _kmFinal = value;
  }

  int get kmIni => _kmIni;

  set kmIni(int value) {
    _kmIni = value;
  }


  Km.fromJson(Map<String, dynamic> json) {
    _kmIni = json['kmIni'];
    _kmFinal = json['kmFinal'];
    _data = json['data'];
    if (json['listaLocal'] != null) {
      listaLocal = new List<Local>();
      json['listaLocal'].forEach((v) {
        listaLocal.add(new Local.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kmIni'] = this._kmIni;
    data['kmFinal'] = this._kmFinal;
    data['data'] = this._data;
    if (this.listaLocal != null) {
      data['listaLocal'] = this.listaLocal.map((v) => v.toJson()).toList();
    }
    return data;
  }


  @override
  String toString() {
    return 'Kilometragem do dia: {_kmIni: $_kmIni, _kmFinal: $_kmFinal, _data: $_data, listaLocal: $listaLocal}';
  }
}