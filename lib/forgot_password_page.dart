// lib/forgot_password_page.dart

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Kullanıcının sadece @cumhuriyet.edu.tr uzantılı mail kullanmasını sağlar.
  bool isValidStudentMail(String mail) {
    return mail.endsWith("@cumhuriyet.edu.tr");
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      // 🚨 NOT: Buraya normalde şifre sıfırlama linkini gönderecek API çağrısı gelmeli.
      
      try {
        // API çağrısı başarılıymış gibi varsayalım.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Şifre sıfırlama linki mailinize gönderildi!"),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Hata oluştu: Şifre sıfırlanamadı. $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Projenizin standart kırmızısı
    const primaryColor = Color(0xFFDF0000); 

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Şifremi Unuttum",
          style: TextStyle(color: Colors.white), // Renk düzeltildi
        ),
        centerTitle: true,
        backgroundColor: primaryColor, // Renk düzeltildi
        iconTheme: const IconThemeData(color: Colors.white), // İkon rengi düzeltildi
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView( // Klavye açıldığında taşma olmaması için eklendi
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Şifre sıfırlama linki öğrenci mailinize gönderilecektir.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 25),

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
                      return "Geçerli mail formatı değil";
                    } else if (!isValidStudentMail(value)) {
                      return "Mail @cumhuriyet.edu.tr ile bitmeli!";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _resetPassword, // Fonksiyon çağrıldı
                    child: const Text(
                      "Gönder", 
                      style: TextStyle(color: Colors.white, fontSize: 16)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}