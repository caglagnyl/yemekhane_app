// lib/rate_page.dart

import 'package:flutter/material.dart';

class RatePage extends StatefulWidget {
  const RatePage({super.key});

  @override
  State<RatePage> createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  double selectedRating = 0;
  // Kırmızı rengi tanımlandı
  final Color primaryColor = const Color(0xFFDF0000); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Puan Ver",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, 
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Bugünün menüsünü nasıl değerlendirirsin?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // ⭐⭐⭐⭐⭐ Yıldızlar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // List.generate const olamaz, çünkü IconButton listesi değişiyor
            children: List.generate(5, (index) { 
              return IconButton(
                icon: Icon(
                  Icons.star,
                  color: selectedRating >= index + 1
                      ? Colors.orange
                      : Colors.grey,
                  size: 40, // Boyut biraz büyütüldü
                ),
                onPressed: () {
                  setState(() {
                    selectedRating = (index + 1).toDouble();
                  });
                },
              );
            }),
          ),
          
          // Seçili puanı göstermek için metin
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              selectedRating > 0 ? "${selectedRating.toInt()} / 5" : "Puan seçiniz",
              style: TextStyle(fontSize: 18, color: selectedRating > 0 ? primaryColor : Colors.grey),
            ),
          ),


          const SizedBox(height: 30),

          ElevatedButton(
            // Puan seçilmediyse butonu devre dışı bırak
            onPressed: selectedRating == 0
                ? null 
                : () {
                    // API çağrısı yapılmadan önce, puanı bir önceki sayfaya geri gönderir.
                    Navigator.pop(context, selectedRating);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Köşeler yuvarlatıldı
              disabledBackgroundColor: Colors.grey.shade400, // Devre dışı rengi eklendi
            ),
            child: const Text(
              "Gönder",
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: Colors.white, 
              ),
            ),
          )
        ],
      ),
    );
  }
}