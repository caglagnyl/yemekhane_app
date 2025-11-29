// lib/menu_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'menu_model.dart'; // Bu dosya da lib klasöründe bulunmalıdır.

class MenuService {
  // 🚨 DİKKAT: Bu adresi kendi sunucu IP adresinizle kontrol edin!
  final String baseUrl = "http://10.228.15.220:5000/api"; 

  Future<MenuModel> fetchTodayMenu() async {
    final url = Uri.parse("$baseUrl/todaymenu");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Gelen JSON verisini MenuModel'e dönüştürür
        return MenuModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Menü yüklenemedi. Sunucu yanıt kodu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Sunucuya ulaşılamadı veya bağlantı hatası: $e');
    }
  }
}