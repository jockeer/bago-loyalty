import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bago/helper_clases/constantes.dart';
import 'package:bago/models/redencion_one.dart';
import 'package:bago/pages/home_page.dart';
import 'package:bago/pages/redeem_two_page.dart';
import 'package:bago/providers/providers.dart';
import 'package:bago/providers/redeen_one_provider.dart';

class RedeemPageOne extends StatelessWidget {
  RedeemPageOne({Key key}) : super(key: key);
  static final nameOfPage = "RedeemPageOne";
  Map<String, String> mapaParaEnviarPorStream;
  bool internetAvaible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[_fondo(), _demasElementos(context)],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pushNamed(context, HomePage.nameOfPage),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  Widget _demasElementos(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _menuArriba(context),
          Expanded(
              child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: _contenedorOpciones(context))),
          SizedBox(
            height: 20.0,
          ),
          _btnEnviar(context),
          SizedBox(
            height: 20.0,
          )
        ],
      ),
    );
  }

  Widget _contenedorOpciones(BuildContext context) {
    final tamanoPhone = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Color(0xff7754C1),
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(width: 3.0, color: Color(0xff00FEE0))),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      width: tamanoPhone.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          Text(
            "CANJE DE PUNTOS",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 15.0,),
          Divider(
            height: 0.0,
            thickness: 4.0,
            color: Color(0xff4C91F8),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Selecione. . .",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900)),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 40.0,
              )
            ],
          ),
          ),
          
          Divider(
            height: 0.0,
            thickness: 4.0,
            color: Color(0xff4C91F8),
            
          ),
          
          Expanded(
            child: Container( 
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
                color: Colors.white,
              ),
              margin: EdgeInsets.symmetric(horizontal: 6.0) ,
              child: _textFieldSeleccionar(context)
            )
          ),
          SizedBox(height: 20.0,)
        ],
      ),
    );
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

  Widget _btnEnviar(BuildContext contexto) {
    final provedorDeBloc = Provider.of(contexto);
    return StreamBuilder<Map<String, String>>(
        stream: provedorDeBloc.radioStream,
        builder: (context, snapshot) {
          return Builder(builder: (BuildContext contextoRedeen) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color:Color(0xff00FEE0)),
                  borderRadius: BorderRadius.circular(50.0)
                ),
                child: ElevatedButton(
                  child: Container(
                    
                    padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                    child: Text('Siguiente', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900, color: Colors.white))
                  ),
                  onPressed: (snapshot.hasData)
                  ? () {
                      verificarConexion().then((onValue) {
                        if (onValue[Constantes.estado] ==
                            Constantes.respuesta_estado_ok) {
                          print(this.mapaParaEnviarPorStream);

                          Navigator.of(contexto).pushNamed(
                              //aqui estava popAndPushNamed
                              RedeenTwoPage.nameOfPage,
                              arguments:
                                  provedorDeBloc.ultimoValorSeleccionadoRadi);
                        } else {
                          final snackBar = SnackBar(
                            content: Text('Revisar su conexion a internet'),
                            backgroundColor: Colors.brown,
                          );

                          // Find the Scaffold in the widget tree and use it to show a SnackBar.
                          Scaffold.of(contextoRedeen).showSnackBar(snackBar);
                        }
                      });
                    }
                  : null,
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff7754C1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))
                  ),
                ),
              );
            
          });
        });
  }

  Widget radioTile(
      BuildContext contexto, int indice, String title, String value) {
    final provedorDeBloc = Provider.of(contexto);
    return StreamBuilder<Map<String, String>>(
        stream: provedorDeBloc.radioStream,
        builder: (context, snapshot) {
          return RadioListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 5.0),
                activeColor: Color(0xff8B3192),
                title: Text(title, style: TextStyle(color: Color(0xff8B3192)),),
                value: value,
                groupValue:
                    (snapshot.data != null) ? snapshot.data["id"] : "-1",
                onChanged: (value) {
                  this.mapaParaEnviarPorStream = {"id": value, "title": title};
                  provedorDeBloc
                      .addDataToStreamRadioRedeen(this.mapaParaEnviarPorStream);
                }
            );
          
        });
  }

  Future<Map<String, dynamic>> obtenerOpciones() {
    RedeenOneProvider redeenOneProvider = new RedeenOneProvider();
    return verificarConexion().then((valorRecibido) {
      if (valorRecibido[Constantes.estado] == Constantes.respuesta_estado_ok) {
        this.internetAvaible = true;
        return redeenOneProvider.obtainOptionsRedeen();
      } else {
        this.internetAvaible = false;
        return null;
      }
    });
  }

  Widget _textFieldSeleccionar(BuildContext context) {
    Map<String, dynamic> respuesDesdeElprovider;
    return FutureBuilder(
      future: obtenerOpciones(),
      builder: (BuildContext contexto,
          AsyncSnapshot<Map<String, dynamic>> asyncSnapshot) {
        if (!asyncSnapshot.hasError && asyncSnapshot.hasData) {
          respuesDesdeElprovider = asyncSnapshot.data;
          if (respuesDesdeElprovider.containsKey(Constantes.estado)) {
            if (respuesDesdeElprovider[Constantes.estado] ==
                Constantes.respuesta_estado_ok) {
              List<Option> opcionesLista =
                  (respuesDesdeElprovider[Constantes.mensaje] as RedencionOne)
                      .data;
              return ListView.builder(
                  itemCount: opcionesLista.length,
                  itemBuilder: (BuildContext contexto, int indice) {
                    return radioTile(contexto, indice,
                        opcionesLista[indice].name, opcionesLista[indice].id);
                  });
            } else {
              return Center(child: Text("HUBO UN PROBLEMA VUELVA INTENTARLO"));
            }
          } else {
            return Center(child: Text("HUBO UN PROBLEMA VUELVA INTENTARLO"));
          }
        } else {
          if (!this.internetAvaible) {
            return Center(child: Text("SIN CONEXION A INTERNET"));
          }

          if (asyncSnapshot.hasError) {
            return Center(child: Text("HUBO UN PROBLEMA VUELVA INTENTARLO"));
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Colores.COLOR_AZUL_ATC_FARMA),
              ),
            );
          }
        }
      },
    );
  }

  Widget _fondo() {
    return Container(
      color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Image(
        image: AssetImage("assets/imagenes/bago-fondo-2.png"),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _menuArriba(BuildContext contexto) {
    return Container(
      child: Center(
        child: Container(
          width: 200.0,
          child: Image(
            image: AssetImage("assets/icons/Logo-bago-blanco.png"),
          ),
        ),
      ),
    );
  }
}
