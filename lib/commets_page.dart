// lib/commets_page.dart

import 'package:flutter/material.dart';

class CommentsPage extends StatefulWidget {
  // NOT: Bu liste, normalde bir API'den gelmeli ve bu sayfada değiştirilmemelidir.
  // Şu anda setState ile listenin değişmesi, sadece geçici olarak ekranda görünür.
  final List<Map<String, dynamic>> yorumlar;
  final bool yorumEklemeAcik;

  const CommentsPage({
    super.key,
    required this.yorumlar,
    this.yorumEklemeAcik = true,
  });

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController yorumController = TextEditingController();

  void yorumEkle() {
    if (yorumController.text.trim().isEmpty) return;

    // 🚨 UYARI: Gerçek uygulamada, bu metod sunucuya (API'ye) bir POST isteği göndermelidir.
    // Şimdilik sadece ekranda görünecek şekilde yerel olarak ekleniyor.
    setState(() {
      widget.yorumlar.add({
        "kullanici": "Sen (Geçici)",
        "yorum": yorumController.text,
        "begeni": 0,
        "begenmeme": 0,
      });
    });

    yorumController.clear();
    // Klavyeyi kapat
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // Renk sabitleri
    const primaryColor = Color(0xFFDF0000);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Yorumlar",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, 
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), 
      ),

      body: Column(
        children: [
          // YORUM LİSTESİ
          Expanded(
            child: widget.yorumlar.isEmpty
                ? const Center(
                    child: Text(
                      "Henüz yorum yok.",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.yorumlar.length,
                    itemBuilder: (context, index) {
                      final yorum = widget.yorumlar[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        elevation: 1, // Hafif gölge eklendi
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                yorum["kullanici"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: primaryColor, // Kullanıcı adı rengi
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                yorum["yorum"],
                                style: const TextStyle(fontSize: 15),
                              ),

                              const SizedBox(height: 10),

                              // 👍👎 BUTONLAR – sadece yorumEklemeAcik ise göster
                              if (widget.yorumEklemeAcik)
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // Bu kısım da normalde API'ye istek göndermeli
                                        setState(() {
                                          yorum["begeni"] += 1;
                                        });
                                      },
                                      icon: const Icon(Icons.thumb_up,
                                          color: Colors.green),
                                    ),
                                    Text(yorum["begeni"].toString()),

                                    const SizedBox(width: 20),

                                    IconButton(
                                      onPressed: () {
                                        // Bu kısım da normalde API'ye istek göndermeli
                                        setState(() {
                                          yorum["begenmeme"] += 1;
                                        });
                                      },
                                      icon: const Icon(Icons.thumb_down,
                                          color: Colors.red),
                                    ),
                                    Text(yorum["begenmeme"].toString()),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // YORUM EKLEME ALANI – sadece yorumEklemeAcik ise göster
          if (widget.yorumEklemeAcik)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Daha açık gri yapıldı
                border: const Border(top: BorderSide(color: Colors.grey)),
              ),
              child: SafeArea( 
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: yorumController,
                        decoration: const InputDecoration(
                          hintText: "Yorum yaz...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: yorumEkle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor, // Kırmızı renk kullanıldı
                      ),
                      child: const Text(
                        "Gönder",
                        style: TextStyle(color: Colors.white), 
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}