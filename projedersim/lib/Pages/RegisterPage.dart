import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projedersim/Widgets/passwordInput.dart';
import 'package:projedersim/Widgets/roundedButton.dart';
import 'package:projedersim/Widgets/textField.dart';
import '../Colors.dart';
import 'LoginPage.dart';
import 'package:provider/provider.dart';
import 'package:projedersim/Services/Yetkilendirme.dart';
import 'package:projedersim/Models/Users.dart';
import 'package:projedersim/Services/FirestoreService.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool yukleniyor = false;
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  String kullaniciAdi, email, sifre;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldAnahtari,
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFCD6155),
            image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.red.withOpacity(0.4), BlendMode.dstATop),
                image: AssetImage("assets/backGroundImage.jpg")
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Center(
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: CircleAvatar(
                        radius: size.width * 0.20,
                        backgroundColor: Colors.grey[400].withOpacity(
                          0.4,
                        ),
                        child: Icon(
                          Icons.person,
                          size: size.width * 0.25,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Form(
                key: _formAnahtari,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextInputField(
                      icon: Icons.person,
                      minLines: 1,
                      hint: 'Username',
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                      validator: (girilenDeger) {
                        if (girilenDeger.isEmpty) {
                          return "Kullanıcı adı boş bırakılamaz!";
                        } else if (girilenDeger.trim().length < 4 || girilenDeger.trim().length > 10) {
                          return "En az 4 en fazla 10 karakter olabilir!";
                        }
                        return null;
                      },
                      onSaved: (girilenDeger) => kullaniciAdi = girilenDeger,
                    ),
                    TextInputField(
                      minLines: 1,
                      icon: Icons.mail_outline,
                      hint: 'Email',
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      validator: (girilenDeger) {
                        if (girilenDeger.isEmpty) {
                          return "Email alanı boş bırakılamaz!";
                        } else if (!girilenDeger.contains("@")) {
                          return "Girilen değer mail formatında olmalı!";
                        }
                        return null;
                      },
                      onSaved: (girilenDeger) => email = girilenDeger,
                    ),
                    PasswordInput(
                      icon: Icons.vpn_key_outlined,
                      hint: 'Password',
                      inputAction: TextInputAction.done,
                      validator: (girilenDeger) {
                        if (girilenDeger.isEmpty) {
                          return "Şifre alanı boş bırakılamaz!";
                        } else if (girilenDeger.trim().length < 4) {
                          return "Şifre 6 karakterden az olamaz!";
                        }
                        return null;
                      },
                      onSaved: (girilenDeger) => sifre = girilenDeger,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'ForgotPassword'),
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: const Color(0xBcFFFFFF),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    RoundedButton(
                      buttonName: 'Register',
                      onPressed: _kullaniciOlustur
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: const Color(0xBcFFFFFF),
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push( context, MaterialPageRoute(builder: (context) => LoginScreen())),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: const Color(0xBcFFFFFF),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
    );
  }
  void _kullaniciOlustur() async {
    final _yetkilendirmeServisi = Provider.of<YetkilendirmeServisi>(context, listen: false);

    var _formState = _formAnahtari.currentState;

    if(_formState.validate()){
      _formState.save();
      setState(() {
        yukleniyor = true;
      });

      try {
        Kullanici kullanici = await _yetkilendirmeServisi.mailIleKayit(email, sifre);
        if(kullanici != null){
          FireStoreServisi().kullaniciOlustur(id: kullanici.id, email: email, kullaniciAdi: kullaniciAdi);
        }
        Navigator.pop(context);
      } catch(hata) {
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hataKodu: hata.code);
      }
    }
  }

  uyariGoster({hataKodu}){
    String hataMesaji;

    if(hataKodu == "invalid-email"){
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "email-already-in-use") {
      hataMesaji = "Girdiğiniz mail kayıtlıdır";
    } else if (hataKodu == "weak-password") {
      hataMesaji = "Daha zor bir şifre tercih edin";
    }
    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}

