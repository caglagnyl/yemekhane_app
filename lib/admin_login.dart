// lib/admin_login.dart

import 'package:flutter/material.dart';
import 'admin_panel.dart'; // Admin girişinden sonra gidilecek sayfa

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void adminGiris() {
    try {
      if (userController.text == "admin" && passController.text == "1234") {
        // 🚨 KRİTİK DÜZELTME: Başarılı girişte AdminPanel'e yönlendirme.
        // pushReplacement kullanıldı, böylece geri tuşu ile tekrar giriş ekranına dönülmez.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminPanel()), 
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Hatalı kullanıcı adı veya şifre!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş işlemi sırasında bir hata oluştu: $e")),
      );
    }
  }

  bool sifreGoster = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Giriş",
          style: TextStyle(color: Colors.white), // Metin rengi düzeltildi
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFDF0000), // const eklendi
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: "Kullanıcı Adı",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passController,
              obscureText: !sifreGoster,
              decoration: InputDecoration(
                labelText: "Şifre",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                      sifreGoster ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() => sifreGoster = !sifreGoster);
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDF0000), // const eklendi
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: adminGiris,
                child: const Text(
                  "Giriş Yap",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Metin rengi düzeltildi
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}