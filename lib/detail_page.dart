// lib/detail_page.dart

import 'package:flutter/material.dart';

// 📌 Geçici yorum listesi
final List<Map<String, dynamic>> fakeComments = [
  {
    "kullanici": "Ahmet K.",
    "yorum": "Çok lezzetliydi, özellikle fasulye harikaydı!",
    "puan": 5
  },
  {
    "kullanici": "Zeynep Y.",
    "yorum": "Biraz tuzlu ama genel olarak fena değil.",
    "puan": 3
  },
  {
    "kullanici": "Emre T.",
    "yorum": "Ekmeğin içinde sert parçalar vardı. Beğenmedim.",
    "puan": 2
  },
];

class DetailPage extends StatelessWidget {
  final String yemekAdi;
  final String aciklama;
  final double puan;
  final int yorumSayisi;
  final String imageUrl;

  const DetailPage({
    super.key,
    required this.yemekAdi,
    required this.aciklama,
    required this.puan,
    required this.yorumSayisi,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Projenizin standart kırmızısı
    const primaryColor = Color(0xFFDF0000); 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        // Renk düzeltmesi
        title: Text(yemekAdi, style: const TextStyle(color: Colors.white)), 
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üstte resim
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 16),

            // Yemek adı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                yemekAdi,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Açıklama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                aciklama,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 12),

            // ⭐ Puan ve 💬 yorum sayısı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 22),
                  Text(
                    " ${puan.toStringAsFixed(1)}", // 1 hane gösterimi
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.comment, color: primaryColor, size: 22),
                  Text(
                    " $yorumSayisi yorum",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // Kullanıcı Yorumları Başlığı
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Kullanıcı Yorumları",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // 📝 Yorum Listesi (ListView Builder ile düzeltildi)
            // ListView'ı SingleChildScrollView içinde kullandığımız için ShrinkWrap: true kullanılmalı
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(), // Dıştaki ScrollView'in kaymasını engelle
              shrinkWrap: true,
              itemCount: fakeComments.length, // Dinamik uzunluk kullan
              itemBuilder: (context, index) {
                final yorum = fakeComments[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(yorum["kullanici"]),
                  subtitle: Text(yorum["yorum"]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text("${yorum["puan"]}"),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            
            // 📌 Ortalama puan kartı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 30),
                        const SizedBox(width: 6),
                        Text(
                          puan.toStringAsFixed(1),
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "$yorumSayisi Oy",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Yorumları Gör ve Puan Ver Butonları
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // YORUMLARI GÖSTER (Dialog kullanmak yerine doğrudan CommentsPage'e gitmek daha iyi)
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: const Text("Yorumlar"),
                              // ... (Dialog içeriği eski kodda olduğu gibi kaldı, isterseniz CommentsPage'e yönlendirebiliriz)
                              content: SizedBox(
                                width: double.maxFinite,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: fakeComments.map((yorum) {
                                    return ListTile(
                                      leading: const Icon(Icons.person),
                                      title: Text(yorum["kullanici"]),
                                      subtitle: Text(yorum["yorum"]),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.star, color: Colors.orange, size: 18),
                                          Text("${yorum["puan"]}"),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Kapat"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Yorumları Gör",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // PUAN VERME DİYALOĞU
                        // ... (Puan verme dialog içeriği eski kodda olduğu gibi kaldı)
                        showDialog(
                          context: context,
                          builder: (context) {
                            int secilenPuan = 0;

                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text("Puan Ver"),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: List.generate(5, (index) {
                                      return IconButton(
                                        onPressed: () {
                                          setState(() {
                                            secilenPuan = index + 1;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.star,
                                          size: 32,
                                          color: (index < secilenPuan)
                                              ? Colors.orange
                                              : Colors.grey,
                                        ),
                                      );
                                    }),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("İptal"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Puanınız kaydedildi: $secilenPuan ⭐"),
                                          ),
                                        );
                                      },
                                      child: const Text("Kaydet"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Puan Ver",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}