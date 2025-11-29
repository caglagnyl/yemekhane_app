// lib/home_page.dart
// lib/home_page.dart dosyasının en üst kısmı

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

// Projenin diğer dosyalarından yapılan içe aktarmalar
import 'menu_model.dart'; 
import 'menu_service.dart'; // Bu da olmalı
import 'commets_page.dart';
import 'rate_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  MenuModel? todayMenu;

  @override
  void initState() {
    super.initState();
    // Dil ayarı burada yapılırsa intl paketi doğru çalışır.
    Intl.defaultLocale = 'tr_TR'; 
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    try {
      // MenuService sınıfı artık import edildiği için burada hata vermez.
      todayMenu = await MenuService().fetchTodayMenu();
    } catch (e) {
      // Hata oluşursa menüyü null yapalım ve kullanıcıya gösterelim.
      print("Menü çekme hatası: $e");
      todayMenu = null; 
    }
    
    // Yalnızca build metodunun tekrar çalışmasını tetikler.
    if(mounted) { 
        setState(() {
            isLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bugünün Menüsü",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), // Renk eklendi
        ),
        backgroundColor: const Color(0xFFDF0000),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // İkon rengi eklendi

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Çıkış yapma dialog kutusu
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Çıkış Yap"),
                    content: const Text("Çıkış yapmak istediğinize emin misiniz?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); 
                        },
                        child: const Text("İptal"),
                      ),
                      TextButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('loggedIn', false);
                          await prefs.remove('role');

                          Navigator.pop(context);
                          // Giriş sayfasına yönlendirme (main.dart'ta /login rotası tanımlı olmalı)
                          Navigator.pushReplacementNamed(context, '/login'); 
                        },
                        child: const Text(
                          "Evet",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : todayMenu == null
              ? const Center(child: Text("Menü bulunamadı veya sunucuya ulaşılamadı!"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 📌 Tarih
                      Text(
                        // initState'te tr_TR ayarlandığı için format sorunsuz çalışır.
                        DateFormat("dd MMMM yyyy").format(DateTime.now()), 
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 20),

                      /// 📌 Yemekler listesi
                      const Text(
                        "📌 Bugünün Yemekleri:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 10),

                      // Yemek listesi (Listeyi kaydırılabilir yapmak için Expanded eklendi)
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: todayMenu!.yemekler.map((yemek) {
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.restaurant_menu),
                                title: Text(yemek),
                              ),
                            );
                          }).toList(),
                        ),
                      ),


                      const SizedBox(height: 20),

                      /// ⭐ Ortalama puan ve yorum sayısı
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange),
                          const SizedBox(width: 6),
                          Text(
                            // Puanı virgülden sonra tek hane gösterelim.
                            todayMenu!.ortalamaPuan.toStringAsFixed(1), 
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 20),
                          const Icon(Icons.comment, color: Colors.blue),
                          const SizedBox(width: 6),
                          Text(
                            "${todayMenu!.puanlayanKisiSayisi} yorum",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// 🔥 Yorumları Gör + Puan Ver (YAN YANA)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Yorumların API'den çekilmesi daha iyi olur. 
                                // Şu an örnek verilerle yorum sayfası açılıyor.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentsPage(
                                      yorumlar: [
                                        {
                                          "kullanici": "Ali Y.",
                                          "yorum": "Yemekler çok lezzetliydi!",
                                          "begeni": 4,
                                          "begenmeme": 1,
                                        },
                                        {
                                          "kullanici": "Zeynep A.",
                                          "yorum": "Pilav biraz kuru gibiydi ama genel olarak iyiydi.",
                                          "begeni": 3,
                                          "begenmeme": 0,
                                        },
                                        {
                                          "kullanici": "Mehmet K.",
                                          "yorum": "Tatlı mükemmeldi!",
                                          "begeni": 6,
                                          "begenmeme": 0,
                                        },
                                      ],
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                "💬 Yorumları Gör",
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Renk eklendi
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final result = await Navigator.push<double>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RatePage(),
                                  ),
                                );

                                if (result != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Verdiğin puan: $result ⭐")),
                                  );
                                  // Puan verildikten sonra menüyü tekrar çekerek güncel puanı gösterebiliriz.
                                  await fetchMenu(); 
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                "⭐ Puan Ver",
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Renk eklendi
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}