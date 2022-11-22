
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'Criptografia.dart';
import 'Urls.dart';
class TelaImagemComp extends StatefulWidget {
  @override
  _TelaImagemCompState createState() => _TelaImagemCompState();
}

class _TelaImagemCompState extends State<TelaImagemComp> {
  File _image = null;
  bool visualizaContainer = true;
  String _imageRecu = Get.parameters["image"];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(_imageRecu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Foto do Canhoto",style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.red,
          ),
          //onPressed: (){Get.toNamed("/index?device=phone&id=${_id} &nome=${_nome}");},
          onPressed: (){
            FocusScope.of(context).unfocus();
            Navigator.pop(context);},

        ),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Center(
              child: _image == null
                  ? null
                  : Padding(padding: EdgeInsets.all(10),
                child: Image.file(_image,
                  //height: 280,
                  fit: BoxFit.fill,
                ),
              )
          ),
          Visibility(
            visible: visualizaContainer == true,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: Image.network(
                    //'http://discomed.com.br/extranet/modulos/despesas/imgs/8090066655f5f9777ca9f05.29638799.jpg',
                    'https://discomed.com.br/extranet/modulos/comprovantes/img/${_imageRecu+".jpg"}',
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace){
                      return Text("Imagem Não encontrada!!!");
                    },
                    //height: 400,
                  )
              ),
            ),
          )
        ],
      ),

    );
  }
}
