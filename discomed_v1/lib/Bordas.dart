import 'package:flutter/material.dart';

BoxDecoration myBoxDecorationRadBlur() {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: Colors.black12,
            blurRadius: 5
        )
      ]
  );
}


BoxDecoration myBoxDecorationGrennRadBlur() {
  return BoxDecoration(
      border: Border.all(
        color: Colors.blue, //                   <--- border color
        width: 5.0,
      ),
      borderRadius: BorderRadius.circular(30),
      color: Colors.greenAccent,
      boxShadow: [
        BoxShadow(
            color: Colors.lightBlue,
            blurRadius: 10
        )
      ]
  );
}

BoxDecoration myBoxDecoration2(Color color) {
  return BoxDecoration(
    border: Border.all(
      color: color, //                   <--- border color
      width: 2.0,
    ),
  );
}
BoxDecoration myBoxDecorationRadius() {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(30)),
    border: Border.all(
      color: Colors.red, //                   <--- border color
      width: 5.0,
    ),
  );
}

BoxDecoration myBoxDecorationOrange() {
  return BoxDecoration(
      color: Colors.orange,
      border: Border.all(
          color: Colors.pink[800],// set border color
          width: 3.0),   // set border width
      borderRadius: BorderRadius.all(
          Radius.circular(10.0)), // set rounded corner radius
      boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))]// make rounded corner of border
  );
}

BoxDecoration myBoxDecoration4() {
  return BoxDecoration(
      border: Border.all(
          width: 3.0
      ),
      color: Colors.yellowAccent,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
            color: Colors.black12,
            blurRadius: 5
        )
      ]
  );
}

Widget myButtonAzul (void Function() metodo,String txt){
  return RaisedButton(
    elevation: 0,
    onPressed: metodo,
    child: Text(txt,style:TextStyle(color: Colors.white) ,),
    color: Colors.lightBlue,
  );
}

Widget myButtonRed (void Function() metodo,String txt){
  return RaisedButton(
    elevation: 10,
    onPressed: metodo,
    child: Text(txt,style:TextStyle(color: Colors.white) ,),
    color: Colors.red,
  );
}

Widget myContainerRadBlur(String txt,BuildContext context,AlignmentGeometry alignmentGeometry) {
  return Container(
    alignment: alignmentGeometry,
    width: MediaQuery.of(context).size.width/1.5,
    margin: const EdgeInsets.all(30.0),
    padding: const EdgeInsets.all(10.0),
    decoration: myBoxDecorationRadBlur(), //             <--- BoxDecoration here
    child: Text(
      txt,
      style: TextStyle(fontSize: 30.0),
    ),
  );
}

Widget myContainergrennBlur (String txt,BuildContext context,AlignmentGeometry alignmentGeometry,Color colortext){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      alignment:alignmentGeometry,
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: myBoxDecorationGrennRadBlur(),
      child: Text(txt,style: TextStyle(fontSize: 30,color: colortext),),
    ),
  );
}

Widget myContainerYellow(String txt,BuildContext context,AlignmentGeometry alignmentGeometry) {
  return Container(
    alignment: alignmentGeometry,
    width: MediaQuery.of(context).size.width/1.5,
    margin: const EdgeInsets.all(30.0),
    padding: const EdgeInsets.all(10.0),
    decoration: myBoxDecoration4(), //             <--- BoxDecoration here
    child: Text(
      txt,
      style: TextStyle(fontSize: 30.0),
    ),
  );
}



InputDecoration decorationCampo (String labeltxt,String hinttxt,Icon icon){
  return InputDecoration(
    //icon: Icon(Icons.monetization_on,color: Colors.black26,size: 20,),
    suffixIcon: icon,
    border: OutlineInputBorder(),
    labelText: labeltxt,
    hintText: hinttxt,
  );
}

Widget campoInput(void Function() metodo,BuildContext context,String hinttxt,String labeltxt,FocusNode focusNode,FocusNode proxNode,TextInputAction textInputAction,TextEditingController textEditingController) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          onTap: metodo,
          controller: textEditingController,
          focusNode: focusNode,
          textInputAction: textInputAction,
          validator: (textEditingController) {
            if (textEditingController.isEmpty) {
              return 'Campo Obrigatório';
            }
            return null;
          },
          onFieldSubmitted: (v){
            FocusScope.of(context).requestFocus(proxNode);
          },
          decoration: decorationCampo(labeltxt, hinttxt,null)
      )
  );
}

Widget Containers(BuildContext context){
  return Column(
    children: [
      myContainergrennBlur("Grenn",context,Alignment.center,Colors.white),
      myContainerRadBlur("Formulário",context,Alignment.center),
      myContainerYellow("Aqui", context, Alignment.center),
    ],
  );
}
