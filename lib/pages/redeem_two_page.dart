import 'package:flutter/material.dart';
import 'package:bago/helper_clases/base.dart';
import 'package:bago/helper_clases/constantes.dart';
import 'package:bago/helper_clases/verificar_conexion.dart';
import 'package:bago/models/heper_tienda.dart';
import 'package:bago/models/tienda.dart';
import 'package:bago/pages/home_page.dart';
import 'package:bago/pages/redeem_one_page.dart';
import 'package:bago/providers/insert_redeen_provider.dart';
import 'package:bago/providers/obtener_tiendas.dart';
import 'package:bago/providers/providers.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RedeenTwoPage extends StatefulWidget {
  RedeenTwoPage({Key key}) : super(key: key);
  static final nameOfPage = 'RedeenTwoPage';

  @override
  _RedeenTwoPageState createState() => _RedeenTwoPageState();
}

class _RedeenTwoPageState extends State<RedeenTwoPage> {
  String id;
  Base base;
  VerificadorInternet verificadorInternet;
  TextEditingController controladorTienda, controladorMonto;
  String id_tienda_seleccionado;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.base = Base();
    this.verificadorInternet = VerificadorInternet();
    this.controladorTienda = TextEditingController();
    this.controladorMonto = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    this.id = (ModalRoute.of(context).settings.arguments as Map)["id"];
    final provedorDeBloc = Provider.of(context);
    print(this.id);
    return Scaffold(
        body: StreamBuilder<bool>(
            stream: provedorDeBloc.streamLoadingReedenTwo,
            builder: (context, snapshot) {
              return ModalProgressHUD(
                inAsyncCall:
                    (snapshot.data == null || !snapshot.data) ? false : true,
                child: Stack(
                  children: <Widget>[_fondo(), _demasElementos(context)],
                ),
                color: Colors.white,
                dismissible: false,
                progressIndicator: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Colores.COLOR_AZUL_ATC_FARMA),
                ),
              );
            }
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          child: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushNamed(context, RedeemPageOne.nameOfPage);
          },
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
          _btnCanjear(context),
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
            "Canje de puntos",
            style:TextStyle(
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
              margin: EdgeInsets.symmetric(horizontal: 10.0) ,
              child: _textFieldSeleccionar(context)
            )
          ),
          
          SizedBox(height: 20.0,)
          
        ],
      ),
    );
  }

  Widget _textFieldSeleccionar(BuildContext contextoSeleccionar) {
    final provedorDeBloc = Provider.of(contextoSeleccionar);
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        StreamBuilder<String>(
            stream: provedorDeBloc.streamTiendaRedeenTwo,
            builder: (context, snapshot) {
              return TextField(
                controller: this.controladorTienda,
                keyboardType: TextInputType.text,
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: BorderSide(color: Colors.transparent)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(50.0) ),
                      disabledBorder: InputBorder.none,
                      fillColor: Colors.grey[100],
                      filled: true,
                    hintText: "Seleccione una tienda",
                    prefixIcon: Icon(Icons.home),
                    suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
                    //labelText: "Seleccione una tienda",
                    errorStyle: TextStyle(color: Colors.white),
                    errorText: snapshot.error),
                onChanged: (value) {},
                onTap: () {
                  FocusScope.of(contextoSeleccionar)
                      .requestFocus(new FocusNode());
                  this.verificadorInternet.verificarConexion().then((onValue) {
                    if (onValue[Constantes.estado] ==
                        Constantes.respuesta_estado_ok) {
                      _tiendasDialog(contextoSeleccionar);
                    } else {
                      this.base.showSnackBar(
                          Constantes.error_conexion, context, Colors.brown);
                    }
                  });
                },
              );
            }),
        SizedBox(
          height: 10.0,
        ),
        StreamBuilder<String>(
            stream: provedorDeBloc.streamMontoRedeenTwo,
            builder: (context, snapshot) {
              return TextField(
                controller: this.controladorMonto,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(50.0) ),
                    disabledBorder: InputBorder.none,
                    fillColor: Colors.grey[100],
                    filled: true,
                    hintText: "Monto",
                    prefixIcon: Icon(Icons.attach_money_rounded),
                    //labelText: "Seleccione una tienda",
                    errorStyle: TextStyle(color: Colors.white),
                    errorText: snapshot.error),
                onChanged: (value) {
                  provedorDeBloc.addDataToMontoRedeenTwo(value);
                },
              );
            })
      ],
    );
  }

  void _tiendasDialog(BuildContext contexto) {
    TiendasProvider tiendasProvider = new TiendasProvider();
    final provedorDeBloc = Provider.of(contexto);
    final tamanoPhone = MediaQuery.of(contexto).size;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.white),
              height: tamanoPhone.height * 0.15,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FutureBuilder(
                    future: tiendasProvider.obtenerTiendas(contexto, this.id),
                    builder: (BuildContext contexto,
                        AsyncSnapshot<Map<String, dynamic>> asyncSnapshot) {
                      if (!asyncSnapshot.hasError && asyncSnapshot.hasData) {
                        Map<String, dynamic> respuesta = asyncSnapshot.data;

                        if (respuesta[Constantes.estado] ==
                            Constantes.respuesta_estado_ok) {
                          List<StoreInfo> listaDeTiendas =
                              respuesta[Constantes.mensaje] as List<StoreInfo>;
                          return ListView.builder(
                              itemCount: listaDeTiendas.length,
                              itemBuilder: (BuildContext contexto, int indice) {
                                return GestureDetector(
                                  child: Card(
                                    elevation: 10.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text(
                                              listaDeTiendas[indice].name)),
                                    ),
                                  ),
                                  onTap: () {
                                    print(listaDeTiendas[indice].name);
                                    this.controladorTienda.text =
                                        listaDeTiendas[indice].name;
                                    this.id_tienda_seleccionado =
                                        listaDeTiendas[indice].id;
                                    provedorDeBloc.addDataToTiendaRedeenTwo(
                                        listaDeTiendas[indice].name);
                                    Navigator.of(contexto).pop();
                                  },
                                );
                              });
                        } else {
                          return Center(
                            child: Text(respuesta[Constantes.mensaje]),
                          );
                        }
                      } else {
                        return Center(
                          child: this.base.retornarCircularCargando(
                              Colores.COLOR_AZUL_ATC_FARMA),
                        );
                      }
                    }),
              ),
            ),
          );
        });
  }

  Widget _btnCanjear(BuildContext contexto) {
    final provedorDeBloc = Provider.of(contexto);
    InsertRedeenProvider insertRedeenProvider = new InsertRedeenProvider();
    return StreamBuilder<bool>(
        stream: provedorDeBloc.validarCamposRedeenTwo,
        builder: (context, snapshot) {
          return Container(
            decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color:Color(0xff00FEE0)),
                  borderRadius: BorderRadius.circular(50.0)
                ),
            child: ElevatedButton(
            onPressed: (snapshot.hasData && snapshot.data)
                ? () {
                    this
                        .verificadorInternet
                        .verificarConexion()
                        .then((onValue) {
                      if (onValue[Constantes.estado] ==
                          Constantes.respuesta_estado_ok) {
                        //aqui poner el pre loading y llamar al servicio
                        provedorDeBloc.addDataToLoadingReedenTwo(true);
                        insertRedeenProvider
                            .insertarRedencion(
                                contexto,
                                provedorDeBloc.ultimoValorMontRedeenTwo,
                                this.id_tienda_seleccionado)
                            .then((onValue) {
                          provedorDeBloc.addDataToLoadingReedenTwo(false);
                          if (onValue[Constantes.estado] ==
                              Constantes.respuesta_estado_ok) {
                            //aqui borrar a cero los streamings de monto y tienda
                            provedorDeBloc.addDataToTiendaRedeenTwo("");
                            provedorDeBloc.addDataToMontoRedeenTwo("0");
                            _mostrarPin(contexto, onValue[Constantes.pin]);
                            print(onValue);
                          } else {
                            _dialogSalirPuntosMenos(
                                contexto, onValue[Constantes.mensaje]);
                            //this.base.showSnackBar(onValue[Constantes.mensaje], context,Colors.brown);
                          }
                        });
                      } else {
                        this.base.showSnackBar(
                            Constantes.error_conexion, context, Colors.brown);
                      }
                    });
                  }
                : null,
            child: Container(
                    
                    padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                    child: Text('Canjear', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900, color: Colors.white))
            ),
            style: ElevatedButton.styleFrom(
                    primary: Color(0xff7754C1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))
            ),
          )
          );
        });
  }

  Widget _filaBotones(BuildContext contextoFilaBotones) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 3.0),
            child: RaisedButton(
              onPressed: () {
                Navigator.of(contextoFilaBotones)
                    .popAndPushNamed(HomePage.nameOfPage);
              },
              child: Container(
                  child: Text("Si, Seguro Salir"),
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 30.0,
              color: Colors.white,
              textColor: Colors.black,
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 3.0),
            child: RaisedButton(
              onPressed: () {
                Navigator.of(contextoFilaBotones).pop();
              },
              child: Container(
                  child: Text("Ver pin"),
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 30.0,
              color: Colors.white,
              textColor: Colors.black,
            ),
          ),
        )
      ],
    );
  }

  void _confirmarDialogSalida(BuildContext contextoBtnSalir) {
    final tamanoPhone = MediaQuery.of(contextoBtnSalir).size;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Color(0xffBF0183)),
              height: tamanoPhone.height * 0.40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Image(
                        image: AssetImage("assets/icons/Logo-bago-blanco.png")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "No volver?? a ver su pin de redenci??n. ??Est?? seguro que desea salir?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                  Expanded(
                    child: _filaBotones(contextoBtnSalir),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _mostrarPin(BuildContext contexto, String pin) {
    final tamanoPhone = MediaQuery.of(contexto).size;
    final provedorDeBloc = Provider.of(contexto);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Color(0xffBF0183)),
              height: tamanoPhone.height * 0.40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Image(
                        image: AssetImage(
                            "assets/icons/Logo-bago-blanco.png")),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 4.0, bottom: 8.0, left: 8.0, right: 8.0),
                    child: Text(
                      "Por favor, dicte este pin: " + pin,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      //aqui si presiona ok volver al home
                      _confirmarDialogSalida(contexto);
                    },
                    child: Container(
                        child: Text("Salir"),
                        padding: EdgeInsets.symmetric(
                            horizontal: 75.0, vertical: 0.0)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 30.0,
                    color: Colors.white,
                    textColor: Colors.black,
                  ),
                  Expanded(child: Container())
                ],
              ),
            ),
          );
        });
  }

  void _dialogSalirPuntosMenos(
      BuildContext contextBtnpuntosMenos, String mensajeAMostrar) {
    final tamanoPhone = MediaQuery.of(contextBtnpuntosMenos).size;
    final provedorDeBloc = Provider.of(contextBtnpuntosMenos);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Color(0xffBF0183)),
              height: tamanoPhone.height * 0.35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Image(
                        image: AssetImage("assets/imagenes/logo_fridolin.png")),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 4.0, bottom: 8.0, left: 8.0, right: 8.0),
                    child: Text(
                      mensajeAMostrar,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        provedorDeBloc.addDataToTiendaRedeenTwo("");
                        provedorDeBloc.addDataToMontoRedeenTwo("0");
                        Navigator.of(contextBtnpuntosMenos)
                            .popAndPushNamed(HomePage.nameOfPage);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Container(
                            child: Text("De acuerdo"),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0)),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 30.0,
                      color: Colors.white,
                      textColor: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  )
                ],
              ),
            ),
          );
        });
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

  //  GestureDetector(
  //        child: Icon(Icons.arrow_back_ios, color: Colors.white,),
  //       onTap: () {
  //           provedorDeBloc.addDataToTiendaRedeenTwo("");
  //           provedorDeBloc.addDataToMontoRedeenTwo("0");
  //           Navigator.of(contexto).pop();
  //      },
  //    ),

  Widget _fondo() {
    return Container(
      color: Colors.brown,
      width: double.infinity,
      height: double.infinity,
      child: Image(
        image: AssetImage("assets/imagenes/bago-fondo-2.png"),
        fit: BoxFit.cover,
      ),
    );
  }
}
