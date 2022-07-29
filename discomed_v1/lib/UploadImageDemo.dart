import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class UploadImageDemo extends StatefulWidget {
  UploadImageDemo() : super();

  final String title = "Inserir Imagem";

  @override
  UploadImageDemoState createState() => UploadImageDemoState();
}

class UploadImageDemoState extends State<UploadImageDemo> {
  //
  static final String uploadEndPoint =
      'http://discomed.com.br/webService/';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  static var id = utf8.encode("2020");
  var _base64 = base64Encode(id);
  String _msg = "oi";
  String _tituloApp = "Selecione uma imagem!";
  var md5 ;
  var _testemd5;





  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery,
          maxHeight: 1024,
          maxWidth: 768,
          imageQuality: 80);
      _tituloApp = "Foto selecionada da galeria";
    });
    setStatus('');
  }

  Future chooseImage2()  {

    setState(() async {
      //file = ImagePicker.pickImage(source: ImageSource.camera,
      file = ImagePicker.pickImage(source: ImageSource.camera,
          maxHeight: 1024,
          maxWidth: 768,
          imageQuality: 80);
      _tituloApp = "Imagem capturada!";
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);

  }

  /*String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }*/


  String _msgJson = jsonEncode(<String, String>{
    'title': "Teste",
  });//forma de enviar como json



  upload(String fileName) {
    _testemd5 =  generateMd5("Teste MD5");

    http.post(uploadEndPoint,
        headers:{
          'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8',"Authorization": "${_base64}"
        },
        body: {
          "image": base64Image,
          //"name": fileName,
          "id": _base64,
          "teste": _msgJson,
          //"testemd5": _testemd5,

        }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
  }

  Future <String> _future;

  Future<String> create() async {
    String url = "http://discomed.com.br/webService/";
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'ID': "1000",
        //'Duda': "${md5duda}",
      }),
    );
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloApp),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            OutlineButton(
              onPressed: chooseImage,
              child: Text('Abrir Galeria'),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: FloatingActionButton(
                  child: Icon(Icons.add_a_photo),
                  backgroundColor: Colors.pinkAccent,
                  onPressed: chooseImage2
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            showImage(),
            SizedBox(
              height: 20.0,
            ),
            OutlineButton(
              onPressed: startUpload,
              child: Text('Enviar'),
            ),

            SizedBox(
              height: 20.0,
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
