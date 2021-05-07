import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bago/helper_clases/constantes.dart';
import 'package:bago/helper_clases/sharepreferences.dart';
import 'package:bago/pages/home_page.dart';
import 'package:bago/pages/recover_password.dart';
import 'package:bago/pages/welcome_page.dart';
import 'package:bago/providers/FirebaseMessaging/push_notificacions_provider.dart';
import 'package:bago/providers/hitupdateDeviceToken.dart';
import 'package:bago/providers/login_provider.dart';
import 'package:bago/providers/providers.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:connectivity/connectivity.dart';

class LoginPage extends StatefulWidget {
  static final nameOfPage = 'LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController textEditingController;
  TextEditingController textEditingControllerPassword;

  bool cargando;
  final preferencias = SharedPreferencesapp();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.preferencias.agregarValor(Constantes.last_page, LoginPage.nameOfPage);
    this
        .preferencias
        .agregarValorBool(Constantes.is_refresh_token_expired, false);
    this.cargando = false;
    this.textEditingControllerPassword = new TextEditingController(text: "");
    this.textEditingController = new TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        child: Stack(
          children: <Widget>[
            _fondoApp(),
            _formulario(context),
          ],
        ),
        inAsyncCall: cargando,
        color: Colors.white,
        dismissible: true,
        progressIndicator: CircularProgressIndicator(
          valueColor:
              new AlwaysStoppedAnimation<Color>(Colores.COLOR_AZUL_ATC_FARMA),
        ),
      ),
    );
  }

  Widget _buttonBack(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextButton(
              onPressed: () {
                // Navigator.pop(context);
                Navigator.popAndPushNamed(context, WelcomePage.nameOfPage);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ))
        ],
      ),
    );
  }

  Widget _formulario(BuildContext context) {
    final tamanoPhone = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buttonBack(context),

          Container(
            width: tamanoPhone.width * 0.6,
            child: Image(
              image: AssetImage("assets/icons/logo-bago.png"),
              fit: BoxFit.cover,
            ),
          ),

          //  SizedBox( height: 50.0, ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              border: Border.all(width: 4.0, color: Colors.blue[200]),
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: Card(
              color: Colors.white,
              margin: EdgeInsets.all(0),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(15.0)),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0) ),
                      color: Color(0xff6E55BD)
                    ) ,
                    height: 50.0,
                  ),
                  SizedBox(height: 20.0,),
                  _textfieldUsuario(context),
                  SizedBox(height: 20.0,),
                 
                  _textfieldContrasena(context),
                  SizedBox(height: 20.0,),

                  _botonEnviar(context),
                 
                  SizedBox(height: 20.0,),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          GestureDetector(
              onTap: () {
                print("Tapeado");
                Navigator.of(context)
                    .popAndPushNamed(RecoverPassword.nameOfPage);
              },
              child: Text(
                "¿Olvidaste tu contraseña?",
                style: new TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }

  Future<bool> verificarInformacion(
      String carnet, String password, BuildContext context) async {
    LoginProvider loginProvider = new LoginProvider();
    final respuesta = await loginProvider.loginUser(carnet, password);

    print("valor final ----------");
    print(respuesta);
    print("------------------------");

    this.setState(() {
      this.cargando = false;
    });

    return respuesta;
  }

  void _submit() {
    this.setState(() {
      this.cargando = true;
    });
  }

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

  Widget _botonEnviar(BuildContext contextoBtnEnviar) {
    final provedorBlocLoyalty = Provider.of(contextoBtnEnviar);
    return StreamBuilder(
      stream: provedorBlocLoyalty.validarCampos,
      builder: (BuildContext contexto, AsyncSnapshot asyncSnapshot) {
        return Container(
          child: ElevatedButton(
            onPressed: () {
              if (!asyncSnapshot.hasError &&
                  provedorBlocLoyalty.ultimoValorCI != null &&
                  provedorBlocLoyalty.ultimoValorContrasena != null &&
                  provedorBlocLoyalty.ultimoValorCI != "" &&
                  provedorBlocLoyalty.ultimoValorContrasena != "") {
                Future<Map<String, dynamic>> resultadoConexion =
                    verificarConexion();
                resultadoConexion.then((mapaRecibido) {
                  if (mapaRecibido[Constantes.estado] ==
                      Constantes.respuesta_estado_ok) {
                    _submit();
                    Future<bool> resultado = verificarInformacion(
                        provedorBlocLoyalty.ultimoValorCI,
                        provedorBlocLoyalty.ultimoValorContrasena,
                        contexto);
                    resultado.then((onvalue) {
                      if (onvalue) {
                        // Navigator.of(context).popAndPushNamed(
                        //                      HomePage.nameOfPage
                        //            );
                        TokenDeviceUpdateProvider tokenDeviceUpdateProvider =
                            TokenDeviceUpdateProvider();
                        PushNotificacionProvider pushNotificacionProvider =
                            new PushNotificacionProvider();
                        //SE QUITO TODO ESTO YA QUE AUN NO ESTA EL JSON
                        pushNotificacionProvider.obtainToken().then((token) {
                          print(token);
                          tokenDeviceUpdateProvider
                              .updateTokenDevice(token)
                              .then((onValue) {
                            provedorBlocLoyalty.addDataToStreamCI("");
                            provedorBlocLoyalty.addDataToStreamPassword("");
                            Navigator.of(context)
                                .popAndPushNamed(HomePage.nameOfPage);
                          });
                        });
                      } else {
                        final SnackBar snackBar = new SnackBar(
                          backgroundColor: Colores.COLOR_AZUL_ATC_FARMA,
                          content: Text(
                              "Datos incorrectos, por favor revisar sus datos"),
                        );

                        Scaffold.of(contexto).showSnackBar(snackBar);
                      }
                    });
                  } else {
                    final SnackBar snackBar = new SnackBar(
                      backgroundColor: Colores.COLOR_AZUL_ATC_FARMA,
                      content: Text(mapaRecibido[Constantes.mensaje]),
                    );

                    Scaffold.of(contexto).showSnackBar(snackBar);
                    return;
                  }
                });
              } else {
                final SnackBar snackBar = new SnackBar(
                  backgroundColor: Colores.COLOR_AZUL_ATC_FARMA,
                  content: Text("Llenar todos los campos"),
                );

                Scaffold.of(contexto).showSnackBar(snackBar);
              }
            },
            child: Container(
                child: Text("Ingresar"),
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0)
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                
              ),
              elevation: 30.0,
              primary: Color(0xff6E55BD),

            ),
          ),
        );
      },
    );
  }

  Widget _textfieldContrasena(BuildContext context) {
    final provider = Provider.of(context);
    return StreamBuilder(
        stream: provider.contrasenaStream,
        builder: (BuildContext context, AsyncSnapshot<String> asyncSnapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: textEditingControllerPassword,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: "Contraseña",
                  labelText: "Contraseña",
                  filled: true,
                  fillColor: Colors.white,
                  errorStyle: TextStyle(color: Colors.red),
                  errorText: asyncSnapshot.error),
              onChanged: (value) {
                this.preferencias.agregarValor(Constantes.last_password, value);
                provider.addDataToStreamPassword(value);
              },
            ),
          );
        });
  }

  Widget _textfieldUsuario(BuildContext contexto) {
    final provedorDeBloc = Provider.of(contexto);
    return StreamBuilder(
        stream: provedorDeBloc.ciStream,
        builder: (BuildContext contexto, AsyncSnapshot asyncSnapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: this.textEditingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  prefixIcon: Icon(Icons.person),
                  hintText: "Número de carnet",
                  labelText: "Número de carnet",
                  fillColor: Colors.white,
                  filled: true,
                  errorStyle: TextStyle(color: Colors.red),
                  errorText: asyncSnapshot.error),
              onChanged: (value) {
                this.preferencias.agregarValor(Constantes.last_ci, value);
                provedorDeBloc.addDataToStreamCI(value);
              },
            ),
          );
        });
  }

  Widget _fondoApp() {
    return Container(
      color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Image(
        image: AssetImage("assets/imagenes/bago-fondo-temp.png"),
        fit: BoxFit.cover,
      ),
    );
  }
}
