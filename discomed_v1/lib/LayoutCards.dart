import 'package:flutter/material.dart';

Widget MyCardMenu(String text,Icon icon,Color color){
  return Container(
    height: 70,
    child: Card(
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: icon,
              )
          ),
          Text(text,style: TextStyle(color: color),),
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
    ),
  );
}