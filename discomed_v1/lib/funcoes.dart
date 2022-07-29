/*Future <String> create2() async {

  final String TextoEmail = _textEditingController_email.text; //Textoemail PARA DESCRIPTOGRAFAR
  final String TextoSenha = _textEditingController_senha.text; //Textosenha PARA DESCRIPTOGRAFAR
  var encodedKey = 'FCAcEA0HBAoRGyALBQIeCAcaDxYWEQQPBxcXHgAFDgY='; //CHAVE EM 256
  var encodedIv = 'DB4gHxkcBQkKCxoRGBkaFA=='; //VETOR INICIALIZAÇÃO
  final Chave = enc.Key.fromBase64(encodedKey); //CRIA CHAVE COM BASE NA STRING EM 256
  final Vetor = IV.fromBase64(encodedIv); //CRIA VETOR COM BASE NA STRING VETOR
  final TipoCriptografia = Encrypter(AES(Chave, mode: AESMode.cbc)); //DEFINE TIPO DE CRIPTOGRAFIA
  final EmailCriptografado = TipoCriptografia.encrypt(TextoEmail, iv: Vetor); //GERA TEXTO CRIPTOGRAFADO
  final SenhaCriptografado = TipoCriptografia.encrypt(TextoSenha, iv: Vetor); //GERA TEXTO CRIPTOGRAFADO


  //ENVIA TEXTO CRIPTOGRAFADO E DESCRIPTOGRAFA RETORNO
  String url = "http://discomed.com.br/webService/";
  final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8',
        "Email":"${EmailCriptografado.base64}",
        "Senha":"${SenhaCriptografado.base64}",

      },
      body: {
        "modulo": "bG9nYXJVc3Vhcmlv"
      }
  );
  final TextoDescriptografado = TipoCriptografia.decrypt64(response.body, iv: Vetor);
  print("resposta: ${TextoDescriptografado.toString()}");
}*/


/*Future<String> create() async {

  String _email =  _textEditingController_email.text;
  String _senha =  _textEditingController_senha.text;

  var encodedKey = 'FCAcEA0HBAoRGyALBQIeCAcaDxYWEQQPBxcXHgAFDgY=';
  var encodedIv = 'DB4gHxkcBQkKCxoRGBkaFA==';
  //var encryptedBase64EncodedString = new File(filePath).readAsStringSync();
  //var decoded = base64.decode(encryptedBase64EncodedString);


  final key1 = enc.Key.fromBase64(encodedKey);
  final iv = enc.IV.fromBase64(encodedIv);
  final encrypter = enc.Encrypter(enc.AES(key1, mode: enc.AESMode.cbc));

  //final encrypted = encrypter.encrypt(plainText, iv: iv);
  //final decrypted = encrypter.decrypt(encrypted, iv: iv);

  *//*print(decrypted);
    print(encrypted.bytes);
    print(encrypted.base16);
    print(encrypted.base64);*//*

  //final decrypted = encrypter.decryptBytes(enc.Encrypted(decoded), iv: iv);
  //final filename = '${p.basenameWithoutExtension(filePath)}.mp4';
  //final directoryName=p.dirname(filePath);
  //final newFilePath=p.join(directoryName, filename);
  //var newFile = new File(newFilePath);
  //await newFile.writeAsBytes(decrypted);
  //return newFilePath;

  String url = "http://discomed.com.br/webService/";
  final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8',
        "USUARIO":"${_email}",
        "SENHA":"${_senha}",
        //"TESTE":"${encrypted}",
        "Authorization" : "${_email}:${_senha}",
      },
      body: {

        "modulo":"bG9nYXJVc3Vhcmlv",
      }
  );
}*/

