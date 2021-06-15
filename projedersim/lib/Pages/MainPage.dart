import 'package:flutter/material.dart';
import 'package:projedersim/Pages/AddPage.dart';
import 'package:projedersim/Pages/Akis.dart';
import 'package:provider/provider.dart';
import 'package:projedersim/Services/Yetkilendirme.dart';
import 'package:projedersim/Pages/Profile.dart';
import 'package:projedersim/Pages/FindPage.dart';

import '../Colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _aktifSayfaNo = 0;
  PageController sayfaKumandasi;

  @override
  void initState() {
    super.initState();
    sayfaKumandasi = PageController();
  }

  @override
  void dispose() {
    sayfaKumandasi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String aktifKullaniciId = Provider.of<YetkilendirmeServisi>(context, listen: false).aktifKullaniciId;

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (acilanSayfaNo){
          setState(() {
            _aktifSayfaNo = acilanSayfaNo;
          });
        },
        controller: sayfaKumandasi,
        children: <Widget>[
          Akis(),
          Ara(),
          AddPage(),
          Profil(profilSahibiId: aktifKullaniciId,)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        currentIndex: _aktifSayfaNo,
        selectedItemColor: barColor,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Akış"),
          BottomNavigationBarItem(icon: Icon(Icons.find_in_page_outlined), label: "Keşfet"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: "Yükle"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
        ],
        onTap: (secilenSayfaNo){
          setState(() {
            sayfaKumandasi.jumpToPage(secilenSayfaNo);
          });
        },
      ),
    );
  }
}
