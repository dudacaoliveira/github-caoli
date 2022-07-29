class LocESp {
  var id;
  String nome;


  LocESp(
      { this.id ,this.nome,
      });

  factory LocESp.fromJson(Map<String, dynamic> json) {
    return LocESp(
        id: json["id"],
        nome: json["nome"]);
  }

  LocESp.map(dynamic obj) {
    this.id = obj['id'].toString();
    this.nome = obj['nome'];
  }

  LocESp.fromMap(Map<String, dynamic> map) {
    this.id = map['id_locEsp'];
    this.nome = map['locEsp'];
  }
}