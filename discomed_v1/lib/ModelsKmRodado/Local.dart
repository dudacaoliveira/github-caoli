
import 'LocalEsp.dart';

class Local{
  var _local;
  List<LocalEsp> listaLocEspc;


  Local(this._local, this.listaLocEspc);

  get local => _local;

  set local(value) {
    _local = value;
  }


  Local.fromJson(Map<String, dynamic> json) {
    _local = json['local'];
    if (json['listaLocEspc'] != null) {
      listaLocEspc = new List<LocalEsp>();
      json['listaLocEspc'].forEach((v) {
        listaLocEspc.add(new LocalEsp.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['local'] = this._local;
    if (this.listaLocEspc != null) {
      data['listaLocEspc'] = this.listaLocEspc.map((v) => v.toJson()).toList();
    }
    return data;
  }


  @override
  String toString() {
    return 'local{_local: $_local, listaLocEspc: $listaLocEspc}';
  }


}