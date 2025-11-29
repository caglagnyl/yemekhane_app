// lib/history_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih formatı için eklendi
import 'commets_page.dart'; // Yorum sayfasını import etmeyi unutma!

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Fake örnek veriler (sen backend'e bağlayınca burayı değiştireceksin)
  List<Map<String, dynamic>> menus = [
    {
      "tarih": DateTime(2025, 11, 26),
      "yemekler": "Kuru Fasulye, Pilav, Salata, Ayran",
      "puan": 4.2,
      "yorumSayisi": 23,
      "yorumlar": [
        {
          "kullanici": "Ali Y.",
          "yorum": "Lezzetliydi, özellikle fasulye çok iyiydi!",
          "begeni": 4,
          "begenmeme": 1
        },
        {
          "kullanici": "Zeynep A.",
          "yorum": "Pilav biraz kuru gibiydi.",
          "begeni": 3,
          "begenmeme": 0
        },
      ]
    },
    {
      "tarih": DateTime(2025, 11, 25),
      "yemekler": "Tavuk Sote, Makarna, Çorba, Tatlı",
      "puan": 3.7,
      "yorumSayisi": 12,
      "yorumlar": [
        {
          "kullanici": "Ahmet K.",
          "yorum": "Tatlı çok güzeldi!",
          "begeni": 5,
          "begenmeme": 0
        }
      ]
    },
    {
      "tarih": DateTime(2025, 11, 24),
      "yemekler": "Mantı, Salata, Ayran",
      "puan": 2.5,
      "yorumSayisi": 5,
      "yorumlar": [
        {
          "kullanici": "Elif M.",
          "yorum": "Mantının hamuru biraz kalındı.",
          "begeni": 2,
          "begenmeme": 1
        }
      ]
    },
  ];

  // 🔥 Tek butonlu filtre menüsü
  Widget buildFilterButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Sıralamada hata olmaması için 'double' veya 'int' karşılaştırması kullanıldı.
        if (value == "high") {
          setState(() {
            menus.sort((a, b) => b["puan"].compareTo(a["puan"]));
          });
        } else if (value == "low") {
          setState(() {
            menus.sort((a, b) => a["puan"].compareTo(b["puan"]));
          });
        } else if (value == "most_comments") {
          setState(() {
            menus.sort((a, b) => b["yorumSayisi"].compareTo(a["yorumSayisi"]));
          });
        } else if (value == "newest") {
          setState(() {
            menus.sort((a, b) => b["tarih"].compareTo(a["tarih"]));
          });
        } else if (value == "oldest") {
          setState(() {
            menus.sort((a, b) => a["tarih"].compareTo(b["tarih"]));
          });
        }
      },
      itemBuilder: (context) => const [
        // 🚨 Düzeltme: const eklendi
        PopupMenuItem(value: "high", child: Text("En Yüksek Puana Göre")),
        PopupMenuItem(value: "low", child: Text("En Düşük Puana Göre")),
        PopupMenuItem(value: "most_comments", child: Text("En Çok Yoruma Göre")),
        PopupMenuItem(value: "newest", child: Text("En Yeni Tarihe Göre")),
        PopupMenuItem(value: "oldest", child: Text("En Eski Tarihe Göre")),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Sırala", style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Geçmiş Menüler",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Renk düzeltildi
          ),
        ),
        backgroundColor: const Color(0xFFDF0000),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // İkon rengi düzeltildi
      ),
      body: Column(
        children: [
          // 🔽 Tek buton burada
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row( // Sıralama butonunu sola hizalamak için Row içine alındı
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildFilterButton(),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final menu = menus[index];

                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    
                    title: Text(
                      // 🚨 Düzeltme: Tarih formatı için DateFormat kullanıldı.
                      DateFormat('dd MMMM yyyy').format(menu['tarih']),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(menu["yemekler"]),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.orange.shade700),
                        // Puan virgülden sonra tek hane gösterildi.
                        Text(menu["puan"].toStringAsFixed(1)), 
                        const SizedBox(width: 10),
                        const Icon(Icons.comment),
                        Text(menu["yorumSayisi"].toString()),
                      ],
                    ),

                    // ⭐ TIKLANDIĞINDA YORUMLARI GÖSTER
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CommentsPage(
                            // 🚨 Düzeltme: Veri tipini korumak için 'List.from' kullanıldı
                            yorumlar: List<Map<String, dynamic>>.from(
                                menu["yorumlar"]),
                            yorumEklemeAcik: false, // geçmişte ekleme yok
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}