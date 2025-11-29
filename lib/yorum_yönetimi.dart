// lib/yorum_yönetimi.dart

import 'package:flutter/material.dart';

class YorumYonetimiPage extends StatefulWidget {
  // NOT: Bu sayfadaki yorumlar API'den çekilmelidir (initState içinde).
  const YorumYonetimiPage({super.key});

  @override
  State<YorumYonetimiPage> createState() => _YorumYonetimiPageState();
}

class _YorumYonetimiPageState extends State<YorumYonetimiPage> {
  // Test amaçlı geçici veri
  List<Map<String, dynamic>> yorumlar = [
    {
      "id": 1,
      "kullanici": "Mehmet",
      "yorum": "Bugünkü yemek çok iyiydi",
      "begeni": 12,
      "begenmeme": 1,
    },
    {
      "id": 2,
      "kullanici": "Ayşe",
      "yorum": "Pilav biraz yağlıydı",
      "begeni": 3,
      "begenmeme": 5,
    },
    {
      "id": 3,
      "kullanici": "Gizem",
      "yorum": "Mantı harikaydı, puanım 5/5",
      "begeni": 7,
      "begenmeme": 0,
    },
  ];

  // Silme işlemi
  void yorumSil(int index) {
    // Gerçek uygulamada, bu işlemden önce API çağrısı yapılmalıdır.
    setState(() {
      yorumlar.removeAt(index);
      // Başarılı bildirim
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Yorum başarıyla silindi.")),
      );
    });
  }

  // Beğeni/Beğenmeme sıfırlama işlemi
  void resetLike(int index) {
    // Gerçek uygulamada, bu işlemden önce API çağrısı yapılmalıdır.
    setState(() {
      yorumlar[index]["begeni"] = 0;
      yorumlar[index]["begenmeme"] = 0;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Beğeni/Beğenmeme sayıları sıfırlandı.")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFDF0000);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Yorum Yönetimi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: yorumlar.isEmpty
          ? const Center(
              child: Text("Henüz yönetilecek yorum yok."),
            )
          : ListView.builder(
              itemCount: yorumlar.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final yorum = yorumlar[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2, // Hafif gölge eklendi
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const Icon(Icons.comment, color: primaryColor),
                    title: Text(
                      yorum["yorum"],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kullanıcı: ${yorum["kullanici"]}", 
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          const SizedBox(height: 4),
                          // Beğeni/Beğenmeme Sayıları
                          Row(
                            children: [
                              const Icon(Icons.thumb_up, color: Colors.green, size: 16),
                              Text(" ${yorum["begeni"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 15),
                              const Icon(Icons.thumb_down, color: Colors.red, size: 16),
                              Text(" ${yorum["begenmeme"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == "sil") yorumSil(index);
                        if (value == "reset") resetLike(index);
                      },
                      itemBuilder: (context) => const [
                        // const kullanımı eklendi
                        PopupMenuItem(
                          value: "sil",
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text("Yorumu Sil"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: "reset",
                          child: Row(
                            children: [
                              Icon(Icons.thumb_up_off_alt, color: Colors.blue),
                              SizedBox(width: 8),
                              Text("Beğenileri Sıfırla"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}