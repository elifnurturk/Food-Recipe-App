import 'package:cloud_firestore/cloud_firestore.dart';

class Gonderi {
  final String id;
  final String gonderiResmiUrl;
  final String aciklama;
  final String yayinlayanId;
  final int begeniSayisi;
  final String icindekiler;
  final String baslik;

  Gonderi({this.id, this.gonderiResmiUrl, this.aciklama, this.yayinlayanId, this.begeniSayisi, this.icindekiler, this.baslik});

  factory Gonderi.dokumandanUret(DocumentSnapshot doc) {
    var docData = doc.data();
    return Gonderi(
      id : doc.id,
      gonderiResmiUrl: docData['gonderiResmiUrl'],
      aciklama: docData['aciklama'],
      yayinlayanId: docData['yayinlayanId'],
      begeniSayisi: docData['begeniSayisi'],
      icindekiler: docData['icindekiler'],
      baslik: docData['baslik']
    );
  }

}