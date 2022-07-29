class StatusVistoria{
  String id;
  String status;
  String sigla;

  StatusVistoria(
      { this.id ,this.status,this.sigla
      });

  factory StatusVistoria.fromJson(Map<String, dynamic> json) {
    return StatusVistoria(
        id: json["id"].toString(),
        status: json["status"],
        sigla: json["sigla"]);
  }

  StatusVistoria.map(dynamic obj) {
    this.id = obj['id:'];
    this.status = obj['status:'];
    this.sigla = obj['sigla:'];
  }

  StatusVistoria.fromMap(Map<String, dynamic> map) {
    this.id = map["id"].toString();
    this.status = map['status'];
    this.sigla = map['sigla'];
  }
}