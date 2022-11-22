class VistoriaModel{
    String _tipo = "";//tipo
    String _nome = "";//setor
    String _ofensor = "";//mesa,gaveta,alimento
    String _descricao = "";
    String _resultFinal = "";


    VistoriaModel();


    String get tipo => _tipo;

    set tipo(String value) {
      _tipo = value;
    }

    String get resultFinal => _resultFinal;

  set resultFinal(String value) {
    _resultFinal = value;
  }

  String get ofensor => _ofensor;

  set ofensor(String value) {
    _ofensor = value;
  }


    String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }


    VistoriaModel.fromJson(Map<String, dynamic> json) {
      nome = json['_setor'];
      ofensor = json['_ofensor'];
      descricao = json['_descricao'];
      resultFinal = json['_resultFinal'];
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['_tipo'] = this.tipo;
      data['_setor'] = this.nome;
      data['_ofensor'] = this.ofensor;
      data['_descricao'] = this.descricao;
      data['_resultFinal'] = this.resultFinal;
      return data;
    }

}