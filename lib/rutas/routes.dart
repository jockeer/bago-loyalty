import 'package:flutter/material.dart';
import 'package:bago/pages/account_detail.dart';
import 'package:bago/pages/carrito.dart';
import 'package:bago/pages/change_password.dart';
import 'package:bago/pages/enter_pin.dart';
import 'package:bago/pages/help_especifico.dart';
import 'package:bago/pages/help_page.dart';
import 'package:bago/pages/history_transfer.dart';
import 'package:bago/pages/home_page.dart';
import 'package:bago/pages/login_page.dart';
import 'package:bago/pages/map.dart';
import 'package:bago/pages/modoPago.dart';
import 'package:bago/pages/pdf_viewer.dart';
import 'package:bago/pages/recover_password.dart';
import 'package:bago/pages/redeem_one_page.dart';
import 'package:bago/pages/redeem_two_page.dart';
import 'package:bago/pages/register_part_one.dart';
import 'package:bago/pages/register_part_two.dart';
import 'package:bago/pages/terms_and_conditions.dart';
import 'package:bago/pages/ultimoPasoPedido.dart';
import 'package:bago/pages/welcome_page.dart';

Map<String, WidgetBuilder> obtenerRutas() {
  return <String, WidgetBuilder>{
    WelcomePage.nameOfPage: (BuildContext context) => WelcomePage(),
    LoginPage.nameOfPage: (BuildContext context) => LoginPage(),
    HomePage.nameOfPage: (BuildContext context) => HomePage(),
    HelpPage.namePage: (BuildContext context) => HelpPage(),
    ShowHelp.namePage: (BuildContext context) => ShowHelp(),
    RedeemPageOne.nameOfPage: (BuildContext context) => RedeemPageOne(),
    RecoverPassword.nameOfPage: (BuildContext context) => RecoverPassword(),
    RegisterPartOne.nameOfPage: (BuildContext context) => RegisterPartOne(),
    RegisterPartTwo.nameOfPage: (BuildContext context) => RegisterPartTwo(),
    EnterPinPage.nameOfPage: (BuildContext context) => EnterPinPage(),
    TermsAndConditionPage.namePage: (BuildContext context) =>
        TermsAndConditionPage(),
    AccountDetail.namePage: (BuildContext context) => AccountDetail(),
    ChangePasswordPage.nameOfPage: (BuildContext contexto) =>
        ChangePasswordPage(),
    RedeenTwoPage.nameOfPage: (BuildContext contexto) => RedeenTwoPage(),
    HistoryTransferPage.nameOfPage: (BuildContext contexto) =>
        HistoryTransferPage(),
    PdfViewer.nameOfPage: (BuildContext contexto) => PdfViewer(),
    CarritoPage.nameOfPage: (BuildContext contexto) => CarritoPage(),
    DireccionPage.nameOfPage: (BuildContext contexto) => DireccionPage(),
    ModoPago.nameOfPage: (BuildContext contexto) => ModoPago(),
    DetallePedido.nameOfPage: (BuildContext contexto) => DetallePedido()
  };
}
