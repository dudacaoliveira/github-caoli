class TiposVistoria {
  String id;
  String tipo;


  TiposVistoria(
      { this.id ,this.tipo,
      });

  factory TiposVistoria.fromJson(Map<String, dynamic> json) {
    return TiposVistoria(
        id: json["id"].toString(),
        tipo: json["tipo"]);
  }

  TiposVistoria.map(dynamic obj) {
    this.id = obj['id:'];
    this.tipo = obj['tipo:'];
  }

  TiposVistoria.fromMap(Map<String, dynamic> map) {
    this.id = map["id"].toString();
    this.tipo = map['tipo'];
  }
}