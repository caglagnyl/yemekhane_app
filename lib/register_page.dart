// lib/register_page.dart

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
// API bağlantısı için gerekli (Kayıt işlemi için kullanılabilir)
// import 'dart:convert';
// import 'package:http/http.dart' as http; 

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController adController = TextEditingController();
  final TextEditingController soyadController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController sifreController = TextEditingController();

  bool isVisible = false; // Şifre göster/gizle

  // 📌 Cumhuriyet Mail Kontrolü
  bool isValidStudentMail(String mail) {
    return mail.endsWith("@cumhuriyet.edu.tr");
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      // 🚨 NOT: Buraya API çağrısı (http.post) eklenmelidir.

      /* try {
        // final response = await http.post(Uri.parse("YOUR_API_ENDPOINT/register"), ...);
        // if (response.statusCode == 201) { ... başarılı işlem ... }
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kayıt başarıyla oluşturuldu!")),
        );
        Navigator.pop(context);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kayıt başarısız: Sunucuya ulaşılamadı.")),
        );
      }
      */
      
      // Geçici Başarılı İşlem Simülasyonu
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kayıt başarıyla oluşturuldu! (Simülasyon)")),
      );
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    // Projenizin standart kırmızısı
    const primaryColor = Color(0xFFDF0000); 

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kayıt Ol",
          style: TextStyle(color: Colors.white), // Renk düzeltildi
        ),
        centerTitle: true,
        backgroundColor: primaryColor, // Renk düzeltildi
        iconTheme: const IconThemeData(color: Colors.white), // İkon rengi düzeltildi
      ),

      // 🚨 Düzeltme: Klavye açıldığında taşma olmaması için SingleChildScrollView eklendi.
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🧑 Ad Soyad
              _buildTextField("Ad", adController),
              const SizedBox(height: 10),
              _buildTextField("Soyad", soyadController),
              const SizedBox(height: 10),

              // 📧 Öğrenci Maili
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Öğrenci Maili",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Mail boş olamaz";
                  } else if (!EmailValidator.validate(value)) {
                    return "Geçerli bir mail girin";
                  } else if (!isValidStudentMail(value)) {
                    return "Mail @cumhuriyet.edu.tr ile bitmeli!";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              // 🔐 Şifre
              TextFormField(
                controller: sifreController,
                obscureText: !isVisible,
                decoration: InputDecoration(
                  labelText: "Şifre",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Şifre boş olamaz";
                  } else if (value.length < 6) {
                    return "Şifre en az 6 karakter olmalı";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // 🟢 Kayıt Ol Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _register, // Kayıt metodunu çağır
                  child: const Text(
                    "Kayıt Ol", 
                    style: TextStyle(color: Colors.white, fontSize: 16)
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Geri dönme linki (opsiyonel)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Zaten hesabın var mı? "),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Giriş Yap",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // 🧩 Custom Text Field Widget (AD-SOYAD)
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words, // İlk harfi büyük yapar
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label boş bırakılamaz";
        }
        return null;
      },
    );
  }
}