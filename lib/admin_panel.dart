// lib/admin_panel.dart

import 'package:flutter/material.dart';
// yorum_yönetimi.dart dosyası, YorumYonetimiPage sınıfını içermeli.
import 'yorum_yönetimi.dart'; 
// Kullanıcı yönetimi için bu dosya adını varsaydım.
import 'user_data.dart'; 
// Bugünün ve geçmişin menüsü için bu dosyaları da import etmelisiniz.
import 'today_menu.dart'; 
import 'history_page.dart'; 

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key}); 

  @override
  Widget build(BuildContext context) {
    // Projenin ana rengi
    const primaryColor = Color(0xFFDF0000);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Paneli",
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), 
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // SharedPreferences temizleme ve ana sayfaya yönlendirme eklenmeli
              // (Burada sadece rotayı temizleme yapılıyor, SharedPreferences main.dart'ta yapılmalı)
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/login",
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. YORUM YÖNETİMİ
          adminButton(
            context,
            "Yorum Yönetimi",
            // Eğer YorumYonetimiPage bir StatelessWidget ise const eklenmeli
            const YorumYonetimiPage(), 
            icon: Icons.comment_bank,
          ),
          
          // 2. BUGÜNÜN MENÜSÜ (Görüntüleme/Düzenleme)
          adminButton(
            context, 
            "Bugünün Menüsü", 
            // Admin için ayrı bir menü yönetimi sayfası olmalı. Şimdilik TodayMenuPage kullanıldı.
            const TodayMenuPage(), 
            icon: Icons.restaurant_menu,
          ),
          
          // 3. YARININ MENÜSÜ (Ekleme/Düzenleme)
          adminButton(
            context, 
            "Yarının Menüsü", 
            const Placeholder(), // Placeholder() burada geçici olarak bırakıldı.
            icon: Icons.calendar_today,
          ),
          
          // 4. GEÇMİŞ MENÜLER
          adminButton(
            context, 
            "Geçmiş Menüler", 
            const HistoryPage(), // Mevcut HistoryPage kullanıldı.
            icon: Icons.history,
          ),
          
          // 5. KULLANICI YÖNETİMİ
          adminButton(
            context, 
            "Kullanıcı Yönetimi", 
            // Kullanıcı yönetimi sayfasının adını varsaydım
            const UserDataPage(), // Örneğin bu sınıfı içeren user_data.dart dosyası olmalı
            icon: Icons.people,
          ),
          
          // 6. SIRALAMA / FİLTRELEME (Raparlama)
          adminButton(
            context, 
            "Sıralama / Filtreleme", 
            const Placeholder(), 
            icon: Icons.filter_list,
          ),
          
          // 7. ADMİN PROFİLİ
          adminButton(
            context, 
            "Admin Profil", 
            const Placeholder(), 
            icon: Icons.admin_panel_settings,
          ),
        ],
      ),
    );
  }
}

// Global olarak tanımlanan Admin Paneli Buton Widget'ı
Widget adminButton(BuildContext context, String title, Widget page, {required IconData icon}) {
  const primaryColor = Color(0xFFDF0000);

  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: primaryColor, width: 2),
        ),
        elevation: 0, 
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Row(
        children: [
          Icon(icon, color: primaryColor), 
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}