import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bago/helper_clases/constantes.dart';

import 'package:http/http.dart' as http;
import 'package:bago/helper_clases/sharepreferences.dart';
import 'package:bago/models/cards.dart';
import 'package:bago/pages/login_page.dart';


class PointsEveryTimeProvider {

  
  final preferencias = new SharedPreferencesapp();

  void refrescarToken (BuildContext contexto) async{  //este metodo aqui en flutter es el mismo de hitRefreshUserSpecificAccessTokenApi() en el nativo
          final String base           = NetworkApp.Base;
          final String endPointLogin  = NetworkEndPointsApp.loginUser;
          String urlFinal = base + endPointLogin;

          final http.Response respuesta = await http.post(urlFinal, 
              
                  body: {
                      Constantes.grant_type   : Constantes.refreshToken,
                      Constantes.client_id    : Constantes.stellar_app_user,
                      Constantes.refreshToken : this.preferencias.devolverValor(Constantes.refreshToken, "")
                  }

          );

        if( respuesta.statusCode == 200 ){

              try{

                    Map<String, dynamic> respuestaEnMap = respuesta.body as Map<String, dynamic>;
                     this.preferencias.agregarValor(Constantes.userSpecificToken, respuestaEnMap[Constantes.access_token]); 
                     this.preferencias.agregarValor(Constantes.refreshToken, respuestaEnMap[Constantes.refreshToken]);

              }catch( exepcion ){
                     this.preferencias.agregarValorBool(Constantes.is_refresh_token_expired, true); 
                     Navigator.of(contexto).pushReplacementNamed(
                          LoginPage.nameOfPage,
                          arguments: {
                              "fromHome"  : true,
                              "menssage"  : "Sesion expirada porfavor vuelve a iniciar sesion" 
                          }
                     );
              }

        }

  }

 static Future< List<Punto> >  obtenerPuntosEveryTime( String userEspecificParametro ) async {

      List<Punto> listaDePuntos = new List();
      final String base = NetworkApp.Base;
      final String endPointLogin = NetworkEndPointsApp.obtenerPuntosAcumulados;
       String urlFinal = base + endPointLogin ;

      final String parteEndUrl = "?access_token="+ userEspecificParametro;
      urlFinal = urlFinal + parteEndUrl;
      http.Response respuesta;

    try {
      respuesta  =  await http.get(
        urlFinal
       );
    } catch (e) {
        return listaDePuntos;
    }

      if(respuesta.statusCode == 200){  ///todo ok
          try {
                final jsonRecibido =   jsonDecode(respuesta.body) as Map<String,dynamic>;
                if(jsonRecibido.containsKey(Constantes.error)){

                        if(jsonRecibido[Constantes.error] == Constantes.expired_token){
                             listaDePuntos.add(  new Punto( name: "iniciar_sesion"  ) );
                        } else {
                              // preferencias.agregarValorBool(Constantes.is_login, false);
                              // preferencias.agregarValorBool(Constantes.is_refresh_token_expired, true); 
                               listaDePuntos.add(  new Punto( name: "iniciar_sesion"  ) );

                        }

                }else{
                    Producto productoRecibido = productoFromJson(respuesta.body);
                     listaDePuntos = productoRecibido.data;
                }        
          } catch (e) {
            print(e);
          }

      } else {
          if ( respuesta.statusCode == HttpStatus.requestTimeout ) {
               listaDePuntos.add(  new Punto(  name: "Revise su conexion a internet" ) );
          } else {
               listaDePuntos.add(  new Punto( name: "Error"  ) );
          }
      }

       

     return listaDePuntos; 
   }  
}