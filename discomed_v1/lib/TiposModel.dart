class TiposDespesa {
  String id;
  String tipo;


  TiposDespesa(
      { this.id ,this.tipo,
      });

  factory TiposDespesa.fromJson(Map<String, dynamic> json) {
    return TiposDespesa(
        id: json["id"].toString(),
        tipo: json["tipo"]);
  }

  TiposDespesa.map(dynamic obj) {
    this.id = obj['id:'];
    this.tipo = obj['tipo:'];
  }

  TiposDespesa.fromMap(Map<String, dynamic> map) {
    this.id = map["id"].toString();
    this.tipo = map['tipo'];
  }
}

