import 'package:projedersim/Models/Users.dart';
import 'package:projedersim/Pages/LoginPage.dart';
import 'package:projedersim/Pages/MainPage.dart';
import 'package:projedersim/Services/Yetkilendirme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Yonlendirme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _yetkilendirmeServisi = Provider.of<YetkilendirmeServisi>(context, listen: false);

    return StreamBuilder(
        stream: _yetkilendirmeServisi.durumTakipcisi,
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if(snapshot.hasData){
            Kullanici aktifKullanici = snapshot.data;
            _yetkilendirmeServisi.aktifKullaniciId = aktifKullanici.id;
            return HomePage();
          } else {
            return LoginScreen();
          }
        }
    );
  }
}