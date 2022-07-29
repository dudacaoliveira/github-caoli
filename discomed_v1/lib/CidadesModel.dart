class Cidades {
  String uf;
  String nomeUf;
  String municipio;
  String codMunicipioCompleto;
  String nomeMunicipio;

  Cidades(
      { this.uf,
        this.nomeUf,
        this.municipio,
        this.codMunicipioCompleto,
        this.nomeMunicipio,
});

  factory Cidades.fromJson(Map<String, dynamic> json) {
    return Cidades(
        uf: json["uf"],
        nomeUf: json["nomeUf"],
        municipio: json["municipio"],
        codMunicipioCompleto: json["codMunicipioCompleto"],
        nomeMunicipio: json["nomeMunicipio"]);
  }

  Cidades.map(dynamic obj) {
    this.uf = obj['uf'];
    this.nomeUf = obj['nomeUf'];
    this.codMunicipioCompleto = obj['codMunicipioCompleto'];
    this.nomeMunicipio = obj['nomeMunicipio'];

  }

  Cidades.fromMap(Map<String, dynamic> map) {
    this.uf = map['uf'];
    this.nomeUf = map['nomeUf'];
    this.codMunicipioCompleto = map['codMunicipioCompleto'];
    this.nomeMunicipio = map['nomeMunicipio'];
  }
}

