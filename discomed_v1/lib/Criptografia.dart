import 'package:encrypt/encrypt.dart' as enc;
import 'package:encrypt/encrypt.dart';


String criptografa(String cryp) {
  var encodedKey =
      'FCAcEA0HBAoRGyALBQIeCAcaDxYWEQQPBxcXHgAFDgY='; //CHAVE EM 256
  var encodedIv = 'DB4gHxkcBQkKCxoRGBkaFA=='; //VETOR INICIALIZAÇÃO
  final Chave =
  enc.Key.fromBase64(encodedKey); //CRIA CHAVE COM BASE NA STRING EM 256
  final Vetor =
  IV.fromBase64(encodedIv); //CRIA VETOR COM BASE NA STRING VETOR
  final TipoCriptografia =
  Encrypter(AES(Chave, mode: AESMode.cbc)); //DEFINE TIPO DE CRIPTOGRAFIA
  final TextoCriptografado =
  TipoCriptografia.encrypt(cryp, iv: Vetor); //GERA TEXTO CRIPTOGRAFADO
  final String retorno = TextoCriptografado.base64;
  //print("Aqui Cripografa ${retorno}");
  return retorno;
}

String decrip(String cryp) {
  var encodedKey =
      'FCAcEA0HBAoRGyALBQIeCAcaDxYWEQQPBxcXHgAFDgY='; //CHAVE EM 256
  var encodedIv = 'DB4gHxkcBQkKCxoRGBkaFA=='; //VETOR INICIALIZAÇÃO
  final Chave =
  enc.Key.fromBase64(encodedKey); //CRIA CHAVE COM BASE NA STRING EM 256
  final Vetor =
  IV.fromBase64(encodedIv); //CRIA VETOR COM BASE NA STRING VETOR
  final TipoCriptografia =
  Encrypter(AES(Chave, mode: AESMode.cbc)); //DEFINE TIPO DE CRIPTOGRAFIA
  final TextoDescriptografado = TipoCriptografia.decrypt64(cryp, iv: Vetor);
  //print("resposta na função decrip: ${TextoDescriptografado.toString()}");
  return TextoDescriptografado;
}