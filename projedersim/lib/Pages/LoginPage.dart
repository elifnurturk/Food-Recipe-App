import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:projedersim/Widgets/passwordInput.dart';
import 'package:projedersim/Widgets/roundedButton.dart';
import 'package:projedersim/Widgets/textField.dart';
import 'RegisterPage.dart';
import 'package:projedersim/Services/Yetkilendirme.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  bool yukleniyor = false;
  String email, sifre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldAnahtari,
        body: Stack(
          children: <Widget>[
            _sayfaElemanlari(),
        _yuklemeAnimasyonu(),
          ],
        ));
  }
  Widget _yuklemeAnimasyonu(){
    if(yukleniyor){
      return Center(child: CircularProgressIndicator());
    } else {
      return SizedBox(height: 0.0,);
    }
  }

  Widget _sayfaElemanlari(){
    return Form(
      key: _formAnahtari,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFCD6155),
          image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(Colors.red.withOpacity(0.7), BlendMode.dstATop),
              image: AssetImage("assets/backGroundImage.jpg")
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Hoşgeldiniz!',
                        style: TextStyle(
                            color: const Color(0xBcFFFFFF),
                            fontSize: 50,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Giriş yapın ve başlayalım...',
                        style: TextStyle(
                          color: const Color(0xBcFFFFFF),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  )
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
                      return "Şifre 4 karakterden az olamaz!";
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
                      color: Colors.brown,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                RoundedButton(
                  buttonName: 'Login',
                  onPressed: _girisYap,
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.push( context, MaterialPageRoute(builder: (context) => RegisterPage())),
              child: Container(
                child: Text(
                  'Create New Account',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.brown,
                    fontSize: 18,
                  ),
                ),
                decoration: BoxDecoration(
                    border:
                    Border(bottom: BorderSide(width: 1, color: Colors.brown))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
  void _girisYap() async {
    final _yetkilendirmeServisi = Provider.of<YetkilendirmeServisi>(context, listen: false);

    if(_formAnahtari.currentState.validate()){
      _formAnahtari.currentState.save();

      setState(() {
        yukleniyor = true;
      });

      try {
        await _yetkilendirmeServisi.mailIleGiris(email, sifre);
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

    if (hataKodu == "user-not-found") {
      hataMesaji = "Böyle bir kullanıcı bulunmuyor";
    } else if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "wrong-password") {
      hataMesaji = "Girilen şifre hatalı";
    } else if (hataKodu == "user-disabled") {
      hataMesaji = "Kullanıcı engellenmiş";
    } else {
      hataMesaji = "Tanımlanamayan bir hata oluştu $hataKodu";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);

  }

}
