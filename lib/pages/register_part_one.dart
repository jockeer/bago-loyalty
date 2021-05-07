import 'package:flutter/material.dart';
import 'package:bago/helper_clases/base.dart';
import 'package:bago/helper_clases/constantes.dart';
import 'package:bago/helper_clases/sharepreferences.dart';
import 'package:bago/helper_clases/verificar_conexion.dart';
import 'package:bago/pages/register_part_two.dart';
import 'package:bago/pages/welcome_page.dart';
import 'package:bago/providers/providers.dart';
import 'dart:io' show Platform;

class RegisterPartOne extends StatefulWidget {
  RegisterPartOne({Key key}) : super(key: key);
  static final nameOfPage = 'RegisterPartOne';

  @override
  _RegisterPartOneState createState() => _RegisterPartOneState();
}

class _RegisterPartOneState extends State<RegisterPartOne> {
  VerificadorInternet verificadorInternet;
  Base base;
  final preferencias = new SharedPreferencesapp();
  Map<String, String> informacionAEnviar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificadorInternet = new VerificadorInternet();
    base = new Base();
    this.informacionAEnviar = Map<String, String>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[_fondo(), _demasElementos(context),],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  Widget _demasElementos(BuildContext contextoDemasElementos) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40.0,
          ),
          Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
              child: _cuerpoDeCampos(contextoDemasElementos)),
        ],
      ),
    );
  }

  Widget _cuerpoDeCampos(BuildContext contextoCuerpo) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            height: 130.0,
            decoration: BoxDecoration(
              border: Border.all(width: 3.0, color: Color(0xff00FEE0)),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)
              ),
              color: Color(0xff6E55BD)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'INGRESA TU ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    Text('INFORMACION',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0)),
                  ],
                ),
                SizedBox(
                  width: 15.0,
                ),
                Image(
                  image: AssetImage('assets/icons/icon_tableta.png'),
                )
              ],
            ),
          ),
          
          Container(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            decoration: BoxDecoration( 
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)) ,
              border: Border.all(width: 3.0, color: Color(0xff00FEE0)),
            ),
            child: Column(
              children: [
                textFieldNombre(contextoCuerpo),
                SizedBox(
                  height: 10.0,
                ),
                textFieldApellidos(contextoCuerpo),
                SizedBox(
                  height: 10.0,
                ),
                textFieldCorreo(contextoCuerpo),
                SizedBox(
                  height: 10.0,
                ),
                textFieldPassword(contextoCuerpo),

              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          // _codigoConsultoria(contextoCuerpo),
          SizedBox(
            height: 30.0,
          ),
          btnEnviar(contextoCuerpo)
        ],
      ),
    );
  }

  Widget _codigoConsultoria(BuildContext contextoBtnCodigo) {
    final provedorDeBloc = Provider.of(contextoBtnCodigo);
    return StreamBuilder(
        stream: provedorDeBloc.codigoConsultStreamRegisterone,
        builder: (BuildContext contexto, AsyncSnapshot<String> asyncSnapshot) {
          return TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.closed_caption),
                hintText: "Código usuario",
                // labelText: "Código consultoría",
                errorStyle: TextStyle(color: Colors.white),
                errorText: asyncSnapshot.error),
            onChanged: (value) {
              provedorDeBloc.addDataToCondigoConsRegisterOne(value);
            },
          );
        });
  }

  Widget btnEnviar(BuildContext contextoBtn) {
    final provedorDeBloc = Provider.of(contextoBtn);
    return StreamBuilder(
        stream: provedorDeBloc.validarUsuario,
        builder: (BuildContext contexto, AsyncSnapshot<bool> asyncSnapshot) {
          return Container(
            decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(width: 3.0, color: Color(0xff00FEE0))
                  ),
            child: ElevatedButton(
            onPressed: () {
              if (!asyncSnapshot.hasError &&
                  provedorDeBloc.ultimoValorName != null &&
                  provedorDeBloc.ultimoValorName != "" &&
                  provedorDeBloc.ultimoValorLastName != null &&
                  provedorDeBloc.ultimoValorLastName != "" &&
                  provedorDeBloc.ultimoValorCorreo != null &&
                  provedorDeBloc.ultimoValorCorreo != "" &&
                  provedorDeBloc.ultimoValorPassword2 != null &&
                  provedorDeBloc.ultimoValorPassword2 != ""
                  // provedorDeBloc.ultimoValorCodigoConsRegisterOne != null &&
                  // provedorDeBloc.ultimoValorCodigoConsRegisterOne != ""
                  ) {
                verificadorInternet.verificarConexion().then((valorRecibido) {
                  if (valorRecibido[Constantes.estado] ==
                      Constantes.respuesta_estado_ok) {
                    String accessToken = this
                        .preferencias
                        .devolverValor(Constantes.access_token, "null");
                    if (accessToken == "null" || accessToken == null) {
                      base.hitAccessTokenApi().then((valor) {
                        //ok aqui mandarlo a la siguiente pagina pero ya con el accessToken
                        //agregado
                        _llenarInformacion(contextoBtn);
                        String nuevoAccessToken = this
                            .preferencias
                            .devolverValor(Constantes.access_token, "null");
                        provedorDeBloc.restablecerValorRegisterPartOne();
                        Navigator.of(contextoBtn).pushReplacementNamed(
                            RegisterPartTwo.nameOfPage,
                            arguments: this.informacionAEnviar);
                      });
                    } else {
                      //aqui mandar a la siguiente pagina pero ya el accessToken ya estava
                      _llenarInformacion(contextoBtn);
                      String nuevoAccessToken = this
                          .preferencias
                          .devolverValor(Constantes.access_token, "null");
                      provedorDeBloc.restablecerValorRegisterPartOne();
                      Navigator.of(contextoBtn).pushReplacementNamed(
                          RegisterPartTwo.nameOfPage,
                          arguments: this.informacionAEnviar);
                    }
                  } else {
                    base.showSnackBar(
                        "Por favor, revisar su conexion a internet",
                        contexto,
                        Colores.COLOR_AZUL_ATC_FARMA);
                  }
                });
              } else {
                final SnackBar snackBar = new SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("Llenar todos los campos correctamente"),
                );

                Scaffold.of(contexto).showSnackBar(snackBar);
              }
            },
            child: Container(
              
              child: Text("Siguiente", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white),),
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0)
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
              ),
              elevation: 30.0,
              primary: Color(0xff6E55BD),
              

            ),
          ),
          );
        });
  }

  void _llenarInformacion(BuildContext contextoEnviar) {
    final preferencias = SharedPreferencesapp();
    final provedorDeBloc = Provider.of(contextoEnviar);
    this.informacionAEnviar = {
      Constantes.access_token:
          preferencias.devolverValor(Constantes.access_token, "null"),
      Constantes.TYPE: (Platform.isAndroid) ? "ANDROID" : "IOS",
      Constantes.NAME: provedorDeBloc.ultimoValorName,
      Constantes.EMAIL: provedorDeBloc.ultimoValorCorreo,
      Constantes.password: provedorDeBloc.ultimoValorPassword2,
      Constantes.LAST_NAME_FATHER: provedorDeBloc.ultimoValorLastName,
      Constantes.CODIGO_CONSULTORIA:
          provedorDeBloc.ultimoValorCodigoConsRegisterOne
    };
  }

  Widget textFieldPassword(BuildContext contextoPassword) {
    final provedorDeBloc = Provider.of(contextoPassword);
    return StreamBuilder(
        stream: provedorDeBloc.password2Stream,
        builder: (BuildContext contexto, AsyncSnapshot asyncSnapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CONTRASEñA:', style: TextStyle(color: Color(0xff8B3192), fontWeight: FontWeight.bold),),
                TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: BorderSide(color: Colors.transparent)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(50.0) ),
                        disabledBorder: InputBorder.none,
                        fillColor: Colors.grey[100],
                        filled: true,
                      hintText: "Contraseña",
                      // labelText: "Contraseña",
                      errorStyle: TextStyle(color: Colors.white),
                      errorText: (provedorDeBloc.ultimoValorPassword2 == "")
                          ? null
                          : asyncSnapshot.error),
                  onChanged: (value) {
                    provedorDeBloc.addDataToStreamPassword2(value);
                  },
                ),
              ],
            )
          );
        });
  }

  Widget textFieldCorreo(BuildContext contextoCorreo) {
    final provedorDeBloc = Provider.of(contextoCorreo);
    return StreamBuilder(
        stream: provedorDeBloc.emailStream,
        builder: (BuildContext contexto, AsyncSnapshot asyncSnapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CORREO ELECTRONICO:', style: TextStyle(color: Color(0xff8B3192), fontWeight: FontWeight.bold),),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: BorderSide(color: Colors.transparent)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(50.0) ),
                        disabledBorder: InputBorder.none,
                        fillColor: Colors.grey[100],
                        filled: true,
                        hintText: "Correo electrónico",
                      //labelText: "Correo electrónico",
                      errorStyle: TextStyle(color: Colors.white),
                      errorText: (provedorDeBloc.ultimoValorCorreo == "")
                          ? null
                          : asyncSnapshot.error
                  ),
                  onChanged: (value) {
                    provedorDeBloc.addDataToStreamEmail(value);
                  },
                ),
              ],
            )
          );
        });
  }

  Widget textFieldApellidos(BuildContext contextoTextFieldApellido) {
    final provedorDeBloc = Provider.of(contextoTextFieldApellido);
    return StreamBuilder(
        stream: provedorDeBloc.lastnamelStream,
        builder: (BuildContext contexto, AsyncSnapshot<String> asyncSnapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('APELLIDO(S):', style: TextStyle(color: Color(0xff8B3192), fontWeight: FontWeight.bold),),
                TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(50.0) ),
                    disabledBorder: InputBorder.none,
                    fillColor: Colors.grey[100],
                    filled: true,
                    hintText: "Apellido(s)",
                    // labelText: "Apellido(s)",
                    errorText: asyncSnapshot.error),
                onChanged: (value) {
                  provedorDeBloc.addDataToStreamLastName(value);
                },
              ),

              ],
            )
          );
        });
  }

  Widget textFieldNombre(BuildContext contextoTextFieldNombre) {
    final provedorDeBloc = Provider.of(contextoTextFieldNombre);

    return StreamBuilder(
        stream: provedorDeBloc.nameStream,
        builder: (BuildContext contexto, AsyncSnapshot<String> asyncSnapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal:  20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NOMBRE(S):', style: TextStyle(color: Color(0xff8B3192), fontWeight: FontWeight.bold),),
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: BorderSide(color: Colors.transparent)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(50.0) ),
                      disabledBorder: InputBorder.none,
                      fillColor: Colors.grey[100],
                      filled: true,
                      hintText: "Nombre(s)",
                      // labelText: "Nombre(s)",
                      errorText: asyncSnapshot.error),
                  onChanged: (value) {
                    provedorDeBloc.addDataToStreamName(value);
                  },
                )
              ],
            ),
          );
        });
  }

  Widget _fondo() {
    return Container(
      color: Colors.brown,
      width: double.infinity,
      height: double.infinity,
      child: Image(
        image: AssetImage("assets/imagenes/bago-fondo-3.png"),
        fit: BoxFit.cover,
      ),
    );
  }
}
