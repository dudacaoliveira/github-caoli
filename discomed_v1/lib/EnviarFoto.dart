import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp((MaterialApp(
    home: MyHomePage(),
  )));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  final picker = ImagePicker();

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera,
        maxHeight: 1024,
        maxWidth: 768,
        imageQuality: 80);

    setState(() {
      _image =  new File(pickedFile.path);
    });
    setStatus('');
  }

  Future getImageGalery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,
        maxHeight: 1024,
        maxWidth: 768,
        imageQuality: 80);

    setState(() {
      _image =  new File(pickedFile.path);
    });
    setStatus('');
  }

  //------------------Envia para servidor-------------------------------

  File tmpFile;
  Future<File> file;
  String status = '';
  var _base64 = base64Encode(id);
  String base64Image;
  static var id = utf8.encode("2020");
  String errMessage = 'Error Uploading Image';
  static final String uploadEndPoint =
      'http://discomed.com.br/webService/';

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    print("Selecionado o Botão Enviar");
    print("Aqui o endereço = ${_image.path.toString()}");
    setStatus('Uploading Image...');
    if (null == _image) {
      setStatus(errMessage);
      return;
    }
    String fileName = _image.path;//poderia tentar criptorafar aqui
    upload(fileName);
  }//fim start

  //---------Método de conversão para enviar em json---------------------------
  String _msgJson = jsonEncode(<String, String>{
    'title': "Teste",
  });//forma de enviar como json

  upload(String fileName) {
    String imagem = base64Encode(_image.readAsBytesSync());
    http.post(uploadEndPoint,
        headers:{
          'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8',"Authorization": ""
        },
        body: {
          "image": imagem,
          "name": fileName,

        }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
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
        title: Text('Enviar nota'),
      ),
      //Container Foto e botões
      body: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12)
        ),
        //color: Colors.black12,
        width:MediaQuery.of(context).size.width,
        height:300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              //color: Colors.black38,
              width:MediaQuery.of(context).size.width/1.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child: _image == null
                        ? Text('No image selected.',)
                        : Image.file(_image,
                      height: 280,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              //color: Colors.black12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(1),
                    child: FlatButton(
                      onPressed: getImageGalery,
                      color: Colors.blue,
                      padding: EdgeInsets.all(5.0),
                      child: Column( // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Icon(Icons.photo,
                            color: Colors.white,),
                          Text("Galeria",
                            style: TextStyle(
                                color: Colors.white
                            ),)
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(1),
                    child: FlatButton(
                      onPressed: getImageCamera,
                      color: Colors.blue,
                      padding: EdgeInsets.all(5.0),
                      child: Column( // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Icon(Icons.photo_camera,
                          color: Colors.white,),
                          Text("Capturar",
                          style: TextStyle(
                            color: Colors.white
                          ),)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: getImageCamera,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),*/
    );
  }
}