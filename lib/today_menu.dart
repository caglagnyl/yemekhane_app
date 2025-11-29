// lib/today_menu.dart

import 'package:flutter/material.dart';
import 'menu_model.dart';
import 'menu_service.dart'; // <-- KRİTİK EKLEME: MenuService sınıfı için gerekli

class TodayMenuPage extends StatefulWidget {
  const TodayMenuPage({super.key});

  @override
  State<TodayMenuPage> createState() => _TodayMenuPageState();
}

class _TodayMenuPageState extends State<TodayMenuPage> {
  // Veriyi FutureBuilder ile çekeceğimiz için 'late' kullanıldı.
  late Future<MenuModel> futureMenu;

  @override
  void initState() {
    super.initState();
    // MenuService'i çağırarak veriyi çekmeye başla.
    futureMenu = MenuService().fetchTodayMenu(); 
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFDF0000); 

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bugünün Menüsü",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<MenuModel>(
        future: futureMenu,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Hata mesajı daha belirginleştirildi.
            return Center(child: Text("Veri yüklenirken hata oluştu: ${snapshot.error}")); 
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Bugünün menüsü bulunamadı."));
          }

          final menu = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Text(
                  // Tarih verisinin düzgün formatlanması gerekebilir (MenuModel'de String tutuluyor)
                  menu.tarih, 
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              const Text("Yemekler:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),

              // Yemekleri Listeleme
              ...menu.yemekler.map((yemek) => Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.lunch_dining, color: Colors.blueGrey),
                      title: Text(
                        yemek,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  )),

              const SizedBox(height: 20),
              
              // Puan Kartı
              Card(
                color: Colors.grey.shade100,
                elevation: 1,
                child: ListTile(
                  leading: const Icon(Icons.star, color: Colors.orange),
                  // Puanın virgülden sonra tek hane gösterilmesi için
                  title: Text("Ortalama Puan: ${menu.ortalamaPuan.toStringAsFixed(1)}"), 
                  subtitle: Text(
                      "Puanlayan kişi sayısı: ${menu.puanlayanKisiSayisi}"),
                ),
              ),

              const SizedBox(height: 20),
              
              // Yorumları Gör Butonu
              ElevatedButton(
                onPressed: () {
                  // '/comments' rotasına menü ID'si gönderilir.
                  Navigator.pushNamed(context, "/comments", arguments: menu.id); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                ),
                child: const Text(
                  "Yorumları Gör",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}