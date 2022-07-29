import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

void executar() async{
  Directory documentDirectore =  await getApplicationDocumentsDirectory();
  String path = documentDirectore.path + "disco/db";
}
