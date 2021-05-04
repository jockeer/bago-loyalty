import 'dart:convert';
import 'dart:io';
import 'package:bago/helper_clases/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:bago/helper_clases/sharepreferences.dart';

class ObtainPinProvider {
  static Future<Map<String, dynamic>> obtainPin(
      String ciUserParam, String userSpecificToken) async {
    Map<String, dynamic> mapaResultadoADevolver;

    final String base = NetworkApp.Base;
    final String endPointLogin = NetworkEndPointsApp.obtenerPin;
    String urlFinal = base + endPointLogin;

    String ciUser = ciUserParam;
    String accessToke = userSpecificToken;

    http.Response respuesta;

    try {
      respuesta = await http.post(urlFinal, body: {
        "ci_customer": ciUser,
        "access_token": accessToke,
        // "key_customer": "WS_REST_FARMACORP"
      });
    } catch (e) {
      return mapaResultadoADevolver = {
        Constantes.estado: Constantes.respuesta_estado_fail,
        Constantes.mensaje: "No hay redencion 4"
      };
    }

    if (respuesta.statusCode == 200) {
      ///todo ok

      try {
        final decodedata = jsonDecode(respuesta.body);
        // print(decodedata["status"]);
        if (decodedata[Constantes.status] as bool) {
          mapaResultadoADevolver = {
            Constantes.estado: Constantes.respuesta_estado_ok,
            Constantes.mensaje: "Pin encontrado",
            Constantes.pin: decodedata[Constantes.message]
          };
        } else {
          mapaResultadoADevolver = {
            Constantes.estado: Constantes.respuesta_estado_fail,
            Constantes.mensaje: "No hay redencion 1"
          };
        }
      } catch (e) {
        mapaResultadoADevolver = {
          Constantes.estado: Constantes.respuesta_estado_fail,
          Constantes.mensaje: "No hay redencion 2"
        };
      }
    } else {
      final decodedata = jsonDecode(respuesta.body);
      print(decodedata["status"]);
      if (respuesta.statusCode == HttpStatus.requestTimeout) {
        mapaResultadoADevolver = {
          Constantes.estado: Constantes.respuesta_estado_fail,
          Constantes.mensaje:
              "Tiempo de espera excedido, por favor revisar su conexion"
        };
      } else {
        // if (decodedata[Constantes.status] as bool) {
        // if (decodedata["status"] as bool) {
        if (decodedata[Constantes.status] as bool) {
          mapaResultadoADevolver = {
            Constantes.estado: Constantes.respuesta_estado_ok,
            Constantes.mensaje: "Pin encontrado",
            Constantes.pin: decodedata[Constantes.message]
          };
        } else {
          mapaResultadoADevolver = {
            Constantes.estado: Constantes.respuesta_estado_fail,
            Constantes.mensaje: "No hay redencion 3"
          };
        }
      }
    }

    return mapaResultadoADevolver;
  }
}
