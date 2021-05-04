import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:bago/helper_clases/constantes.dart';
import 'package:bago/helper_clases/sharepreferences.dart';
import 'package:bago/pages/login_page.dart';
import 'package:bago/pages/register_part_one.dart';
import 'package:bago/providers/FirebaseMessaging/push_notificacions_provider.dart';
//paquetes para pruebas de imei
//import 'package:unique_identifier/unique_identifier.dart';
//import 'package:device_info/device_info.dart';

class WelcomePage extends StatefulWidget {
  static final nameOfPage = 'WelcomePage';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  /////
  String imei = "unknown";
  String imeiIos = "unknow";

  PushNotificacionProvider pushNotificacionProvider;

  //todo esto para probar imei
  int _currentPage = 0;
  final preferencias = SharedPreferencesapp();

  PageController _controladorPageView = new PageController(initialPage: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this
        .preferencias
        .agregarValor(Constantes.last_page, WelcomePage.nameOfPage);

    /*  Timer.periodic(new Duration(seconds: 3),  (Timer timer){
            if(_currentPage <= 0){
                  _currentPage++;
            }else{
                   _currentPage = 0;
            }
            _controladorPageView.animateToPage(_currentPage,  duration: Duration(milliseconds: 300), curve: Curves.easeIn);

       }); */

    // prueba imei
  }

  @override
  Widget build(BuildContext context) {
    this.pushNotificacionProvider = new PushNotificacionProvider();
    this.pushNotificacionProvider.initNotifications();

    return Scaffold(
        body: Stack(
      children: <Widget>[_fondoPageView(context), _botonesDeABajo(context)],
    ));
  }

/*
void _obTenerInformacion(){ //prueba imei

   try {
     
   if (Theme.of(context).platform == TargetPlatform.iOS) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        deviceInfo.iosInfo
            .then((onValue){
              IosDeviceInfo iosDeviceInfo = onValue;
              imeiIos =  iosDeviceInfo.identifierForVendor;
              print("identifier ios "+ imeiIos);
            });
    
    // unique ID on iOS
  } else {

     UniqueIdentifier sd = new UniqueIdentifier();   
     UniqueIdentifier.serial
          .then((onValue){
             imei = onValue;
             print("imei android "+ imei);
          });
   // unique ID on Android
  }

      
   } catch ( e ) {
      this.imeiIos = e.toString();
      this.imei    = e.toString();
      print(this.imeiIos);
      print(this.imei);
   }

} */

  Future<Map<String, dynamic>> verificarConexion() async {
    Map<String, dynamic> resultadoDeVerificacion;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        resultadoDeVerificacion = {
          Constantes.estado: Constantes.respuesta_estado_ok,
          Constantes.mensaje: "conectado"
        };
      } else {
        resultadoDeVerificacion = {
          Constantes.estado: Constantes.respuesta_estado_fail,
          Constantes.mensaje: "Por favor, revisar su conexion a internet"
        };
      }
    } catch (e) {
      resultadoDeVerificacion = {
        Constantes.estado: Constantes.respuesta_estado_fail,
        Constantes.mensaje: "Por favor, revisar su conexion a internet"
      };
    }
    return resultadoDeVerificacion;
  }

  Future hitAccessTokenApi() async {
    String url = NetworkApp.Base +
        NetworkEndPointsApp
            .hitAccesToken; // + "?client_id=ATC_FARMACORPApp&client_secret=NTI5N2QyYmQ5NDQ0OTk1ZWE3NTg4NGIxMmM1MjY4ZDg";
    http.Response respuesta;

    try {
      respuesta = await http.post(url, body: {
        "client_id": "ATC_FARMACORPApp",
        "client_secret": "NTI5N2QyYmQ5NDQ0OTk1ZWE3NTg4NGIxMmM1MjY4ZDg"
      });
      Map<String, dynamic> respuestaEnMap = jsonDecode(respuesta.body);
      String accessToke = respuestaEnMap["access_token"];
      this.preferencias.agregarValor(Constantes.access_token, accessToke);
    } catch (exepcion) {
      print(exepcion);
    }
  }

  Widget _botonOne(BuildContext contexto) {
    return SafeArea(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
          primary: Color.fromRGBO(110, 85, 189, 1),
          minimumSize: Size.fromHeight(50.0)
        ),
       
        onPressed: () {
          Navigator.pushNamed(contexto, LoginPage.nameOfPage);
        },
        child: Text(
          "Ingresar",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _botonTwo(BuildContext contexto) {
    return SafeArea(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
          primary: Color.fromRGBO(255, 255, 255, 1),
          minimumSize: Size.fromHeight(50.0)
        ),
        onPressed: () {
          Navigator.pushNamed(contexto, RegisterPartOne.nameOfPage);
        },
        
        child: Text(
          "Registrarse",
          style: TextStyle(color: Color.fromRGBO(110, 85, 189, 1)),
        ),
      ),
    );
  }

  Widget _botonesDeABajo(BuildContext contexto) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 15.0,
            ),
            Expanded(child: _botonOne(contexto)),
            SizedBox(
              width: 30.0,
            ),
            Expanded(child: _botonTwo(contexto)),
            SizedBox(
              width: 15.0,
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        )
      ],
    );
  }

  Widget _fondoOne(BuildContext contexto, Image imagen) {
    final tamanoPhone = MediaQuery.of(contexto).size;

    return Container(
      width: tamanoPhone.width,
      height: tamanoPhone.height,
      child: imagen,
    );
  }

  Widget _fondoPageView(BuildContext contexto) {
    return Builder(builder: (BuildContext contextoV) {
      verificarConexion().then((onValue) {
        if (onValue[Constantes.estado] == Constantes.respuesta_estado_ok) {
          hitAccessTokenApi();
        } else {
          final SnackBar snackBar = new SnackBar(
            backgroundColor: Colors.brown,
            content: Text("Por favor, revisar su conexion a internet"),
          );
          
          
          
          Scaffold.of(contextoV).showSnackBar(snackBar);
          Scaffold.of(contextoV).showSnackBar(snackBar);
        }
      });

      return _fondoOne(
          contexto,
          Image(
            image: AssetImage("assets/imagenes/fondo_incial_bago_temp.png"),
            fit: BoxFit.cover,
          ));

      /*PageView(
               controller: _controladorPageView,
               children: <Widget>[
                        
                        _fondoOne(contexto, Image(image: AssetImage("assets/imagenes/primera_pagina.png"), fit: BoxFit.cover,)),
                      // _fondoOne(contexto, Image(image: AssetImage("assets/imagenes/segunda_pagina.png"), fit: BoxFit.cover,)),
                      //  _fondoOne(contexto, Image(image: AssetImage("assets/imagenes/tercera_pagina.png"), fit: BoxFit.cover,))
                ],
              ); */
    });
  }
}