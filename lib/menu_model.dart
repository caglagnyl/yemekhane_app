import 'dart:convert';
import 'package:http/http.dart' as http;

class MenuModel {
  final int id;
  final String tarih;
  final List<String> yemekler;
  final double ortalamaPuan;
  final int puanlayanKisiSayisi;

  MenuModel({
    required this.id,
    required this.tarih,
    required this.yemekler,
    required this.ortalamaPuan,
    required this.puanlayanKisiSayisi,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    // Eğer backend "yemekler": ["...", "..."] diye liste gönderiyorsa onu kullan
    // Göndermiyorsa yemek1–4 alanlarından liste oluştur.
    List<String> yemekListesi;

    if (json['yemekler'] is List) {
      yemekListesi =
          (json['yemekler'] as List).map((e) => e.toString()).toList();
    } else {
      yemekListesi = [
        if (json['yemek1'] != null) json['yemek1'].toString(),
        if (json['yemek2'] != null) json['yemek2'].toString(),
        if (json['yemek3'] != null) json['yemek3'].toString(),
        if (json['yemek4'] != null) json['yemek4'].toString(),
      ];
    }

    return MenuModel(
      id: json['id'] ?? 0,
      tarih: json['tarih']?.toString() ?? "",
      yemekler: yemekListesi,
      ortalamaPuan:
          (json['ortalama_puan'] ?? json['ortalamaPuan'] ?? 0).toDouble(),
      puanlayanKisiSayisi:
          (json['puanlayan_kisi_sayisi'] ?? json['puanlayanKisiSayisi'] ?? 0)
              as int,
    );
  }
}

