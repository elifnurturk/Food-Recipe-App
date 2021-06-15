import 'package:flutter/material.dart';
import 'package:projedersim/Colors.dart';
import 'package:provider/provider.dart';
import 'package:projedersim/Services/Yetkilendirme.dart';
import 'package:projedersim/Models/Users.dart';
import 'package:projedersim/Models/Posts.dart';
import 'package:projedersim/Services/FirestoreService.dart';
import 'package:projedersim/Widgets/nonDeleteFutureBuilder.dart';
import 'package:projedersim/Widgets/PostCard.dart';

class Akis extends StatefulWidget {
  @override
  _AkisState createState() => _AkisState();
}

class _AkisState extends State<Akis> {
  List<Gonderi> _gonderiler = [];

  _akisGonderileriniGetir() async {
    String aktifKullaniciId = Provider.of<YetkilendirmeServisi>(context, listen: false).aktifKullaniciId;

    List<Gonderi> gonderiler = await FireStoreServisi().akisGonderileriniGetir(aktifKullaniciId);
    if (mounted) {
      setState(() {
        _gonderiler = gonderiler;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _akisGonderileriniGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anasayfa"),
        backgroundColor: barColor,
        centerTitle: true,
      ),
      body: Container(
        color: backGroundColor,
        child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: _gonderiler.length,
            itemBuilder: (context, index){
              Gonderi gonderi = _gonderiler[index];

              return SilinmeyenFutureBuilder(
                  future: FireStoreServisi().kullaniciGetir(gonderi.yayinlayanId),
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return SizedBox();
                    }
                    Kullanici gonderiSahibi = snapshot.data;
                    return GonderiKarti(gonderi: gonderi, yayinlayan: gonderiSahibi,);
                  }
              );
            }
        ),
      ),
    );
  }
}