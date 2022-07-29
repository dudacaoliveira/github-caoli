import '../PessoaModel.dart';

class LocalEsp{
  var _localEsp;
  List<Pessoa> listaPessoa;
  String _turno;


  LocalEsp(this._localEsp, this.listaPessoa, this._turno);

  get localEsp => _localEsp;

  set localEsp(value) {
    _localEsp = value;
  }

  String get turno => _turno;

  set turno(String value) {
    _turno = value;
  }

  LocalEsp.fromJson(Map<String, dynamic> json) {
    _localEsp = json['localEsp'];
    if (json['listaPessoa'] != null) {
      listaPessoa = new List<Pessoa>();
      json['listaPessoa'].forEach((v) {
        listaPessoa.add(new Pessoa.fromJson(v));
      });
    }
    _turno = json['turno'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['localEsp'] = this._localEsp;
    if (this.listaPessoa != null) {
      data['listaPessoa'] = this.listaPessoa.map((v) => v.toJson()).toList();
    }
    data['turno'] = this._turno;
    return data;
  }

  @override
  String toString() {
    return 'LocalEsp{_localEsp: $_localEsp, listaPessoa: $listaPessoa, _turno: $_turno}';
  }
}