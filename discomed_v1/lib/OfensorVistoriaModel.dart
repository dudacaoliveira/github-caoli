class OfensorVistoria {
  String id;
  String ofensor;


  OfensorVistoria(
      { this.id ,this.ofensor,
      });

  factory OfensorVistoria.fromJson(Map<String, dynamic> json) {
    return OfensorVistoria(
        id: json["id"].toString(),
        ofensor: json["ofensor"]);
  }

  OfensorVistoria.map(dynamic obj) {
    this.id = obj['id:'];
    this.ofensor = obj['ofensor:'];
  }

  OfensorVistoria.fromMap(Map<String, dynamic> map) {
    this.id = map["id"].toString();
    this.ofensor = map['ofensor'];
  }
}