import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projedersim/Colors.dart';
import 'package:projedersim/Services/FirestoreService.dart';
import 'package:projedersim/Services/StorageService.dart';
import 'package:projedersim/Services/Yetkilendirme.dart';
import 'package:projedersim/Widgets/textField.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  File dosya;
  bool yukleniyor = false;

  TextEditingController aciklamaTextKumandasi = TextEditingController();
  TextEditingController icindekilerTextKumandasi = TextEditingController();
  TextEditingController baslikTextKumandasi = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return dosya == null ? yukleButonu() : gonderiFormu();
  }

  Widget yukleButonu(){
    return IconButton(icon: Icon(Icons.file_upload,size: 50.0,), onPressed: (){ fotografSec(); });
  }

  Widget gonderiFormu(){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: barColor,
        title: Text(
          "Gönderi Oluştur",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black,),
            onPressed: (){
              setState(() {
                dosya = null;
              });
            }
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.send, color: Colors.black,),
              onPressed: _gonderiOlustur
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            color: backGroundColor,
            width: size.width*1,
            height: size.height * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                width: size.width*0.9,
                height: size.height * 0.4,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                  child: ListView(
                    children: <Widget>[
                      yukleniyor ? LinearProgressIndicator() : SizedBox(height: 0.0,),
                      AspectRatio(
                          aspectRatio: 16.0 / 9.0,
                          child: Image.file(dosya, fit: BoxFit.cover,)
                      ),
                      TextInputField(
                        hint: 'Tarifiniz ne tarifi?',
                        inputType: TextInputType.name,
                        inputAction: TextInputAction.next,
                        controller: baslikTextKumandasi,
                        //controller: email,
                      ),
                    ],
                  ),
              ),
                SizedBox(
                  height: size.height*0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width*0.38,
                      height: size.height * 0.4,
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextInputField(
                        controller: icindekilerTextKumandasi,
                        hint: "İçindekileri yazınız.",
                        minLines: 15,
                        maxLines: 20,
                      ),
                    ),
                    SizedBox(
                      width: size.width*0.01,
                    ),
                    Container(
                      width: size.width*0.51,
                      height: size.height * 0.4,
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextInputField(
                        controller: aciklamaTextKumandasi,
                        hint: "Tarifi yazınız.",
                        minLines: 15,
                        maxLines: 20,
                      ),
                    ),
                  ],
                )
              ],
            )
          ),
        ),
    );
  }
  void _gonderiOlustur() async {

    if(!yukleniyor){

      setState(() {
        yukleniyor = true;
      });

      String resimUrl = await StorageServisi().gonderiResmiYukle(dosya);
      String aktifKullaniciId = Provider.of<YetkilendirmeServisi>(context, listen: false).aktifKullaniciId;

      await FireStoreServisi().gonderiOlustur(gonderiResmiUrl: resimUrl, aciklama: aciklamaTextKumandasi.text, yayinlayanId: aktifKullaniciId, baslik: baslikTextKumandasi.text, icindekiler:icindekilerTextKumandasi.text);

      setState(() {
        yukleniyor = false;
        aciklamaTextKumandasi.clear();
        icindekilerTextKumandasi.clear();
        baslikTextKumandasi.clear();
        dosya = null;
      });

    }

  }

  fotografSec(){
    return showDialog(
        context: context,
        builder: (context){
          return SimpleDialog(
            title: Text("Gönderi Oluştur"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Fotoğraf Çek"),
                onPressed: (){ fotoCek(); },
              ),
              SimpleDialogOption(
                child: Text("Galeriden Yükle"),
                onPressed: (){ galeridenSec(); },
              ),
              SimpleDialogOption(
                child: Text("İptal"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  fotoCek() async {
    Navigator.pop(context);
    var image = await ImagePicker().getImage(source: ImageSource.camera, maxWidth: 800, maxHeight: 600, imageQuality: 80);
    setState(() {
      dosya = File(image.path);
    });
  }

  galeridenSec() async {
    Navigator.pop(context);
    var image = await ImagePicker().getImage(source: ImageSource.gallery, maxWidth: 800, maxHeight: 600, imageQuality: 80);
    setState(() {
      dosya = File(image.path);
    });
  }
}
