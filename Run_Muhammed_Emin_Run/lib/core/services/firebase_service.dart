import 'package:flutter/foundation.dart';

class LeaderboardEntry {
  final String nickname;
  final int score;
  final String rank; // e.g. "1", "2", "3"

  LeaderboardEntry({required this.nickname, required this.score, required this.rank});
}

class FirebaseService {
  // Aşama 1: Mock (Sahte) Veri
  // Aşama 2'de burası gerçek Cloud Firestore bağlantısı ile değiştirilecek.
  
  static Future<void> submitScore(String nickname, int score) async {
    // Gerçek sürümde: await FirebaseFirestore.instance.collection('leaderboard').doc(nickname).set({...})
    if (kDebugMode) {
      print('Mock Firebase: Skor başarıyla gönderildi -> $nickname: $score');
    }
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<List<LeaderboardEntry>> getLeaderboard() async {
    // Gerçek sürümde: veriler Firestore'dan 'score' değerine göre azalan şekilde (descending) çekilecek.
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      LeaderboardEntry(nickname: 'KelimeUstasI', score: 2500, rank: '1'),
      LeaderboardEntry(nickname: 'CevapGibi', score: 2100, rank: '2'),
      LeaderboardEntry(nickname: 'SoruBükücü', score: 1850, rank: '3'),
      LeaderboardEntry(nickname: 'ProOyuncu', score: 1600, rank: '4'),
      LeaderboardEntry(nickname: 'TriviaKral', score: 1400, rank: '5'),
      LeaderboardEntry(nickname: 'GeceKuşu', score: 1200, rank: '6'),
      LeaderboardEntry(nickname: 'HızlıBilen', score: 950, rank: '7'),
    ];
  }
}
