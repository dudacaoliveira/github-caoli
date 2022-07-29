class SetorVistoria {
  String id;
  String setor;


  SetorVistoria(
      { this.id ,this.setor,
      });

  factory SetorVistoria.fromJson(Map<String, dynamic> json) {
    return SetorVistoria(
        id: json["id"].toString(),
        setor: json["setor"]);
  }

  SetorVistoria.map(dynamic obj) {
    this.id = obj['id:'];
    this.setor = obj['setor:'];
  }

  SetorVistoria.fromMap(Map<String, dynamic> map) {
    this.id = map["id"].toString();
    this.setor = map['setor'];
  }
}