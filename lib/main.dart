import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bago/helper_clases/constantes.dart';
import 'package:bago/helper_clases/sharepreferences.dart';
import 'package:bago/pages/welcome_page.dart';
import 'package:bago/providers/providers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bago/rutas/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new SharedPreferencesapp();
  await prefs.inicializarPreferencias();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final preferencias = SharedPreferencesapp();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Color(0xffBF0183),
        
      )
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        /* FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
              
             } */
      },
      child: Provider(
        child: MaterialApp(
          localizationsDelegates: [
            // ... app-specific localization delegate[s] here
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'), // English
            const Locale('es'), // Hebrew
          ],
          debugShowCheckedModeBanner: false,
          title: 'bago',
          theme: ThemeData(
            primaryColor: Colores.COLOR_AZUL_ATC_FARMA,
            secondaryHeaderColor: Colores.COLOR_NARANJA_ATC_FARMA,
          ),
          initialRoute: preferencias.devolverValor(
              Constantes.last_page, WelcomePage.nameOfPage),
          routes: obtenerRutas(),
        ),
      ),
    );
  }
}
