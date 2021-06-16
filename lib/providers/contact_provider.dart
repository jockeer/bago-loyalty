import 'dart:convert';

import 'package:bago/helper_clases/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:bago/helper_clases/sharepreferences.dart';
import 'package:bago/models/contacto.dart';
import 'dart:io';

class ContactProvider {
  final preferencias = new SharedPreferencesapp();
  Contacto contacto;

  void hitAccessTokenApi() async {
    String url = NetworkApp.Base +
        NetworkEndPointsApp
            .hitAccesToken; // + "?client_id=BAGOApp&client_secret=MDQ5MWUzNTIwZDAwNTdjOTdkNDI0YjA4MTFkZDA0MGI";
    final http.Response respuesta = await http.post(url, body: {
      "client_id": "BAGOApp",
      "client_secret": "MDQ5MWUzNTIwZDAwNTdjOTdkNDI0YjA4MTFkZDA0MGI"
    });
    Map<String, dynamic> respuestaEnMap = jsonDecode(respuesta.body);

    try {
      String accessToke = respuestaEnMap["access_token"];
      this.preferencias.agregarValor(Constantes.access_token, accessToke);
    } catch (exepcion) {
      print(exepcion);
    }
  }

  Future<Contacto> obTainContacts() async {
    this.contacto = new Contacto();

    final String base = NetworkApp.Base;
    final String endPointLogin = NetworkEndPointsApp.getContact;
    final String accesToken =
        this.preferencias.devolverValor(Constantes.access_token, "");
    final String urlFinal =
        base + endPointLogin + "?access_token=" + accesToken;

    http.Response respuesta;

    try {
      respuesta = await http.get(urlFinal);
    } catch (e) {
      this.contacto.email = "Catch error";
      return this.contacto;
    }

    if (respuesta.statusCode == 200) {
      try {
        Map<String, dynamic> enMapaResultadoRecibido =
            jsonDecode(respuesta.body);

        if (enMapaResultadoRecibido.containsKey(Constantes.error)) {
          if (enMapaResultadoRecibido[Constantes.error] ==
              Constantes.expired_token) {
            hitAccessTokenApi();
            obTainContacts();
          }
        } else {
          this.contacto = contactoFromJson(respuesta.body);
        }
      } catch (e) {
        this.contacto.email = "error";
      }
    } else {
      if (respuesta.statusCode == HttpStatus.requestTimeout) {
        this.contacto.email = "Revise su conexion a internet porfavor";
      }
    }
    return this.contacto;
  }
}
