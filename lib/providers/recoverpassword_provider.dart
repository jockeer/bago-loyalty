import 'dart:convert';
import 'package:bago/helper_clases/constantes.dart';

import 'package:http/http.dart' as http;
import 'package:bago/helper_clases/sharepreferences.dart';

class RecoverPasswordProvider {
  final preferencias = new SharedPreferencesapp();

  Future hitAccessTokenApi() async {
    String url = NetworkApp.Base +
        NetworkEndPointsApp
            .hitAccesToken; // + "?client_id=ATC_FARMACORPApp&client_secret=NTI5N2QyYmQ5NDQ0OTk1ZWE3NTg4NGIxMmM1MjY4ZDg";
    final http.Response respuesta = await http.post(url, body: {
      "client_id": "ATC_FARMACORPApp",
      "client_secret": "NTI5N2QyYmQ5NDQ0OTk1ZWE3NTg4NGIxMmM1MjY4ZDg"
    });

    Map<String, dynamic> respuestaEnMap = jsonDecode(respuesta.body);
    // print(respuestaEnMap);

    try {
      String accessToke = respuestaEnMap["access_token"];
      this.preferencias.agregarValor(Constantes.access_token, accessToke);
    } catch (exepcion) {
      print(exepcion);
    }
  }

  Future<bool> recoverPassword(String email) async {
    final String base = NetworkApp.Base;
    final String endPointLogin = NetworkEndPointsApp.recoverPassword;
    final String urlFinal = base + endPointLogin;
    final String accessToken =
        preferencias.devolverValor(Constantes.access_token, "");
    print(accessToken);

    http.Response respuesta;
    try {
      respuesta = await http
          .post(urlFinal, body: {"email": email, "access_token": accessToken});
    } catch (e) {
      return false;
    }

    try {
      final Map<String, dynamic> decodedData = json.decode(respuesta.body);

      if (decodedData.containsKey(Constantes.error)) {
        if (decodedData[Constantes.error] == "expired_token") {
          hitAccessTokenApi().then((onValue) {
            recoverPassword(email);
          });
        }

        String error = decodedData["error"];
        return false;
      } else {
        if (decodedData[Constantes.status] == true) {
          return true;
        } else {
          return false;
        }
      }
    } catch (error) {
      hitAccessTokenApi();
      return false;
    }
  }
}
