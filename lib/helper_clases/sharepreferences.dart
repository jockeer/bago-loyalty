
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesapp {

   static final _singleton = SharedPreferencesapp.init();
   SharedPreferences prefs ;

    factory SharedPreferencesapp(){
        return _singleton;
    }
    SharedPreferencesapp.init();

     inicializarPreferencias() async{
        this.prefs = await SharedPreferences.getInstance();
     }

     /// metodos para agregar y quitar valores 

        void agregarValor(String key, String value){
            this.prefs.setString(key, value);
        }

        

       String devolverValor(String key, String valorDefault){
            return ( this.prefs.getString(key) ) ?? valorDefault;
       }

       void agregarValorBool( String key, bool valor ){
            this.prefs.setBool(key, valor);
       }

       bool obtenerValorBool(String key){
           return this.prefs.getBool(key);
       }


       

}