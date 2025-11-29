// lib/main_screen.dart

import 'package:flutter/material.dart';
import 'home_page.dart'; // HomePage sınıfı için içe aktarma
import 'history_page.dart'; // HistoryPage sınıfı için içe aktarma

class MainScreen extends StatefulWidget {
  // MainScreen'in main.dart'ta const olarak çağrılmasına izin vermek için const eklendi
  const MainScreen({super.key}); 

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Alt menüde gösterilecek sayfalar
  // Widget'lar const olarak tanımlanmalıdır. Bu sayede yeniden render edilmezler.
  final List<Widget> _pages = const [
    HomePage(), // Index 0: Bugünün Menüsü
    HistoryPage(), // Index 1: Geçmiş Menüler
  ];

  @override
  Widget build(BuildContext context) {
    // Projenizin standart kırmızısı (Tekrar eden renk kodundan kaçınmak için değişken tanımlandı)
    const primaryColor = Color(0xFFDF0000); 

    return Scaffold(
      body: _pages[_currentIndex], // Aktif sayfayı göster

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primaryColor, // Seçili ikon rengi
        unselectedItemColor: Colors.grey, // Seçili olmayan ikon rengi
        type: BottomNavigationBarType.fixed, 
        backgroundColor: Colors.white, // Alt menü arka plan rengi eklendi

        onTap: (index) {
          // Tıklanan ikonun index'ini alıp state'i günceller
          setState(() {
            _currentIndex = index;
          });
        },

        // İkon tanımları const olarak bırakıldı
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Bugün',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Geçmiş',
          ),
        ],
      ),
    );
  }
}