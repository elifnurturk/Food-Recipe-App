import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:projedersim/Widgets/ReadMoreText.dart';
import 'package:provider/provider.dart';
import 'package:projedersim/Services/Yetkilendirme.dart';
import 'package:projedersim/Models/Users.dart';
import 'package:projedersim/Models/Posts.dart';
import 'package:projedersim/Services/FirestoreService.dart';
import 'package:projedersim/Pages/Profile.dart';

import '../Colors.dart';


class GonderiKarti extends StatefulWidget {
  final Gonderi gonderi;
  final Kullanici yayinlayan;

  const GonderiKarti({Key key, this.gonderi, this.yayinlayan}) : super(key: key);

  @override
  _GonderiKartiState createState() => _GonderiKartiState();
}


class _GonderiKartiState extends State<GonderiKarti> {
  int _begeniSayisi = 0;
  bool _begendin = false;
  String _aktifKullaniciId;
  @override
  void initState() {
    super.initState();
    _aktifKullaniciId = Provider.of<YetkilendirmeServisi>(context, listen: false).aktifKullaniciId;
    _begeniSayisi = widget.gonderi.begeniSayisi;
    begeniVarmi();
  }

  begeniVarmi() async {
    bool begeniVarmi = await FireStoreServisi().begeniVarmi(widget.gonderi, _aktifKullaniciId);
    if(begeniVarmi){
      if (mounted) {
        setState(() {
          _begendin = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
            children: <Widget>[
              _gonderiBasligi(),
              _gonderiResmi(),
              _gonderiAlt(context),
            ],
          ),
    );
  }

  gonderiSecenekleri(){
    showDialog(
        context: context,
        builder: (context){
          return SimpleDialog(
            title: Text("Seçiminiz nedir?"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Gönderiyi Sil"),
                onPressed: (){
                  FireStoreServisi().gonderiSil(aktifKullaniciId: _aktifKullaniciId, gonderi: widget.gonderi);
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text("Vazgeç", style: TextStyle(color: Colors.red),),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  Widget _gonderiBasligi(){
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Profil(profilSahibiId: widget.gonderi.yayinlayanId,)));
          },
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            backgroundImage: widget.yayinlayan.fotoUrl.isNotEmpty ? NetworkImage(widget.yayinlayan.fotoUrl) : AssetImage("assets/banana.jpg"),
          ),
        ),
      ),
      title: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Profil(profilSahibiId: widget.gonderi.yayinlayanId,)));
          },
          child: Text(widget.yayinlayan.kullaniciAdi, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold,),)
      ),
      trailing: _aktifKullaniciId == widget.gonderi.yayinlayanId ? IconButton(icon: Icon(Icons.more_vert), onPressed: ()=>gonderiSecenekleri()) : null,
      contentPadding: EdgeInsets.all(0.0),
    );
  }

  Widget _gonderiResmi(){
    return GestureDetector(
      onDoubleTap: _begeniDegistir,
      child: Image.network(
        widget.gonderi.gonderiResmiUrl,
        width: MediaQuery.of(context).size.width*0.9,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _gonderiAlt(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: !_begendin ? Icon(Icons.favorite_border, size: 35.0,) : Icon(Icons.favorite, size: 35.0, color: Colors.red,),
                onPressed: _begeniDegistir
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text("$_begeniSayisi beğeni", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,)),
            ),
          ],
        ),
        Container(
          width: width*0.8,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: barColor,
          ),
        ),
        widget.gonderi.aciklama.isNotEmpty ? Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: AutoSizeText(
                     "Tarifin adı: " + widget.gonderi.baslik ,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                SizedBox(
                  height: width*0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey,),
                      width: width*0.40,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ExpandableText(
                            "İçindekiler: " + " \n " + widget.gonderi.icindekiler,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width*0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey,),
                      width: width*0.50,
                      child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ExpandableText(
                              "Yapılışı: " + " \n " + widget.gonderi.aciklama,
                            ),
                          ),

                    )
                  ]
                ),
              ],
          ),
        ) : SizedBox(height: 0.0,)
      ],
    );
  }

  void _begeniDegistir(){
    if(_begendin){
      //Kullanıcı gönderiyi beğenmiş durumda, öyleyse beğeniyi kaldıracak kodları çalıştıralım.
      setState(() {
        _begendin = false;
        _begeniSayisi = _begeniSayisi - 1;
      });
      FireStoreServisi().gonderiBegeniKaldir(widget.gonderi, _aktifKullaniciId);
    } else {
      //Kullanıcı gönderiyi beğenmemiş, beğeni ekleyen kodları çalıştıralım.
      setState(() {
        _begendin = true;
        _begeniSayisi = _begeniSayisi + 1;
      });
      FireStoreServisi().gonderiBegen(widget.gonderi, _aktifKullaniciId);
    }
  }

}