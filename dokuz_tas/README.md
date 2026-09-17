# 🏛️ Dokuz Taş (Nine Men's Morris) - Premium

Modern, şık ve animasyonlu bir arayüzle klasik **Dokuz Taş** oyununun yeniden yorumlanmış hali. Flutter kullanılarak hem iOS hem de Android için tasarlanmıştır.

## 🌟 Özellikler

*   **🎮 Üç Farklı Oyun Modu:**
    *   **Tek Oyuncu (PvE):** Gelişmiş yapay zekaya (Minimax, Alpha-Beta Pruning, Transposition Table) karşı mücadele edin.
    *   **İki Oyuncu (PvP):** Aynı cihaz üzerinde arkadaşınızla yüz yüze oynayın.
    *   **Turnuva Modu:** Çırak seviyesinden Efsane seviyesine kadar kademeli olarak zorlaşan yapay zekaya karşı yarışın ve performansınıza göre (1 ile 3 arası) yıldız toplayın.
    *   **Bluetooth/Yerel Ağ:** `nearby_connections` paketi ile iki farklı cihaz arasında kablosuz olarak maç yapın.

*   **🧠 Akıllı Yapay Zeka (AI):**
    *   Derinliği (Depth) 5'e kadar çıkabilen gelişmiş satranç motoru benzeri bir mimari.
    *   *Move Ordering* (Hamle Önceliği) ve *Transposition Table* (Durum Belleği) algoritmaları sayesinde ışık hızında ve ölümcül zekada tepkiler.
    *   Kolay, Orta ve Zor olmak üzere 3 farklı zorluk derecesi. Zor seviyede sadece taş yemeye değil, taşlarınızı sıkıştırıp sizi kilitlemeye odaklanır.

*   **🎨 Premium Arayüz ve Temalar:**
    *   **Klasik Ahşap:** Nostaljik ve sıcak dokular.
    *   **Antik Mermer:** Sade, aydınlık ve şık mermer taşlar.
    *   **Neon Cyberpunk:** Karanlık tema, parlak neon taşlar ve siberpunk bir atmosfer.
    *   Etkileyici taş hareket animasyonları, pürüzsüz geçişler ve kazanma anında ekranda beliren **konfeti şöleni**.

*   **🔊 Görsel ve İşitsel Geri Bildirim:**
    *   Taş koyma, taş yeme ve üçlü (mill) yapma durumları için özel ses efektleri.
    *   Hamle yapıldığında cihazın titremesi (Haptic Feedback) ile daha gerçekçi bir hissiyat.

## 🚀 Kurulum

1. Bilgisayarınızda Flutter'ın yüklü olduğundan emin olun. Değilse [Flutter resmi sitesinden](https://docs.flutter.dev/get-started/install) indirebilirsiniz.
2. Projeyi klonlayın veya indirin.
3. Terminal (Komut İstemi) üzerinden proje klasörüne gidin.
4. Gerekli bağımlılıkları yüklemek için aşağıdaki komutu çalıştırın:
   ```bash
   flutter pub get
   ```
5. Uygulamayı bir simülatörde veya gerçek cihazda başlatmak için:
   ```bash
   flutter run
   ```

## 🛠️ Kullanılan Teknolojiler

*   **Flutter & Dart:** Uygulamanın geliştirildiği temel altyapı.
*   **shared_preferences:** Turnuva yıldızlarını ve oyuncu tercihlerini yerel hafızaya kaydetmek için.
*   **audioplayers:** Zengin oyun ses efektlerini çalmak için.
*   **confetti:** Galibiyet anlarında görsel bir şölen yaratmak için.
*   **nearby_connections:** İnternete ihtiyaç duymadan cihazlar arası iletişim kurabilmek için.

## 📝 Nasıl Oynanır?

Dokuz Taş (Nine Men's Morris), dünyanın en eski masa oyunlarından biridir:
1. **Yerleştirme (Placing):** Oyun alanı boştur. Her oyuncunun 9 taşı vardır ve sırayla boş noktalara koyarlar.
2. **Hareket (Moving):** Tüm taşlar konulduktan sonra oyuncular taşlarını sadece komşu boş çizgilere sürükler.
3. **Uçma (Flying):** Bir oyuncunun sadece 3 taşı kaldığında, taşını herhangi bir boş alana "uçurabilir".

**Amaç:** Kendi 3 taşınızı dikey veya yatay olarak yan yana (mill) getirin. Her 3'lü yaptığınızda rakibin tahtadaki (üçlü içinde olmayan) bir taşını silebilirsiniz. Rakibin sadece 2 taşı kaldığında veya yapacak hamlesi (kilit) kalmadığında oyunu kazanırsınız!

---
*İyi oyunlar! Stratejinizi konuşturun.*
