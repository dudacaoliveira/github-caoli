class Usuario {
  String id;
  String nome;
  String status;


  Usuario(
      { this.id ,this.nome,this.status
      });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(

        id: json["id"],
        nome: json["nome"],
        status:json["status"]);
  }

  Usuario.map(dynamic obj) {
    this.id = obj['id:'];
    this.nome = obj['nome:'];
    this.status = obj['status:'];
  }

  Usuario.fromMap(Map<String, dynamic> map) {
    this.id = map["id"].toString();
    this.nome = map['nome'];
    this.status = map['status'];
  }
}

