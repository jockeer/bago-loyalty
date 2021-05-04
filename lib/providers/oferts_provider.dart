import 'dart:convert';
import 'dart:io';
import 'package:bago/helper_clases/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:bago/helper_clases/sharepreferences.dart';
import 'package:bago/models/oferta.dart';

class OffertProvider {
  List<Offert> listaOfertas;
  final preferencias = new SharedPreferencesapp();

  void hitAccessTokenApi() async {
    String url = NetworkApp.Base +
        NetworkEndPointsApp
            .hitAccesToken; // + "?client_id=ATC_FARMACORPApp&client_secret=NTI5N2QyYmQ5NDQ0OTk1ZWE3NTg4NGIxMmM1MjY4ZDg";
    final http.Response respuesta = await http.post(url, body: {
      "client_id": "ATC_FARMACORPApp",
      "client_secret": "NTI5N2QyYmQ5NDQ0OTk1ZWE3NTg4NGIxMmM1MjY4ZDg"
    });
    Map<String, dynamic> respuestaEnMap = jsonDecode(respuesta.body);

    try {
      String accessToke = respuestaEnMap["access_token"];
      this.preferencias.agregarValor(Constantes.access_token, accessToke);
    } catch (exepcion) {
      print(exepcion);
    }
  }

  Future<List<Offert>> obtenerOfertas() async {
    this.listaOfertas = new List();
    final String base = NetworkApp.Base;
    final String endPointLogin = NetworkEndPointsApp.obtenerOfertas;
    String urlFinal = base + endPointLogin;
    String accessToken =
        preferencias.devolverValor(Constantes.access_token, "");
    http.Response respuesta;
    urlFinal = urlFinal + "?access_token=" + accessToken;

    try {
      respuesta = await http.get(urlFinal);
    } catch (e) {
      return this.listaOfertas;
    }

    if (respuesta.statusCode == 200) {
      ///todo ok

      try {
        Map<String, dynamic> resultadoEnMapa = jsonDecode(respuesta.body);

        if (resultadoEnMapa.containsKey(Constantes.error)) {
          if (resultadoEnMapa[Constantes.error] == Constantes.expired_token) {
            hitAccessTokenApi();
            obtenerOfertas();
          }
        } else {
          Ofertas ofertas = ofertasFromJson(respuesta.body);

          this.listaOfertas = ofertas.data;
          // print("URL Jpg "+ofertas.data[0].urlJpg + " URL Pdf "+ ofertas.data[0].urlPdf);
        }
      } catch (e) {
        print(e);
      }
    } else {
      if (respuesta.statusCode == HttpStatus.requestTimeout) {
        this.listaOfertas.add(
            new Offert(nameCompany: "Porfavor revisa tu conexion a internet"));
      } else {
        this.listaOfertas.add(new Offert(nameCompany: "ERROR"));
      }
    }

    return this.listaOfertas;
  }
}
