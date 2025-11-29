import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:yemekhane_app/admin_login.dart';

// SAYFALAR
import 'package:yemekhane_app/main_screen.dart';    // Öğrenci ana sayfa
import 'package:yemekhane_app/admin_panel.dart';    // Admin ana sayfa
import 'package:yemekhane_app/register_page.dart';
import 'package:yemekhane_app/forgot_password_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/login": (context) => const LoginPage(),
        "/studentHome": (context) => const MainScreen(),
        "/adminHome": (context) =>  AdminLoginPage(),
      },
      home: const LoginPage(),
    );
  }
}

// ==================== LOGIN SAYFASI ====================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController studentController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  // 🔥 Varsayılan olarak öğrenci seçili
  String userType = "student";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ÜST KIRMIZI ALAN
              Container(
                height: 240,
                width: double.infinity,
                color: const Color(0xFFDF0000),
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

              // ----------------------------
              //  ÖĞRENCİ NUMARASI ALANI
              // ----------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  controller: studentController,
                  decoration: InputDecoration(
                    labelText: userType == "student"
                        ? "Öğrenci Numarası"
                        : "Admin Kullanıcı Adı",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ŞİFRE ALANI
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

              // ----------------------------
              //   KULLANICI TÜRÜ (Admin / Öğrenci)
              // ----------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kullanıcı Türü",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "student",
                          groupValue: userType,
                          onChanged: (value) {
                            setState(() => userType = value!);
                          },
                        ),
                        const Text("Öğrenci"),
                        const SizedBox(width: 20),
                        Radio<String>(
                          value: "admin",
                          groupValue: userType,
                          onChanged: (value) {
                            setState(() => userType = value!);
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
                onPressed: () {
                  if (userType == "admin") {
                    Navigator.pushReplacementNamed(context, "/adminHome");
                  } else {
                    Navigator.pushReplacementNamed(context, "/studentHome");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDF0000),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 120, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Giriş Yap",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              // Kaydol & Şifremi Unuttum
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Hesabın yok mu? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const RegisterPage()));
                    },
                    child: const Text(
                      "Kaydol!",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
                },
                child: const Text(
                  "Şifremi Unuttum!",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
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