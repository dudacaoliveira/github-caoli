import 'dart:async';

import 'package:flutter/material.dart';
import 'package:async/async.dart';

import 'Home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 3),(){
      /*Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context)=>Home(),
      ));*/
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
        transitionDuration: Duration(seconds: 2),
        transitionsBuilder: (BuildContext context,
            Animation<double>animation,Animation<double> secAnimation,
            Widget child){
          animation = CurvedAnimation(parent: animation,curve:Curves.elasticOut);
          return ScaleTransition(
            alignment: Alignment.center,
            scale: animation,
            child: child,
          );
        },
        pageBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secAnimation,
            ){

          return Home();
      }
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Loading..."),
            SizedBox(height: 50.0,),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.pink),
              strokeWidth: 11.0,
            )
          ],
        ),
      ),
    );
  }
}
