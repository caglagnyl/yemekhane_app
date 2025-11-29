// lib/user_data.dart

import 'package:flutter/material.dart';

// Mevcut Kullanıcı Veri Modeli
class UserData {
  static String ogrenciId = '';
}

// 🚨 Yeni Eklenen Sınıf: Kullanıcı Yönetimi Sayfası
class UserDataPage extends StatelessWidget {
  const UserDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFDF0000);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kullanıcı Yönetimi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              "Kullanıcı Yönetimi Arayüzü",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Burada kullanıcıları listeleme, ekleme ve silme işlemleri yapılır."),
          ],
        ),
      ),
    );
  }
}