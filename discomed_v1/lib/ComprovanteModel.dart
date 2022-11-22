class Comprovante {
  String id;
  String nf;
  String caixa;
  String envelope;
  String img;

  Comprovante({this.id, this.nf, this.caixa, this.envelope, this.img});

  Comprovante.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nf = json['nf'];
    caixa = json['caixa'];
    envelope = json['envelope'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nf'] = this.nf;
    data['caixa'] = this.caixa;
    data['envelope'] = this.envelope;
    data['img'] = this.img;
    return data;
  }
}