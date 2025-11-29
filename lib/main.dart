// lib/main.dart

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// SAYFALARIN DOĞRU ŞEKİLDE IMPORT EDİLMESİ
import 'main_screen.dart'; 
import 'admin_login.dart'; 
import 'admin_panel.dart'; 
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'today_menu.dart'; 

// Projenin standart kırmızı rengi
const Color primaryColor = Color(0xFFDF0000); 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Türkçe tarih formatı için (Uygulama genelinde gerekli)
  await initializeDateFormatting('tr_TR', null); 

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = prefs.getBool('loggedIn');
  String? role = prefs.getString('role'); 

  Widget firstPage;

  // ============================
  //       AÇILIŞTA NEREYE GİTSİN?
  // ============================
  if (isLoggedIn == true) {
    if (role == "admin") {
      // Tüm AdminPanel'ler const olmalı
      firstPage = const AdminPanel(); 
    } else {
      firstPage = const MainScreen(); // Öğrenci ana ekranı
    }
  } else {
    firstPage = const LoginPage(); // Giriş yoksa Login sayfası
  }

  runApp(MyApp(firstPage: firstPage));
}

class MyApp extends StatelessWidget {
  final Widget firstPage;

  const MyApp({super.key, required this.firstPage});
// lib/main.dart içinde MyApp sınıfı

// ...
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Üni Yemekhane',

      // 🚨 KRİTİK DÜZELTME: Map'in başındaki 'const' silindi!
      routes: { 
        "/login": (context) => const LoginPage(),
        "/studentHome": (context) => const MainScreen(),
        "/adminLogin": (context) => const AdminLoginPage(), 
        "/adminHome": (context) => const AdminPanel(),
        "/today": (context) => const TodayMenuPage(), 
        "/register": (context) => const RegisterPage(),
        "/forgotPassword": (context) => const ForgotPasswordPage(),
      },

      home: firstPage,
    );
  }
// ...
}

//// ==================== LOGIN SAYFASI ====================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController studentController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String userType = "student";

  // ==================================
  //              LOGIN
  // ==================================
  Future<void> _login() async {
    final email = studentController.text.trim();
    final sifre = passwordController.text.trim();

    if (email.isEmpty || sifre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email ve şifre boş olamaz!")),
      );
      return;
    }

    // 🚨 Düzeltme: Admin tipi seçiliyse API'yi atla ve AdminLogin sayfasına git
    if (userType == "admin") {
        Navigator.pushReplacementNamed(context, "/adminLogin");
        return;
    }
    
    // Yalnızca userType 'student' ise aşağıdaki API çağrısı yapılır
    try {
      final url = Uri.parse("http://10.228.15.220:5000/auth/login");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "sifre": sifre,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final token = data["token"];
        final rol = data["user"]["rol"]; 

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);
        await prefs.setString("role", rol);
        await prefs.setBool("loggedIn", true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Giriş başarılı!")),
        );

        if (rol == "admin") {
          Navigator.pushReplacementNamed(context, "/adminHome");
        } else {
          Navigator.pushReplacementNamed(context, "/studentHome");
        }
      } else {
        // Hata mesajını daha anlaşılır gösterme denemesi
        final body = jsonDecode(response.body);
        final errorMessage = body['message'] ?? 'Bilinmeyen Hata';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Giriş hatası: $errorMessage"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sunucuya ulaşılamadı: $e")),
      );
    }
  }

  // ==================================
  //               UI
  // ==================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ÜST KIRMIZI BANNER
              Container(
                height: 240,
                width: double.infinity,
                color: primaryColor,
                child: const Center(
                  child: Text(
                    "ÜNİ\nYEMEKHANE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // KULLANICI ADI – email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  controller: studentController,
                  keyboardType: TextInputType.emailAddress, // Email klavyesi eklendi
                  decoration: InputDecoration(
                    labelText: userType == "student"
                        ? "Öğrenci Email"
                        : "Admin Email",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ŞİFRE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Şifre",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // KULLANICI TÜRÜ – öğrenci / admin
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kullanıcı Türü",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "student",
                          groupValue: userType,
                          onChanged: (value) {
                            setState(() => userType = value!);
                            studentController.clear();
                            passwordController.clear();
                          },
                        ),
                        const Text("Öğrenci"),
                        const SizedBox(width: 20),
                        Radio<String>(
                          value: "admin",
                          groupValue: userType,
                          onChanged: (value) {
                            setState(() => userType = value!);
                            studentController.clear();
                            passwordController.clear();
                          },
                        ),
                        const Text("Admin"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // GİRİŞ BUTONU
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 120, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Giriş Yap",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // KAYDOL
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Hesabın yok mu? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: const Text(
                      "Kaydol!",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Şifremi unuttum
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/forgotPassword");
                },
                child: const Text(
                  "Şifremi Unuttum!",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}