import 'dart:convert';
import 'package:bago/helper_clases/constantes.dart';
import 'package:bago/helper_clases/sharepreferences.dart';
import 'package:bago/models/questions.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class PreguntasProvider {
  List<Pregunta> listaPreguntas;
  final preferencias = new SharedPreferencesapp();

  void hitAccessTokenApi() async {
    String url = NetworkApp.Base +
        NetworkEndPointsApp
            .hitAccesToken; //+ "?client_id=ATC_FARMACORPApp&client_secret=NTI5N2QyYmQ5NDQ0OTk1ZWE3NTg4NGIxMmM1MjY4ZDg";
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

  Future<List<Pregunta>> obtenerPreguntas() async {
    this.listaPreguntas = new List();
    final String base = NetworkApp.Base;
    final String endPointLogin = NetworkEndPointsApp.getQuestionFaqs;
    String urlFinal = base + endPointLogin;

    String accessToken =
        preferencias.devolverValor(Constantes.access_token, "");

    urlFinal = urlFinal + "?access_token=" + accessToken;
    http.Response respuesta;

    try {
      respuesta = await http.get(urlFinal);
    } catch (e) {
      this.listaPreguntas.add(new Pregunta(
          question: "Tiempo de espera excedido, verificar internet"));
      return this.listaPreguntas;
    }

    if (respuesta.statusCode == 200) {
      ///todo ok

      try {
        Map<String, dynamic> resultadoEnMapa = jsonDecode(respuesta.body);

        if (resultadoEnMapa.containsKey(Constantes.error)) {
          if (resultadoEnMapa[Constantes.error] == Constantes.expired_token) {
            hitAccessTokenApi();
            obtenerPreguntas();
          }
        } else {
          Preguntas preguntas = preguntasFromJson(respuesta.body);

          this.listaPreguntas = preguntas.data;
        }
      } catch (e) {
        print(e);
      }
    } else {
      if (respuesta.statusCode == HttpStatus.requestTimeout) {
        this.listaPreguntas.add(new Pregunta(
            question: "Tiempo de espera excedido, verificar internet"));
      } else {
        this.listaPreguntas.add(new Pregunta(question: "ERROR"));
      }
    }

    return this.listaPreguntas;
  }
}
