import 'package:discomedv1/Index.dart';
import 'package:discomedv1/KmRodadoStepper.dart';
import 'package:discomedv1/Menu.dart';
import 'package:discomedv1/TelaAdicPessoas.dart';
import 'package:discomedv1/TelaCidades.dart';
import 'package:discomedv1/TelaConfiguracoes.dart';
import 'package:discomedv1/TelaDespesa.dart';
import 'package:discomedv1/TelaDetalhesKmRodado.dart';
import 'package:discomedv1/TelaEditarDespesa.dart';
import 'package:discomedv1/TelaHistoticoKm.dart';
import 'package:discomedv1/TelaListarDespAlertas.dart';
import 'package:discomedv1/TelaListarTipos.dart';
import 'package:discomedv1/TelaLugarEspecifico.dart';
import 'package:discomedv1/TelaVistoria2.dart';
import 'package:discomedv1/comprovantes.dart';
import 'package:discomedv1/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'TelaCidadesPR.dart';
import 'TelaCidadesRS.dart';
import 'TelaHistoricoDespesas.dart';
import 'TelaLoginNova.dart';
import 'TelaPreferences.dart';




void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);//fixar app na vertical
  runApp(GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => SplashScreen()),
      GetPage(name: '/Login', page: () => TelaLoginNova()),
      GetPage(
          name: '/index', page: () => Index(),
          transition: Transition.leftToRight
      ),
      GetPage(
          name: '/despesa', page: () => TelaDespesa(),
          transition: Transition.rightToLeftWithFade
      ),
      GetPage(
          name: '/cidades', page: () => TelaCidades(),
          transition: Transition.zoom
      ),
      GetPage(
          name: '/cidadesRS', page: () => TelaCidadesRS(),
          transition: Transition.zoom
      ),
      GetPage(
          name: '/cidadesPR', page: () => TelaCidadesPR(),
          transition: Transition.zoom
      ),
      GetPage(
          name: '/tipos', page: () => TelaListarTipos(),
          transition: Transition.zoom
      ),
      /* GetPage(
        name: '/kilo', page: () => TelaKilo(),
        transition: Transition.zoom
    ),*/
      GetPage(
          name: '/despRecu', page: () => TelaDespRecusada(),
          transition: Transition.fade
      ),
      GetPage(
          name: '/telaConfig', page: () => TelaConfig(),
          transition: Transition.upToDown
      ),
      GetPage(
          name: '/home3', page: () => TelaPreferences(),
          transition: Transition.upToDown
      ),
      GetPage(
          name: '/editaDespesa', page: () => TelaEditarDespesa(),
          transition: Transition.upToDown
      ),
      GetPage(
          name: '/menu', page: () => Menu(),
          transition: Transition.leftToRight
      ),
      GetPage(
          name: '/despAlertas', page: () => TelaListarDespAlertas(),
          transition: Transition.fade
      ),
      GetPage(
          name: '/lugarEspeci', page: () => TelaLugarEspecifico(),
          transition: Transition.fade
      ),
      GetPage(
          name: '/adicionarPessoas', page: () => TelaAdicPessoas(),
          transition: Transition.fade
      ),
     /* GetPage(
          name: '/telaKilometragem', page: () => TelaKilometragemNova(),
          transition: Transition.fade
      ),*/
      GetPage(
          name: '/telaHistoricoKm', page: () => TelaHistoricoKm(),
          transition: Transition.fade
      ),
      GetPage(
          name: '/telaDetalheKm', page: () => TelaDetalhesKmRodado(),
          transition: Transition.fade
      ),
      GetPage(
          name: '/telaKmRodadoStepper', page: () => KmRodadoStepper(),
          transition: Transition.fade
      ),

      GetPage(
          name: '/telaComprovantes', page: () => TelaComprovantes(),
          transition: Transition.fade
      ),
      GetPage(
          name: '/telavistoria2', page: () => TelaVistoria2(),
          transition: Transition.fade
      ),


    ],
    routingCallback: (routing) {
      if(routing.current == '/despesa'){
        print("Chamou o Routing...");
        Get.snackbar("Hi", "Sou a segunda Tela");
      }
    },
    theme: ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.lightBlueAccent,
      buttonColor: Colors.grey,
      scaffoldBackgroundColor: Colors.white,
      //canvasColor: Colors.yellow,
    ),
    localizationsDelegates: [
      GlobalWidgetsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      Locale('en', ''),
      Locale("pt","BR"),
    ],
    home:SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

